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
	ChatPharoSettings default welcomeMessageEnabled: false.
	mockApi := ChatPharoMockAgent new.
	chat := ChatPharoChat new agent: mockApi
]

{ #category : 'running' }
ChatPharoChatTest >> tearDown [

        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoChatTest >> testAgentFailureReturnsErrorMessage [ 
    | failingAgent chat |
    failingAgent := ChatPharoNullAgent new.
    chat := ChatPharoChat new agent: failingAgent.

    chat sendMessage: 'this will fail'.

    [ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [
        (Delay forMilliseconds: 10) wait
    ].

    self assert: (chat messages last answer includesSubstring: 'No backend is configured').
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
ChatPharoChatTest >> testCancelTwiceIsSafe [ 
    chat sendMessage: 'something long'.
    (Delay forMilliseconds: 10) wait.

    chat cancelMessage.
    chat cancelMessage.

    self assert: (chat instVarNamed: #promptProcess) isTerminated.
]

{ #category : 'running' }
ChatPharoChatTest >> testClearCacheForcesBackendCall [

        | firstSize |
        chat sendMessage: 'hello'.
        [ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
        firstSize := mockApi history size.

        chat clearCache.
        chat sendMessage: 'hello'.
        [ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

        self assert: mockApi history size equals: firstSize + 1.

        chat sendMessage: 'hello'.

        self assert: mockApi history size equals: firstSize + 1.
]

{ #category : 'running' }
ChatPharoChatTest >> testClearChatClearsCache [ 

        | firstSize |
        chat sendMessage: 'hello'.
        [ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
        firstSize := mockApi history size.

        chat clearChat.

        self assert: mockApi history size equals: firstSize .
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
ChatPharoChatTest >> testEmptyMessageDoesNotCrash [ 

    chat sendMessage: ''.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: (chat messages select: [:msg | msg content notEmpty]) isEmpty.
]

{ #category : 'running' }
ChatPharoChatTest >> testManyChatsRemainIsolated [

	| chats |
	chats := (1 to: 5) collect: [ :i |
		         ChatPharoChat new agent: ChatPharoMockAgent new ].

	1 to: 5 do: [ :i | (chats at: i) sendMessage: 'msg' , i asString ].

	[
		chats allSatisfy: [ :c |
			(c instVarNamed: #promptProcess) isTerminated ] ] whileFalse: [
		(Delay forMilliseconds: 10) wait ].

	self assert: (chats allSatisfy: [ :c | c messages size = 1 ]).
	self assert:
		(chats collect: [ :c | c messages last answer ]) asSet size = 5
]

{ #category : 'running' }
ChatPharoChatTest >> testMockAgentSetsAssistantLabel [
    chat sendMessage: 'hi'.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: (chat messages last assistantLabel) equals: 'Assistant'.
]

{ #category : 'running' }
ChatPharoChatTest >> testMultipleChatsDoNotShareState [

	| chat1 chat2 |
	chat1 := ChatPharoChat new agent: ChatPharoMockAgent new.
	chat2 := ChatPharoChat new agent: ChatPharoMockAgent new.

	chat1 sendMessage: 'hello from chat1'.
	chat2 sendMessage: 'hello from chat2'.

	[
		(chat1 instVarNamed: #promptProcess) isTerminated and: [
			(chat2 instVarNamed: #promptProcess) isTerminated ] ] whileFalse: [
		(Delay forMilliseconds: 10) wait ].

	self assert: chat1 messages size = 1.
	self assert: chat2 messages size = 1
]

{ #category : 'running' }
ChatPharoChatTest >> testMultipleConcurrentMessagesHandledSafely [ 

    chat sendMessage: 'first'.
    chat sendMessage: 'second'.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: chat messages size >= 1.
]

{ #category : 'running' }
ChatPharoChatTest >> testNullAgentSetsAssistantBotLabel [ 
    | nullAgent |
    nullAgent := ChatPharoNullAgent new.
    chat agent: nullAgent.
    chat sendMessage: 'hi'.

    [
        (chat instVarNamed: #promptProcess) isTerminated
    ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: (chat messages last assistantLabel) equals: 'Assistant bot'.
]

{ #category : 'running' }
ChatPharoChatTest >> testSameQuestionReturnsCachedAnswer [

	| firstSize firstAnswer |
	chat sendMessage: 'repeat'.
	[ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [
		(Delay forMilliseconds: 10) wait ].
	firstSize := mockApi history size.
	firstAnswer := chat messages last answer.

	chat sendMessage: 'repeat'.

	self assert: chat messages size equals: 2.
	self assert: chat messages last answer equals: firstAnswer.
	self assert: mockApi history size equals: firstSize
]

{ #category : 'running' }
ChatPharoChatTest >> testSendMessageAddsAssistantResponse [

	chat sendMessage: 'hi'.

	[ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [
		(Delay forMilliseconds: 10) wait ].

	self assert: chat messages size equals: 1.
	self
		assert: chat messages last answer
		equals: '<<MOCK-DEFAULT-REPLY to: hi>>'
]

{ #category : 'running' }
ChatPharoChatTest >> testToolExecutionCallbackTriggered [ 

    | count toolAgent |
    count := 0.
    toolAgent := ChatPharoToolMockAgent new.
    chat agent: toolAgent.
    chat whenToolExecutionDo: [ count := count + 1 ].

    chat sendMessage: 'hi'.

    [ (chat instVarNamed: #promptProcess) isTerminated ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

    self assert: count equals: 1.
]

{ #category : 'running' }
ChatPharoChatTest >> testWelcomeMessageToggle [

    | withWelcome withoutWelcome |
    ChatPharoSettings default welcomeMessageEnabled: true.
    withWelcome := ChatPharoChat new agent: ChatPharoMockAgent new.
    self assert: withWelcome messages size equals: 1.
    ChatPharoSettings default welcomeMessageEnabled: false.
    withoutWelcome := ChatPharoChat new agent: ChatPharoMockAgent new.
    self assert: withoutWelcome messages isEmpty.
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
