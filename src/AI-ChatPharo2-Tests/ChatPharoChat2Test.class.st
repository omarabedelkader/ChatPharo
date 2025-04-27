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
	mockApi := MockOllamaApi new.
	chat := ChatPharoChat2 new
		ollamaApi: mockApi.
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
ChatPharoChat2Test >> testClearChatResetsMessages [
	chat sendMessage: 'something'.
	chat instVarNamed: #promptProcess waitUntilTerminated.
	chat clearChat.
	self assert: chat messages isEmpty.
	self assert: chat history isEmpty.
]

{ #category : 'running' }
ChatPharoChat2Test >> testHistoryFormatsCorrectly [
	chat
		sendMessage: 'What is time?';
		sendMessage: 'And space?'.
	chat instVarNamed: #promptProcess wait.
	self
		assert: (chat history includesSubstring: 'User: What is time?'). "Fixed method"
	self
		assert: (chat history includesSubstring: 'Assistant: <<MOCK-DEFAULT-REPLY to: And space?>>').
]

{ #category : 'running' }
ChatPharoChat2Test >> testSendMessageAddsMessageAndUsesApi [
	chat sendMessage: 'Ping'.
	chat instVarNamed: #promptProcess suspend.  "ensure async finished"
	self assert: chat messages size equals: 1.
	self
		assert: chat messages first answer
		equals: '<<MOCK-DEFAULT-REPLY to: Ping>>'.
]
