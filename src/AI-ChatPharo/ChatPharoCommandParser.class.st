"
Parses and handles special commands in chat prompts:
- Slash commands (/) for actions like /clear, /help, /reset, /export
- Mention commands (@) for special actions or agent switching
Usage:
```
parser := ChatPharoCommandParser new.
result := parser parse: '/clear'.
result isCommand ifTrue: [ result execute ]
```
"
Class {
	#name : 'ChatPharoCommandParser',
	#superclass : 'Object',
	#instVars : [
		'commands'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoCommandParser class >> default [
	"Return a default instance with standard commands registered"

	^ self new
		registerDefaultCommands;
		yourself
]

{ #category : 'commands' }
ChatPharoCommandParser >> clearChat: aChat [
	"Clear the chat history"

	aChat clearChat.
	ChatPharoLogger logSystem: 'Chat cleared via /clear command' details: (Dictionary new
		at: 'chatId' put: aChat identityHash;
		yourself).
	^ 'Chat cleared! Start a fresh conversation.'
]

{ #category : 'commands' }
ChatPharoCommandParser >> exportChat: aChat [
	"Export the chat as JSON"

	| json |
	json := aChat exportAsJson.
	Clipboard clipboardText: json.
	ChatPharoLogger logSystem: 'Chat exported via /export command' details: (Dictionary new
		at: 'chatId' put: aChat identityHash;
		at: 'messagesCount' put: aChat messages size;
		yourself).
	^ 'Chat exported to clipboard as JSON! (' , aChat messages size asString , ' messages)'
]

{ #category : 'parsing' }
ChatPharoCommandParser >> initialize [

	super initialize.
	commands := Dictionary new
]

{ #category : 'parsing' }
ChatPharoCommandParser >> isCommand: aString [
	"Check if the string starts with a command prefix (/ or @)"

	| trimmed |
	trimmed := aString trimBoth.
	^ trimmed notEmpty and: [
		(trimmed first = $/) or: [ trimmed first = $@ ] ]
]

{ #category : 'parsing' }
ChatPharoCommandParser >> parse: aString [
	"Parse the input string and return a ChatPharoCommandResult"

	| trimmed |
	trimmed := aString trimBoth.

	(self isCommand: trimmed) ifFalse: [
		^ ChatPharoCommandResult text: aString ].

	^ self parseCommand: trimmed
]

{ #category : 'private' }
ChatPharoCommandParser >> parseCommand: aString [

	"Parse a command string (starting with / or @) and return a result"

	| prefix commandPart args commandName |
	prefix := aString first.
	commandPart := aString allButFirst trimLeft.

	"Split command and arguments"
	args := commandPart substrings.
	commandName := args ifEmpty: [ '' ] ifNotEmpty: [ args first ].
	args := args allButFirst.

	"Look up the command handler"
	^ commands
		at: commandName
		ifPresent: [ :handler |
			ChatPharoCommandResult
				command: commandName
				args: args
				handler: handler
				prefix: prefix asString ]
		ifAbsent: [
			ChatPharoCommandResult
				unknownCommand: commandName
				prefix: prefix asString ]
]

{ #category : 'private' }
ChatPharoCommandParser >> register: commandName handler: aBlock [
	"Register a command handler. The block receives (chat, args) as parameters"

	commands at: commandName put: aBlock
]

{ #category : 'private' }
ChatPharoCommandParser >> registerDefaultCommands [
	"Register the default built-in commands"

	self register: 'help' handler: [ :chat :args | self showHelp: chat ].
	self register: 'clear' handler: [ :chat :args | self clearChat: chat ].
	self register: 'reset' handler: [ :chat :args | self resetChat: chat ].
	self register: 'export' handler: [ :chat :args | self exportChat: chat ].
	self register: 'history' handler: [ :chat :args | self showHistory: chat ]
]

{ #category : 'commands' }
ChatPharoCommandParser >> resetChat: aChat [
	"Reset the conversation"

	aChat resetConversation.
	ChatPharoLogger logSystem: 'Chat reset via /reset command' details: (Dictionary new
		at: 'chatId' put: aChat identityHash;
		yourself).
	^ 'Conversation reset! Previous messages cleared.'
]

{ #category : 'commands' }
ChatPharoCommandParser >> showHelp: aChat [
	"Show available commands"

	| help |
	help := String streamContents: [ :stream |
		stream nextPutAll: 'Available Commands:'; cr; cr.
		stream nextPutAll: '/help - Show this help message'; cr.
		stream nextPutAll: '/clear - Clear the chat history'; cr.
		stream nextPutAll: '/reset - Reset the conversation'; cr.
		stream nextPutAll: '/export - Export chat as JSON to clipboard'; cr.
		stream nextPutAll: '/history - Show conversation history'; cr; cr.
		stream nextPutAll: 'You can also use @ for special mentions (feature coming soon!)' ].

	ChatPharoLogger logSystem: 'Help displayed via /help command' details: (Dictionary new
		at: 'chatId' put: aChat identityHash;
		yourself).
	^ help
]

{ #category : 'commands' }
ChatPharoCommandParser >> showHistory: aChat [
	"Show conversation history summary"

	| summary messageCount |
	messageCount := aChat messages size.

	summary := String streamContents: [ :stream |
		stream nextPutAll: 'Conversation History'; cr.
		stream nextPutAll: 'Messages: ', messageCount asString; cr; cr.

		messageCount > 0 ifTrue: [
			aChat messages withIndexDo: [ :msg :idx |
				stream nextPutAll: idx asString, '. '.
				msg content ifNotNil: [ :c |
					stream nextPutAll: 'You: ', (c truncateTo: 50); cr ].
				msg answer ifNotNil: [ :a |
					stream nextPutAll: '   Bot: ', (a truncateTo: 50); cr ] ] ] ].

	ChatPharoLogger logSystem: 'History displayed via /history command' details: (Dictionary new
		at: 'chatId' put: aChat identityHash;
		at: 'messagesCount' put: messageCount;
		yourself).
	^ summary
]
