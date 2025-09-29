Class {
	#name : 'ChatPharoToolTestDouble',
	#superclass : 'ChatPharoTool',
	#instVars : [
		'appliedCalls'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'initialization' }
ChatPharoToolTestDouble >> appliedCalls [

    ^ appliedCalls ifNil: [ OrderedCollection new ]
]

{ #category : 'initialization' }
ChatPharoToolTestDouble >> applyToolFunction: functionName arguments: arguments [

    appliedCalls add: { functionName. arguments }.
    ^ super applyToolFunction: functionName arguments: arguments
]

{ #category : 'initialization' }
ChatPharoToolTestDouble >> client [

    ^ ChatPharoToolTestClientStub new
]

{ #category : 'initialization' }
ChatPharoToolTestDouble >> initializeWithBaseURL: baseURL apiKey: apiKey system: system tools: tools [

    super initializeWithBaseURL: baseURL apiKey: apiKey system: system tools: tools.
    appliedCalls := OrderedCollection new.
]

{ #category : 'initialization' }
ChatPharoToolTestDouble >> modelNames [

    ^ #( 'test-model' )
]
