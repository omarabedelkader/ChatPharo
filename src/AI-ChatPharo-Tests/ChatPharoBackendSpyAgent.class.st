Class {
	#name : 'ChatPharoBackendSpyAgent',
	#superclass : 'Object',
	#instVars : [
		'recordedHistory',
		'promptPrefixes',
		'toolExecutionBlock',
		'response',
		'toolExecutionInvoked'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> getResponseForPrompt: aPrompt [

    toolExecutionBlock ifNotNil: [
        toolExecutionInvoked := true.
        toolExecutionBlock value ].
    ^ response ifNil: [ 'spy-response' ]
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> history [

    ^ recordedHistory
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> history: aHistory [

    recordedHistory := aHistory
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> initialize [

    super initialize.
    promptPrefixes := OrderedCollection new.
    toolExecutionBlock := nil.
    response := 'spy-response'.
    toolExecutionInvoked := false
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> onToolExecution: aBlock [

    toolExecutionBlock := aBlock
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> promptPrefix: aPrefix [

    promptPrefixes add: aPrefix
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> promptPrefixes [

    ^ promptPrefixes
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> response: aString [

    response := aString
]

{ #category : 'initialization' }
ChatPharoBackendSpyAgent >> toolExecutionInvoked [

    ^ toolExecutionInvoked
]
