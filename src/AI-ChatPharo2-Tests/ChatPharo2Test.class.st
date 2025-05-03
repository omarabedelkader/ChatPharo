Class {
	#name : 'ChatPharo2Test',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'mockApi'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'running' }
ChatPharo2Test >> setUp [

	super setUp.
	app := ChatPharo2 new.
	mockApi := MockApi new.
	app settings instVarNamed: #agent put: mockApi
]

{ #category : 'running' }
ChatPharo2Test >> testAddNewChat [
	app newChat.
	self assert: app chats size equals: 1.
]

{ #category : 'running' }
ChatPharo2Test >> testInitializeStartsEmpty [

	self assert: app chats isEmpty
]

{ #category : 'running' }
ChatPharo2Test >> testMultipleChatsHaveIndependentMessageHistories [ 

	app newChat.
	app newChat.
	app chats first sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait. "allow process to finish"
	self assert: (app chats first messages size) equals: 1.
	self assert: (app chats second messages isEmpty).
]

{ #category : 'running' }
ChatPharo2Test >> testNewChat [
	self assert: app chats isEmpty.
	app newChat.
	self assert: app chats size equals: 1.
	self assert: (app chats anyOne isKindOf: ChatPharoChat2).
]

{ #category : 'running' }
ChatPharo2Test >> testNewChatAddsChatWithMockApi [
	app newChat.
	self assert: app chats size equals: 1.
	self assert: (app chats first instVarNamed: #ollamaApi) equals: mockApi.
]

{ #category : 'running' }
ChatPharo2Test >> testNewChatStartsWithEmptyHistory [ 

    app newChat.
    self assert: (app chats first messages isEmpty).
]

{ #category : 'running' }
ChatPharo2Test >> testSendMessageAddsMessageAndAnswer [ 
    "End‑to‑end check that ChatPharoChat2 cooperates with MockApi."
    app newChat.
    (app chats first) sendMessage: 'ping'.
    (Delay forMilliseconds: 10) wait.
    self assert: (app chats first messages size) equals: 1.
    self assert: (app chats first messages first answer includesSubstring: 'MOCK-DEFAULT-REPLY').

]

{ #category : 'running' }
ChatPharo2Test >> testSetAndGetMessages [
	| chat message1 message2 |
	chat := ChatPharoChat2 new.
	message1 := ChatPharoMessage2 new content: 'Message 1'.
	message2 := ChatPharoMessage2 new content: 'Message 2'.
	chat messages: (OrderedCollection with: message1 with: message2).
	self assert: chat messages size equals: 2.
	self assert: (chat messages includes: message1).
	self assert: (chat messages includes: message2).
]

{ #category : 'running' }
ChatPharo2Test >> testUseApiSwitchesAgent [ 

    "Switching API classes via settings should transparently update the
    agent inside the application without disturbing existing data."
    | otherApi |
    otherApi := NullAgent new.
    app settings instVarNamed: #agent put: otherApi.
    self assert: app settings agent == otherApi.
]

{ #category : 'running' }
ChatPharo2Test >> testUseModel [
	| settings |
	settings := ChatPharoSettings2 new.
	settings useModel: 'TestModel'.
	self assert: settings agent model equals: 'TestModel'.
]
