Class {
	#name : 'ChatPharoSettingsPersistenceTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> setUp [ 

    super setUp.
    ChatPharoSettings resetDefault.
    settings := ChatPharoSettings new.
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> tearDown [ 

    ChatPharoSettings resetDefault.
    super tearDown
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testLoadOrNewRestoresSavedSettings [ 
    | loaded |
    settings useApi: ChatPharoNullAgent.
    settings useModel: 'stored-model'.
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded agent class equals: ChatPharoNullAgent.
    self assert: loaded agent model equals: 'stored-model'.
]
