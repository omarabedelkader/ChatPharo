Class {
	#name : 'ChatPharoFunctionalTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'mockAgent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoFunctionalTest >> setUp [ 
        super setUp.
        ChatPharoLogger deleteLogFile.
        ChatPharoSettings default welcomeMessageEnabled: false.
        app := ChatPharo new.
        mockAgent := ChatPharoMockAgent new.
        app settings instVarNamed: #agent put: mockAgent
]

{ #category : 'running' }
ChatPharoFunctionalTest >> tearDown [

        ChatPharoLogger deleteLogFile.
        ChatPharoLogger loggingEnabled: true.
        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoFunctionalTest >> testActiveAgentAfterAddingChatReturnsLatestAgent [

        app newChat.
        app newChat.

        self assert: app activeAgent == (app chats last agent)
]

{ #category : 'running' }
ChatPharoFunctionalTest >> testActiveAgentWithoutChatsReturnsNil [

        self assert: app activeAgent isNil
]

{ #category : 'running' }
ChatPharoFunctionalTest >> testChatsCollectionMaintainsInsertionOrder [

        | first second |
        app newChat.
        first := app chats first.
        app newChat.
        second := app chats last.

        self assert: (app chats first) == first.
        self assert: (app chats last) == second
]

{ #category : 'running' }
ChatPharoFunctionalTest >> testCodePromptForSourceIncludesContextInformation [

        | context prompt |
        context := Dictionary new
                at: 'Selector' put: 'example';
                at: 'Class' put: 'Demo';
                yourself.
        prompt := ChatPharo codePromptForSource: 'Smalltalk code' context: context.

        self assert: (prompt includesSubstring: 'Selector: example').
        self assert: (prompt includesSubstring: 'Class: Demo').
        self assert: (prompt includesSubstring: '```smalltalk').
        self assert: (prompt includesSubstring: 'Smalltalk code')
]

{ #category : 'running' }
ChatPharoFunctionalTest >> testNewChatUsesIndependentAgentCopyWhenAgentIsChatPharoAgent [

        | copyAgent |
        app settings useApi: ChatPharoNullAgent.
        app newChat.
        copyAgent := app chats last agent.

        self assert: copyAgent class equals: ChatPharoNullAgent.
        self deny: copyAgent == app settings agent
]

{ #category : 'tests' }
ChatPharoFunctionalTest >> testPromptForMethodExplanationIncludesSourceFormatting [

        | prompt |
        prompt := ChatPharo
                promptForMethodExplanationSource: 'methodBody'
                className: 'SampleClass'
                selector: 'doSomething'.

        self assert: (prompt includesSubstring: 'Class: SampleClass').
        self assert: (prompt includesSubstring: 'Selector: doSomething').
        self assert: (prompt includesSubstring: '```smalltalk').
        self assert: (prompt includesSubstring: 'methodBody')
]

{ #category : 'tests' }
ChatPharoFunctionalTest >> testRemoveChatAtKeepsRemainingChatsInOrder [

        | firstChat secondChat |
        app newChat.
        firstChat := app chats last.
        app newChat.
        secondChat := app chats last.

        app removeChatAt: 1.

        self assert: app chats size equals: 1.
        self assert: (app chats first) == secondChat
]
