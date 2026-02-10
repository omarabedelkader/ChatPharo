Class {
	#name : 'ChatPharoCommandParserTest',
	#superclass : 'TestCase',
	#instVars : [
		'parser',
		'chat',
		'mockAgent'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoCommandParserTest >> setUp [

	super setUp.
	ChatPharoSettings default welcomeMessageEnabled: false.
	parser := ChatPharoCommandParser default.
	mockAgent := ChatPharoMockAgent new.
	chat := ChatPharoChat new agent: mockAgent
]

{ #category : 'running' }
ChatPharoCommandParserTest >> tearDown [

	ChatPharoSettings resetDefault.
	super tearDown
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testClearCommandExecution [

	| result response initialCount |
	"Add some messages first"
	chat addUserMessage: 'Test message 1'.
	chat addUserMessage: 'Test message 2'.
	initialCount := chat messages size.

	self assert: initialCount equals: 2.

	"Execute clear command"
	result := parser parse: '/clear'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'cleared').
	self assert: chat messages size equals: 0
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testCommandWithArgs [

	| result |
	result := parser parse: '/export json full'.

	self assert: result isCommand.
	self assert: result commandName equals: 'export'.
	self assert: result args size equals: 2.
	self assert: result args first equals: 'json'.
	self assert: result args second equals: 'full'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testCustomCommandRegistration [

	| result response customExecuted |
	customExecuted := false.

	"Register a custom command"
	parser register: 'custom' handler: [ :c :args |
		customExecuted := true.
		'Custom command executed!' ].

	"Execute the custom command"
	result := parser parse: '/custom'.
	response := result execute: chat.

	self assert: customExecuted.
	self assert: response equals: 'Custom command executed!'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testDetectAtMention [

	| result |
	result := parser parse: '@agent'.

	self assert: result isCommand.
	self assert: result commandName equals: 'agent'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testDetectSlashCommand [

	| result |
	result := parser parse: '/help'.

	self assert: result isCommand.
	self assert: result commandName equals: 'help'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testEmptyStringIsNotCommand [

	| result |
	result := parser parse: ''.

	self deny: result isCommand
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testExportCommandExecution [

	| result response |
	"Add some messages first"
	chat addUserMessage: 'Test message'.

	"Execute export command"
	result := parser parse: '/export'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'exported').
	self assert: (response includesSubstring: 'clipboard')
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testHelpCommandExecution [

	| result response |
	result := parser parse: '/help'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'Available Commands').
	self assert: (response includesSubstring: '/help').
	self assert: (response includesSubstring: '/clear')
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testHistoryCommandExecution [

	| result response |
	"Add some messages first"
	chat addUserMessage: 'Test message 1'.
	chat addUserMessage: 'Test message 2'.

	"Execute history command"
	result := parser parse: '/history'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'History').
	self assert: (response includesSubstring: 'Messages: 2')
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testIsCommandMethodWorks [

	self assert: (parser isCommand: '/help').
	self assert: (parser isCommand: '@mention').
	self deny: (parser isCommand: 'regular text').
	self deny: (parser isCommand: 'text with / in middle')
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testRegularTextIsNotCommand [

	| result |
	result := parser parse: 'Hello, how are you?'.

	self deny: result isCommand.
	self assert: result text equals: 'Hello, how are you?'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testResetCommandExecution [

	| result response initialCount |
	"Add some messages first"
	chat addUserMessage: 'Test message 1'.
	chat addUserMessage: 'Test message 2'.
	initialCount := chat messages size.

	self assert: initialCount equals: 2.

	"Execute reset command"
	result := parser parse: '/reset'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'reset').
	"After reset, if welcome message is disabled, should be 0, else 1"
	"Since we disabled it in setUp, should be 0"
	self assert: chat messages size equals: 0
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testTextWithSlashInMiddleIsNotCommand [

	| result |
	result := parser parse: 'This is a/slash in the middle'.

	self deny: result isCommand.
	self assert: result text equals: 'This is a/slash in the middle'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testUnknownCommandExecution [

	| result response |
	result := parser parse: '/unknowncommand'.
	response := result execute: chat.

	self assert: (response includesSubstring: 'Unknown command').
	self assert: (response includesSubstring: 'unknowncommand')
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testUnknownCommandIsDetected [

	| result |
	result := parser parse: '/unknowncommand'.

	self assert: result isCommand.
	self assert: result isUnknown.
	self assert: result commandName equals: 'unknowncommand'
]

{ #category : 'running' }
ChatPharoCommandParserTest >> testWhitespaceAroundCommand [

	| result |
	result := parser parse: '  /help  '.

	self assert: result isCommand.
	self assert: result commandName equals: 'help'
]
