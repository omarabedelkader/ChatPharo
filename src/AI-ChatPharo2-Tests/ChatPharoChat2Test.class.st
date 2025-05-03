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
	mockApi := MockOllamaApi new.
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
