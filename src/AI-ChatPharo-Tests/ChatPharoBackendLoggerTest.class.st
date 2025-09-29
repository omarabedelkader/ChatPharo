Class {
	#name : 'ChatPharoBackendLoggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'originalLogging'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
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
ChatPharoBackendLoggerTest >> testAgentNameForNilReturnsNone [

    self assert: (ChatPharoLogger agentNameFor: nil) equals: 'None'
]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testAgentNameForUsesDisplayNameWhenAvailable [

    self assert: (ChatPharoLogger agentNameFor: ChatPharoBackendLoggerDisplayStub new) equals: 'Stub Display'

]

{ #category : 'running' }
ChatPharoBackendLoggerTest >> testStringifyNilReturnsNilLiteral [

    self assert: (ChatPharoLogger stringify: nil) equals: 'nil'
]
