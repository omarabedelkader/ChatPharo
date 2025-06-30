Class {
	#name : 'ChatPharoNullAgentTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'tests' }
ChatPharoNullAgentTest >> testDisplayName [ 
    self assert: ChatPharoNullAgent displayName equals: 'None (offline)'


]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testGetResponseForPromptReturnsWarning [ 

    | msg |
    msg := (ChatPharoNullAgent new getResponseForPrompt: 'ignored').
    self assert: (msg includesSubstring: 'No backend is configured')
]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testIsAlwaysReachable [
    self deny: ChatPharoNullAgent isReachable

]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testModelInformationDefault [ 

    self assert: (ChatPharoNullAgent new modelInformation) equals: 'No model selected yet'
]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testModelNamesIsEmpty [ 

    self assert: ChatPharoNullAgent modelNames isEmpty
]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testSettingsPresenterIsNil [ 

    self assert: (ChatPharoNullAgent settingsPresenterFor: nil) isNil
]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testSettingsPresenterShowsMessage [ 

    | presenter |
    presenter := ChatPharoNullAgent settingsPresenterFor: ChatPharoNullAgent new.
    self assert: presenter notNil.
    self assert: presenter infoLabel label = 'Please configure an Agent, by selecting an Agent'
]

{ #category : 'tests' }
ChatPharoNullAgentTest >> testTestConnectionReturnsTrue [ 


    self assert: (ChatPharoNullAgent new testConnection)
]
