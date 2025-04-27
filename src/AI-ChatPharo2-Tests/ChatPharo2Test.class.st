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

	app := ChatPharo2 new.
	mockApi := MockOllamaApi new.
	app settings instVarNamed: #ollamaApi put: mockApi
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
ChatPharo2Test >> testUseModel [
	| settings |
	settings := ChatPharoSettings2 new.
	settings useModel: 'TestModel'.
	self assert: settings ollamaApi model equals: 'TestModel'.
]
