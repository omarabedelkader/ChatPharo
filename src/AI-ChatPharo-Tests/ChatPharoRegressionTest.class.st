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
