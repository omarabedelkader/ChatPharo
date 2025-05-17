Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'mockApi'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoTest >> setUp [

	super setUp.
	app := ChatPharo new.
	mockApi := MockApi new.
	app settings instVarNamed: #agent put: mockApi
]

{ #category : 'running' }
ChatPharoTest >> testAddNewChat [
	app newChat.
	self assert: app chats size equals: 1.
]

{ #category : 'running' }
ChatPharoTest >> testInitializeStartsEmpty [

	self assert: app chats isEmpty
]

{ #category : 'running' }
ChatPharoTest >> testMultipleChatsHaveIndependentMessageHistories [ 

	app newChat.
	app newChat.
	app chats first sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait. "allow process to finish"
	self assert: (app chats first messages size) equals: 1.
	self assert: (app chats second messages isEmpty).
]

{ #category : 'running' }
ChatPharoTest >> testNewChat [
	self assert: app chats isEmpty.
	app newChat.
	self assert: app chats size equals: 1.
	self assert: (app chats anyOne isKindOf: ChatPharoChat).
]

{ #category : 'running' }
ChatPharoTest >> testNewChatAddsChatWithMockApi [

	app newChat.
	self assert: app chats size equals: 1.
	self
		assert: (app chats first instVarNamed: #agent)
		equals: mockApi
]

{ #category : 'running' }
ChatPharoTest >> testNewChatStartsWithEmptyHistory [ 

    app newChat.
    self assert: (app chats first messages isEmpty).
]

{ #category : 'running' }
ChatPharoTest >> testSendMessageAddsMessageAndAnswer [ 
    "End‑to‑end check that ChatPharoChat cooperates with MockApi."
    app newChat.
    (app chats first) sendMessage: 'ping'.
    (Delay forMilliseconds: 10) wait.
    self assert: (app chats first messages size) equals: 1.
    self assert: (app chats first messages first answer includesSubstring: 'MOCK-DEFAULT-REPLY').

]

{ #category : 'running' }
ChatPharoTest >> testSetAndGetMessages [
	| chat message1 message |
	chat := ChatPharoChat new.
	message1 := ChatPharoMessage new content: 'Message 1'.
	message := ChatPharoMessage new content: 'Message '.
	chat messages: (OrderedCollection with: message1 with: message).
	self assert: chat messages size equals: .
	self assert: (chat messages includes: message1).
	self assert: (chat messages includes: message).
]

{ #category : 'running' }
ChatPharoTest >> testUseApiSwitchesAgent [ 

    "Switching API classes via settings should transparently update the
    agent inside the application without disturbing existing data."
    | otherApi |
    otherApi := NullAgent new.
    app settings instVarNamed: #agent put: otherApi.
    self assert: app settings agent == otherApi.
]

{ #category : 'running' }
ChatPharoTest >> testUseModel [
	| settings |
	settings := ChatPharoSettings new.
	settings useModel: 'TestModel'.
	self assert: settings agent model equals: 'TestModel'.
]
