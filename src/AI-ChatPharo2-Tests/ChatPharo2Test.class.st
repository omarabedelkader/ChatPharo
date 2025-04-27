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
	"inject our mock into settings"
	app settings instVarNamed: #ollamaApi put: mockApi.
]

{ #category : 'running' }
ChatPharo2Test >> testAddNewChat [
	app newChat.
	self assert: app chats size equals: 1.
]

{ #category : 'running' }
ChatPharo2Test >> testClearChat [

	| chat message |
	chat := ChatPharoChat2 new.
	chat ollamaApi: mockApi .
	chat sendMessage: 'Hello'.
	message := chat messages anyOne.
	self assert: chat messages size equals: 1.
	chat clearChat.
	self assert: chat messages isEmpty.
]

{ #category : 'running' }
ChatPharo2Test >> testHistory [
	| chat |
	chat := ChatPharoChat2 new.
	chat ollamaApi: mockApi .
	mockApi responses: {
		'Hello' -> 'Hi there!'.
		'How are you?' -> 'I am fine, thank you.'
	} asDictionary.
	chat sendMessage: 'Hello'.
	chat sendMessage: 'How are you?'.
	self assert: chat history equals: 'User: Hello' , String cr , 'Assistant: Hi there!' , String cr , 'User: How are you?' , String cr , 'Assistant: I am fine, thank you.' , String cr.
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
ChatPharo2Test >> testOllamaApiAssignment [
	| settings api |
	settings := ChatPharoSettings2 new.
	api := OllamaApi new.
	settings ollamaApi: api.
	self assert: settings ollamaApi equals: api.
]

{ #category : 'running' }
ChatPharo2Test >> testSendMessage [
	| initialSize |
	initialSize := app chats size.
	app newChat.
	mockApi
		responses: { 'Test prompt' -> 'Test response' } asDictionary.
	app chats last sendMessage: 'Test prompt'.
	self assert: app chats last messages size equals: 1.
	self assert: app chats last messages last content equals: 'Test prompt'.
	self assert: app chats last messages last answer equals: 'Test response'.
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
ChatPharo2Test >> testSettings [
	self assert: app settings isKindOf: ChatPharoSettings2.
]

{ #category : 'running' }
ChatPharo2Test >> testUseModel [
	| settings |
	settings := ChatPharoSettings2 new.
	settings useModel: 'TestModel'.
	self assert: settings ollamaApi model equals: 'TestModel'.
]
