"
Represents the result of parsing a chat prompt. Can be either:
- A regular text message (not a command)
- A valid command with handler
- An unknown/invalid command
"
Class {
	#name : 'ChatPharoCommandResult',
	#superclass : 'Object',
	#instVars : [
		'isCommand',
		'commandName',
		'args',
		'handler',
		'text',
		'prefix',
		'isUnknown'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'instance creation' }
ChatPharoCommandResult class >> command: aCommandName args: anArrayOfArgs handler: aBlock prefix: aPrefixString [
	"Create a valid command result"

	^ self new
		commandName: aCommandName;
		args: anArrayOfArgs;
		handler: aBlock;
		prefix: aPrefixString;
		isCommand: true;
		isUnknown: false;
		yourself
]

{ #category : 'instance creation' }
ChatPharoCommandResult class >> text: aString [
	"Create a regular text result (not a command)"

	^ self new
		text: aString;
		isCommand: false;
		yourself
]

{ #category : 'instance creation' }
ChatPharoCommandResult class >> unknownCommand: aCommandName prefix: aPrefixString [
	"Create an unknown command result"

	^ self new
		commandName: aCommandName;
		prefix: aPrefixString;
		isCommand: true;
		isUnknown: true;
		yourself
]

{ #category : 'accessing' }
ChatPharoCommandResult >> args [

	^ args
]

{ #category : 'accessing' }
ChatPharoCommandResult >> args: anObject [

	args := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> commandName [

	^ commandName
	
]

{ #category : 'accessing' }
ChatPharoCommandResult >> commandName: anObject [

	commandName := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> execute: aChat [
	"Execute the command with the given chat context"

	self isUnknown ifTrue: [
		^ 'Unknown command: ', prefix, commandName, '. Type /help for available commands.' ].

	self isCommand ifFalse: [
		^ self error: 'Cannot execute a non-command result' ].

	^ handler value: aChat value: args
]

{ #category : 'accessing' }
ChatPharoCommandResult >> handler [

	^ handler
]

{ #category : 'accessing' }
ChatPharoCommandResult >> handler: anObject [

	handler := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> isCommand [

	^ isCommand ifNil: [ false ]
]

{ #category : 'accessing' }
ChatPharoCommandResult >> isCommand: anObject [

	isCommand := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> isUnknown [

	^ isUnknown ifNil: [ false ]
]

{ #category : 'accessing' }
ChatPharoCommandResult >> isUnknown: anObject [

	isUnknown := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> prefix [

	^ prefix
]

{ #category : 'accessing' }
ChatPharoCommandResult >> prefix: anObject [

	prefix := anObject
]

{ #category : 'accessing' }
ChatPharoCommandResult >> text [

	^ text
]

{ #category : 'accessing' }
ChatPharoCommandResult >> text: anObject [

	text := anObject
]
