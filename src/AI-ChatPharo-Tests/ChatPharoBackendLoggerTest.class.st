Class {
	#name : 'ChatPharoBackendLoggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'originalLogging'
	],
	#category : 'AI-ChatPharo-Tests-Logger',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Logger'
}

{ #category : 'running' }
ChatPharoBackendLoggerTest >> setUp [

    super setUp.
    originalLogging := ChatPharoLogger loggingEnabled.
    ChatPharoLogger loggingEnabled: false
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> tearDown [

    ChatPharoLogger loggingEnabled: originalLogging.
    super tearDown
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testAgentNameForDefaultsToClassName [

    self assert: (ChatPharoLogger agentNameFor: Object new) equals: 'Object'
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testAgentNameForNilReturnsNone [

    self assert: (ChatPharoLogger agentNameFor: nil) equals: 'None'
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testAgentNameForUsesDisplayNameWhenAvailable [

    self assert: (ChatPharoLogger agentNameFor: ChatPharoBackendLoggerDisplayStub new) equals: 'Stub Display'

]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testEnsureMutexReturnsSameInstance [

    self assert: ChatPharoLogger ensureMutex identicalTo: ChatPharoLogger ensureMutex
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testLoggingEnabledSetterChangesValue [

    | original |
    original := ChatPharoLogger loggingEnabled.
    ChatPharoLogger loggingEnabled: true.
    self assert: ChatPharoLogger loggingEnabled.
    ChatPharoLogger loggingEnabled: false.
    self deny: ChatPharoLogger loggingEnabled.
    ChatPharoLogger loggingEnabled: original
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testStringifyFallsBackToPrintString [

    | object |
    object := Object new.
    self assert: (ChatPharoLogger stringify: object) equals: object printString
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testStringifyNilReturnsNilLiteral [

    self assert: (ChatPharoLogger stringify: nil) equals: 'nil'
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testStringifyUsesAsStringWhenAvailable [

    | object |
    object := 42.
    self assert: (ChatPharoLogger stringify: object) equals: '42'
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testWriteDetailsHandlesCollection [
    | text |
    text := String streamContents: [ :stream |
        ChatPharoLogger writeDetails: #(1 2) on: stream ].
    self assert: (text includesSubstring: '  Details:').
    self assert: (text includesSubstring: '- 1').
    self assert: (text includesSubstring: '- 2')
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testWriteDetailsHandlesNil [

    | text |
    text := String streamContents: [ :stream |
        ChatPharoLogger writeDetails: nil on: stream ].
    self assert: (text includesSubstring: 'nil')
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testWriteDetailsHandlesString [

    | text |
    text := String streamContents: [ :stream |
        ChatPharoLogger writeDetails: 'message' on: stream ].
    self assert: (text includesSubstring: 'message')
]
