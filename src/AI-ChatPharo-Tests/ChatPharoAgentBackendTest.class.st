Class {
	#name : 'ChatPharoAgentBackendTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoAgentBackendTest >> setUp [

    super setUp.
    agent := ChatPharoNullAgent new.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testConfigurationErrorMessageIsHelpful [

    self assert: agent configurationErrorMessage equals: 'Agent is missing required settings.'.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testCopyForChatCreatesDistinctHistoryInstance [

    | clone |
    agent history: ChatPharoHistory new.
    clone := agent copyForChat.
    self deny: clone history isNil.
    self deny: clone history == agent history.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testCopyForChatResetsPromptPrefix [

    | clone |
    agent promptPrefix: 'pref'.
    clone := agent copyForChat.
    self assert: clone promptPrefix equals: ''.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testCopyForChatResetsResponse [

    | clone |
    agent response: 'previous'.
    clone := agent copyForChat.
    self assert: clone response equals: ''.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testDefaultBrowserSystemPromptMatchesClassDefault [

    self assert: agent browserSystemPrompt equals: ChatPharoNullAgent defaultBrowserSystemPrompt.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testDefaultSystemPromptMatchesClassDefault [

    self assert: agent systemPrompt equals: ChatPharoNullAgent defaultSystemPrompt.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testInitializeSetsModelToEmptyString [

    self assert: agent model equals: ''.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testInitializeSetsPromptPrefixToEmptyString [ 

    self assert: agent promptPrefix equals: ''.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testInitializeSetsResponseToEmptyString [

    self assert: agent response equals: ''.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testIsConfiguredDefaultsToTrue [

    self assert: agent isConfigured.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testOnToolExecutionSetterStoresBlock [

    | flag |
    flag := false.
    agent onToolExecution: [ flag := true ].
    agent onToolExecution value.
    self assert: flag.
]

{ #category : 'running' }
ChatPharoAgentBackendTest >> testUseAdapterReplacesModel [

    agent useAdapter: 'adapter-id'.
    self assert: agent model equals: 'adapter-id'.
]
