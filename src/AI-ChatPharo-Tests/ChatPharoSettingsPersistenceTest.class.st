Class {
	#name : 'ChatPharoSettingsPersistenceTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-Settings',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Settings'
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
ChatPharoSettingsPersistenceTest >> testBrowserAutoTabPersisted [

    | loaded |
    settings browserAutoTabEnabled: false.
    loaded := ChatPharoSettings loadOrNew.
    self deny: loaded browserAutoTabEnabled
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testBrowserExtensionEnabledPersisted [ 

    | loaded |
    settings browserExtensionEnabled: true.
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded browserExtensionEnabled
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testBrowserToolsPersistence [ 

    | first loaded |
    first := settings browserToolsEnabled anyOne.
    settings disableBrowserTool: first.
    loaded := ChatPharoSettings loadOrNew.
    self deny: (loaded browserToolsEnabled includes: first)
]

{ #category : 'tests' }
ChatPharoSettingsPersistenceTest >> testCacheEnabledPersistence [ 

    | loaded |
    settings cacheEnabled: false.
    loaded := ChatPharoSettings loadOrNew.
    self deny: loaded cacheEnabled.

]

{ #category : 'tests' }
ChatPharoSettingsPersistenceTest >> testFeedbackButtonsEnabledPersistence [ 

    | loaded |
    settings feedbackButtonsEnabled: false.
    loaded := ChatPharoSettings loadOrNew.
    self deny: loaded feedbackButtonsEnabled.
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testLoadOrNewHandlesCorruptedFile [

	| path loaded |
	path := ChatPharoSettings settingsFileReference.
    path parent ensureCreateDirectory.
	path writeStreamDo: [ :stream | stream nextPutAll: 'invalid' ].
	loaded := ChatPharoSettings loadOrNew.
	self assert: loaded class equals: ChatPharoSettings.
	self assert: loaded agent class equals: ChatPharoNullAgent
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

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testLoadSaveKeepsAgentModel [ 
    | loaded |
    settings useApi: ChatPharoMockAgent.
    settings useModel: 'mock-default'.
    ChatPharoSettings setDefault: settings.
    ChatPharoSettings saveDefault.
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded agent class equals: ChatPharoMockAgent.
    self assert: loaded agent model equals: 'mock-default'.
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testMaximumIterationsPersistence [

    | loaded |
    settings maximumIterations: 5.
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded maximumIterations equals: 5
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testMigratesLegacySettingsFile [

    | legacy newPath legacySettings loaded |
    legacy := ChatPharoSettings legacySettingsFileReference.
    newPath := ChatPharoSettings settingsFileReference.
    newPath deleteIfAbsent: [ ].
    legacy deleteIfAbsent: [ ].
    legacySettings := ChatPharoSettings new.
    legacySettings instVarNamed: 'maximumIterations' put: 42.
    legacy writeStreamDo: [ :stream | STON put: legacySettings onStream: stream ].
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded maximumIterations equals: 42.
    self assert: newPath exists.
    self deny: legacy exists.
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testResetDefaultRemovesSavedFile [

	| path |
	ChatPharoSettings setDefault: settings.
	ChatPharoSettings saveDefault.
	path := ChatPharoSettings settingsFileReference.
	self assert: path exists.
	ChatPharoSettings resetDefault.
	self deny: path exists
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testSystemPromptPersistence [ 

    | loaded |
    settings useApi: ChatPharoOllamaAgent.
    settings agent systemPrompt: 'hello-system'.
    ChatPharoSettings setDefault: settings.
    ChatPharoSettings saveDefault.
    loaded := ChatPharoSettings loadOrNew.
    self assert: loaded agent systemPrompt equals: 'hello-system'
]

{ #category : 'running' }
ChatPharoSettingsPersistenceTest >> testWelcomeMessageEnabledPersistence [
    | loaded |
    settings welcomeMessageEnabled: false.
    loaded := ChatPharoSettings loadOrNew.
    self deny: loaded welcomeMessageEnabled
]
