Class {
	#name : 'ChatPharoChat2Test',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'mockApi'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'running' }
ChatPharoChat2Test >> setUp [

	super setUp.
	mockApi := MockApi new.
	chat := ChatPharoChat2 new ollamaApi: mockApi
]

{ #category : 'running' }
ChatPharoChat2Test >> testCancelMessageTerminatesProcess [
	| procBefore |
	chat sendMessage: 'long task'.
	procBefore := chat instVarNamed: #promptProcess.
	chat cancelMessage.
	self assert: procBefore isTerminated.
]

{ #category : 'running' }
ChatPharoChat2Test >> testClearChatEmptiesMessagesAndStopsProcess [ 

	chat sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait.
	self assert: chat messages notEmpty.
	chat clearChat.
	self assert: chat messages isEmpty.
]

{ #category : 'running' }
ChatPharoChat2Test >> testWhenAnswerReceivedDoCallbackIsTriggered [ 

	| triggered |
	triggered := false.
	chat whenAnswerReceivedDo: [ :msg | triggered := true ].
	chat sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait.
	self assert: triggered.
]
