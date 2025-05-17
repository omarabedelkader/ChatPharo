Class {
	#name : 'NullAgentTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo2-Tests-Agent',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Agent'
}

{ #category : 'tests' }
NullAgentTest >> testDisplayName [ 
    self assert: NullAgent displayName equals: 'None (offline)'


]

{ #category : 'tests' }
NullAgentTest >> testGetResponseForPromptReturnsWarning [ 

    | msg |
    msg := (NullAgent new getResponseForPrompt: 'ignored').
    self assert: (msg includesSubstring: 'No backend is configured')
]

{ #category : 'tests' }
NullAgentTest >> testIsAlwaysReachable [ 

    self assert: NullAgent isReachable
]

{ #category : 'tests' }
NullAgentTest >> testModelInformationDefault [ 

    self assert: (NullAgent new modelInformation) equals: 'No model selected yet'
]

{ #category : 'tests' }
NullAgentTest >> testModelNamesIsEmpty [ 

    self assert: NullAgent modelNames isEmpty
]

{ #category : 'tests' }
NullAgentTest >> testSettingsPresenterIsNil [ 

    self assert: (NullAgent settingsPresenterFor: nil) isNil
]
