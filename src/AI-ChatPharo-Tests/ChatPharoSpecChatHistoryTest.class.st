Class {
	#name : 'ChatPharoSpecChatHistoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> setUp [

	super setUp.
	history := ChatPharoSpecChatHistory from: OrderedCollection new
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> tearDown [ 

	history := ChatPharoSpecChatHistory from: OrderedCollection new.
	super tearDown
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> testAddMessage [

    | message |
    message := ChatPharoHistorySaver role: 'user' content: 'Testing'.
    history addMessage: message.

    self assert: (history model includes: message).
    self assert: history panel children size equals: 1.
    self assert: (history panel children first model) equals: message.

]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> testInitializeWithExistingMessages [

	| messages newHistory |
	messages := OrderedCollection new
		add: (ChatPharoHistorySaver role: 'user' content: 'Hi');
		add: (ChatPharoHistorySaver role: 'assistant' content: 'Hello!');
		yourself.

	newHistory := ChatPharoSpecChatHistory from: messages.

	self assert: newHistory model size equals: 2.
	self assert: newHistory panel children size equals: 2.
	self assert: (newHistory panel children first model) equals: messages first.
	self assert: (newHistory panel children last model) equals: messages last.
]
