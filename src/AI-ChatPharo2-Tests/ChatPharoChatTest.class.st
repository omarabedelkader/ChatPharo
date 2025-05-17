Class {
	#name : 'ChatPharoChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'mockApi'
	],
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoChatTest >> setUp [

	super setUp.
	mockApi := MockApi new.
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

{ #category : 'running' }
ChatPharoChatTest >> testHistoryFormatsPairs [ 

    chat messages add: (ChatPharoMessage new
                            content: 'c';
                            answer: 'a').
    self assert: (chat history includesSubstring: 'User: c').
    self assert: (chat history includesSubstring: 'Assistant: a')
]

{ #category : 'running' }
ChatPharoChatTest >> testSendMessageForksProcess [ 
    | proc |
    chat sendMessage: 'x'.

    proc := chat instVarNamed: #promptProcess.
    self assert: proc notNil.
    self assert: proc ~~ Processor activeProcess
]

{ #category : 'running' }
ChatPharoChatTest >> testWhenAnswerReceivedDoCallbackIsTriggered [ 

	| triggered |
	triggered := false.
	chat whenAnswerReceivedDo: [ :msg | triggered := true ].
	chat sendMessage: 'Hello'.
	(Delay forMilliseconds: 10) wait.
	self assert: triggered.
]
