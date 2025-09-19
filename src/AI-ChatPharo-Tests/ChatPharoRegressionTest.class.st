Class {
	#name : 'ChatPharoRegressionTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoRegressionTest >> setUp [ 
        super setUp.
        ChatPharoLogger loggingEnabled: true.
        ChatPharoLogger deleteLogFile

]

{ #category : 'running' }
ChatPharoRegressionTest >> tearDown [

        ChatPharoLogger loggingEnabled: true.
        ChatPharoLogger deleteLogFile.
        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggerAgentNameForAgentWithDisplayName [

        | agent |
        agent := ChatPharoNullAgent new.

        self assert: (ChatPharoLogger agentNameFor: agent) equals: 'None (offline)'
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggerAgentNameForAgentWithoutDisplayNameUsesClassName [
        | agent |
        agent := ChatPharoMockAgent new.

        self assert: (ChatPharoLogger agentNameFor: agent) equals: 'ChatPharoMockAgent'
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggerAgentNameForNilReturnsNone [
        self assert: (ChatPharoLogger agentNameFor: nil) equals: 'None'
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerLogBackendWithCollectionDetailsWritesEntries [
        | contents |
        ChatPharoLogger logBackend: 'collection entry' details: #(1 2).
        contents := ChatPharoLogger logFile readStreamDo: [ :stream | stream contents ].

        self assert: (contents includesSubstring: '- 1').
        self assert: (contents includesSubstring: '- 2')
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerLogBackendWithNilDetailsStillWritesEntry [
        | contents |
        ChatPharoLogger logBackend: 'nil details' details: nil.
        contents := ChatPharoLogger logFile readStreamDo: [ :stream | stream contents ].

        self assert: (contents includesSubstring: '[BACKEND] nil details')
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerLogFrontendWritesFrontendCategory [
        | contents |
        ChatPharoLogger logFrontend: 'frontend entry'.
        contents := ChatPharoLogger logFile readStreamDo: [ :stream | stream contents ].

        self assert: (contents includesSubstring: '[FRONTEND] frontend entry')
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerLogSystemWritesSystemCategory [
        | contents |
        ChatPharoLogger logSystem: 'system entry'.
        contents := ChatPharoLogger logFile readStreamDo: [ :stream | stream contents ].

        self assert: (contents includesSubstring: '[SYSTEM] system entry')
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerStringifyHandlesNil [
        self assert: (ChatPharoLogger stringify: nil) equals: 'nil'
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testLoggerStringifyReturnsAsStringWhenAvailable [
        | object |
        object := Object new.

        self assert: (ChatPharoLogger stringify: object) equals: object asString
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggerWriteDetailsHandlesCollectionEntries [

        | output |
        output := String streamContents: [ :stream |
                ChatPharoLogger writeDetails: #(1 2 3) on: stream ].

        self assert: (output includesSubstring: '- 1').
        self assert: (output includesSubstring: '- 2').
        self assert: (output includesSubstring: '- 3')
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggingDisabledClearsExistingLogFile [

        ChatPharoLogger logBackend: 'entry'.
        self assert: ChatPharoLogger logFile exists.

        ChatPharoLogger loggingEnabled: false.

        self deny: ChatPharoLogger logFile exists
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggingDisabledPreventsLogFileCreation [

        ChatPharoLogger loggingEnabled: false.
        ChatPharoLogger logBackend: 'should not write'.

        self deny: ChatPharoLogger logFile exists
]

{ #category : 'running' }
ChatPharoRegressionTest >> testLoggingEnabledCreatesLogFileOnBackendLog [
        ChatPharoLogger logBackend: 'backend entry'.

        self assert: ChatPharoLogger logFile exists
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsLoadOrNewReturnsNewWhenFileMissing [
        | loaded |
        ChatPharoSettings resetDefault.
        loaded := ChatPharoSettings loadOrNew.

        self assert: loaded class equals: ChatPharoSettings.
        self assert: loaded ~= ChatPharoSettings default
]

{ #category : 'running' }
ChatPharoRegressionTest >> testSettingsLoggingToggleBackToTrueAllowsLogging [

        | settings |
        settings := ChatPharoSettings new.
        settings loggingEnabled: false.
        settings loggingEnabled: true.
        ChatPharoLogger deleteLogFile.

        ChatPharoLogger logFrontend: 'toggle test'.

        self assert: ChatPharoLogger logFile exists
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsLoggingToggleSyncsLogger [

        | settings |
        settings := ChatPharoSettings new.
        settings loggingEnabled: false.

        self deny: ChatPharoLogger loggingEnabled
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsResetDefaultRemovesSettingsFile [
        | settings |
        settings := ChatPharoSettings new.
        ChatPharoSettings setDefault: settings.
        ChatPharoSettings saveDefault.
        self assert: ChatPharoSettings settingsFileReference exists.
        ChatPharoSettings resetDefault.

        self deny: ChatPharoSettings settingsFileReference exists
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsSaveDefaultPersistsCacheEnabled [
        | settings loaded |
        settings := ChatPharoSettings new.
        settings cacheEnabled: false.
        ChatPharoSettings setDefault: settings.
        ChatPharoSettings saveDefault.
        loaded := ChatPharoSettings loadOrNew.

        self deny: loaded cacheEnabled
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsSaveDefaultPersistsMaximumIterations [
        | settings loaded |
        settings := ChatPharoSettings new.
        settings maximumIterations: 7.
        ChatPharoSettings setDefault: settings.
        ChatPharoSettings saveDefault.
        loaded := ChatPharoSettings loadOrNew.

        self assert: loaded maximumIterations equals: 7
]

{ #category : 'tests' }
ChatPharoRegressionTest >> testSettingsSaveDefaultPersistsWelcomeMessageToggle [
        | settings loaded |
        settings := ChatPharoSettings new.
        settings welcomeMessageEnabled: false.
        ChatPharoSettings setDefault: settings.
        ChatPharoSettings saveDefault.
        loaded := ChatPharoSettings loadOrNew.

        self deny: loaded welcomeMessageEnabled
]
