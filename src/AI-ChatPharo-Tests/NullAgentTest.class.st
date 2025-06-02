Class {
	#name : 'NullAgentTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'tests' }
NullAgentTest >> testDisplayName [ 
    self assert: ChatPharoNullAgent displayName equals: 'None (offline)'


]

{ #category : 'tests' }
NullAgentTest >> testGetResponseForPromptReturnsWarning [ 

    | msg |
    msg := (ChatPharoNullAgent new getResponseForPrompt: 'ignored').
    self assert: (msg includesSubstring: 'No backend is configured')
]

{ #category : 'tests' }
NullAgentTest >> testIsAlwaysReachable [ 

    self assert: ChatPharoNullAgent isReachable
]

{ #category : 'tests' }
NullAgentTest >> testModelInformationDefault [ 

    self assert: (ChatPharoNullAgent new modelInformation) equals: 'No model selected yet'
]

{ #category : 'tests' }
NullAgentTest >> testModelNamesIsEmpty [ 

    self assert: ChatPharoNullAgent modelNames isEmpty
]

{ #category : 'tests' }
NullAgentTest >> testSettingsPresenterIsNil [ 

    self assert: (ChatPharoNullAgent settingsPresenterFor: nil) isNil
]
