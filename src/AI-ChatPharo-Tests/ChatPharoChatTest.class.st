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
	mockApi := ChatPharoMockAgent new.
	chat := ChatPharoChat new agent: mockApi
]

{ #category : 'running' }
ChatPharoChatTest >> testAgentSetsHistoryOnAccess [ 

    | nullAgent hist |
    nullAgent := ChatPharoNullAgent new.
    chat agent: nullAgent.
    hist := chat instVarNamed: #history.
    self assert: (chat agent history) == hist
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
ChatPharoChatTest >> testSendMessageAddsAssistantResponse [
    chat sendMessage: 'hi'.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: chat messages size equals: 1.
    self assert: (chat messages last answer) equals: '<<MOCK-DEFAULT-REPLY to: hi>>'.

]

{ #category : 'running' }
ChatPharoChatTest >> testWhenAnswerReceivedBlockCalled [
    | called |
    called := false.

    chat whenAnswerReceivedDo: [ :msg | 
        called := msg answer = '<<MOCK-DEFAULT-REPLY to: hi>>' 
    ].

    chat sendMessage: 'hi'.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: called.

]
