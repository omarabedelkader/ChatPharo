Class {
	#name : 'ChatPharoClientBackendExtendedTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> setUp [

    super setUp.
    client := ChatPharoClient
        name: 'sample'
        description: 'sample tool'
        parameters: (Dictionary with: 'type' -> 'object')
        block: [ :json | json at: 'value' ifAbsent: [ nil ] ].
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testApplyToReturnsBlockResult [

    self assert: (client applyTo: (Dictionary with: 'value' -> 42)) equals: 42.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testBlockAccessorRoundTrip [

    | block |
    block := [ :json | json size ].
    client block: block.
    self assert: client block == block.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testDescriptionAccessorRoundTrip [

    client description: 'updated'.
    self assert: client description equals: 'updated'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testInitializeStoresName [

    self assert: client name equals: 'sample'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testMultipleApplyToCallsAreIndependent [

    | first second |
    first := client applyTo: (Dictionary with: 'value' -> 'one').
    second := client applyTo: (Dictionary with: 'value' -> 'two').
    self assert: first equals: 'one'.
    self assert: second equals: 'two'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testNameAccessorRoundTrip [

    client name: 'renamed'.
    self assert: client name equals: 'renamed'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testOpenAIChatToolIncludesDescription [ 

    self assert: ((client openAIChatTool at: 'function') at: 'description') equals: client description.

]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testOpenAIChatToolIncludesFunctionType [

    self assert: (client openAIChatTool at: 'type') equals: 'function'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testOpenAIChatToolSharesParametersObject [

	self assert: ((client openAIChatTool at: 'function') at: 'parameters') identicalTo: client parameters
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testParametersAccessorRoundTrip [

    | parameters |
    parameters := Dictionary with: 'type' -> 'object' with: 'properties' -> Dictionary new.
    client parameters: parameters.
    self assert: client parameters == parameters.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testSampleWeatherToolReturnsErrorForUnknownCity [ 

    | tool result |
    tool := ChatPharoClient toolGetCurrentWeather.
    result := tool applyTo: (Dictionary with: 'city' -> 'Unknown').
    self assert: ((result at: 'error') includesSubstring: 'Unknown').

]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testSampleWeatherToolReturnsWeatherForKnownCity [

    | tool result |
    tool := ChatPharoClient toolGetCurrentWeather.
    result := tool applyTo: (Dictionary with: 'city' -> 'Paris').
    self assert: (result at: 'degrees_centigrade') equals: 10.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testSettingDescriptionUpdatesOpenAITool [

    client description: 'new description'.
    self assert: ((client openAIChatTool at: 'function') at: 'description') equals: 'new description'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testSettingNameUpdatesOpenAITool [

    client name: 'new-name'.
    self assert: ((client openAIChatTool at: 'function') at: 'name') equals: 'new-name'.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testSettingParametersUpdatesOpenAITool [

    | parameters |
    parameters := Dictionary with: 'type' -> 'array'.
    client parameters: parameters.
    self assert: ((client openAIChatTool at: 'function') at: 'parameters') == parameters.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testToolCheckSyntaxReportsValidCode [

    | tool result |
    tool := ChatPharoClient toolCheckSyntax.
    result := tool applyTo: (Dictionary with: 'code' -> '1 + 2').
    self assert: (result at: 'syntax_ok') equals: true.
]

{ #category : 'running' }
ChatPharoClientBackendExtendedTest >> testToolEvaluateExpressionReturnsStringValue [

    | tool result |
    tool := ChatPharoClient toolEvaluateExpression.
    result := tool applyTo: (Dictionary with: 'expression' -> '1 + 2').
    self assert: (result at: 'value') equals: '3'.
]
