Class {
	#name : 'ChatPharoChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'mockApi'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoChatTest >> setUp [

	super setUp.
	mockApi := ChatPharoMockApi new.
	chat := ChatPharoChat new agent: mockApi
]

{ #category : 'running' }
ChatPharoChatTest >> testCancelMessageTerminatesProcess [
	| procBefore |
	chat sendMessage: 'long task'.
	procBefore := chat instVarNamed: #promptProcess.
	chat cancelMessage.
	self assert: procBefore isTerminated.
]

{ #category : 'running' }
ChatPharoChatTest >> testClearChatEmptiesMessagesAndStopsProcess [ 

	chat sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait.
	self assert: chat messages notEmpty.
	chat clearChat.
	self assert: chat messages isEmpty.
]
