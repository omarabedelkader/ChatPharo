Class {
	#name : 'ChatPharoClientBackendTest',
	#superclass : 'TestCase',
	#instVars : [
		'originalPlayground'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoClientBackendTest >> setUp [

    super setUp.
    originalPlayground := (Smalltalk hasClassNamed: #StPlayground)
        ifTrue: [ Smalltalk at: #StPlayground ]
        ifFalse: [ nil ].
    Smalltalk at: #StPlayground put: ChatPharoPlaygroundStub.
    ChatPharoPlaygroundStub reset.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> tearDown [
    originalPlayground
        ifNil: [ Smalltalk globals removeKey: #StPlayground ifAbsent: [ ] ]
        ifNotNil: [ Smalltalk globals at: #StPlayground put: originalPlayground ].
    super tearDown.

]

{ #category : 'running' }
ChatPharoClientBackendTest >> testApplyToReturnsBlockValue [

    | client |
    client := ChatPharoClient name: 'noop' description: 'desc' parameters: Dictionary new block: [ :args | args at: 'value' ].
    self assert: (client applyTo: (Dictionary with: 'value' -> 5)) equals: 5.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testDescriptionAccessorReturnsStoredDescription [

    | client |
    client := ChatPharoClient name: 'n' description: 'describe' parameters: Dictionary new block: [ :args | args ].
    self assert: client description equals: 'describe'.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testNameAccessorReturnsStoredName [

    | client |
    client := ChatPharoClient name: 'custom' description: 'd' parameters: Dictionary new block: [ :args | args ].
    self assert: client name equals: 'custom'.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testParametersAccessorReturnsStoredParameters [

    | parameters client |
    parameters := Dictionary with: 'type' -> 'object'.
    client := ChatPharoClient name: 'n' description: 'd' parameters: parameters block: [ :args | args ].
    self assert: client parameters == parameters.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolCheckSyntaxReportsErrorForInvalidCode [

    | result |
    result := ChatPharoClient toolCheckSyntax applyTo: (Dictionary with: 'code' -> '1 +').
    self assert: (result includesKey: 'syntax_error').
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolCheckSyntaxReportsOkForValidCode [

    | result |
    result := ChatPharoClient toolCheckSyntax applyTo: (Dictionary with: 'code' -> '1 + 2').
    self assert: (result at: 'syntax_ok').
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolEvaluateExpressionReportsEvaluationError [

    | result |
    result := ChatPharoClient toolEvaluateExpression applyTo: (Dictionary with: 'expression' -> '1 / 0').
    self assert: ((result at: 'evaluation_error') includesSubstring: 'ZeroDivide').
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolEvaluateExpressionReportsSyntaxError [

    | result |
    result := ChatPharoClient toolEvaluateExpression applyTo: (Dictionary with: 'expression' -> '1 +').
    self assert: (result includesKey: 'syntax_error').
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolEvaluateExpressionReturnsValue [

    | result |
    result := ChatPharoClient toolEvaluateExpression applyTo: (Dictionary with: 'expression' -> '1 + 2').
    self assert: (result at: 'value') equals: '3'.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolGetCurrentWeatherReturnsKnownCityData [

    | result |
    result := ChatPharoClient toolGetCurrentWeather applyTo: (Dictionary with: 'city' -> 'Paris').
    self assert: (result at: 'degrees_centigrade') equals: 10.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolGetCurrentWeatherReturnsMissingCityError [

    | result |
    result := ChatPharoClient toolGetCurrentWeather applyTo: (Dictionary with: 'city' -> 'Berlin').
    self assert: ((result at: 'error') includesSubstring: 'No weather data').
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolOpenPlaygroundDoesNotOpenWhenSyntaxError [

    | result |
    result := ChatPharoClient toolOpenPlayground applyTo: (Dictionary with: 'code' -> '1 +').
    self assert: (result includesKey: 'syntax_error').
    self assert: ChatPharoPlaygroundStub lastOpened isNil.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolOpenPlaygroundNameIsOpenPlayground [

    self assert: ChatPharoClient toolOpenPlayground name equals: 'open_playground'.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolOpenPlaygroundOpensPlaygroundForValidCode [

    | result |
    result := ChatPharoClient toolOpenPlayground applyTo: (Dictionary with: 'code' -> '1 + 2').
    self assert: (result at: 'playground_opened').
    self assert: ChatPharoPlaygroundStub lastOpened equals: '1 + 2'.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolOpenPlaygroundReturnsDictionary [

    | result |
    result := ChatPharoClient toolOpenPlayground applyTo: (Dictionary with: 'code' -> '1 + 2').
    self assert: result isDictionary.
]

{ #category : 'running' }
ChatPharoClientBackendTest >> testToolOpenPlaygroundUsesVerboseDescription [

    self assert: (ChatPharoClient toolOpenPlayground description includesSubstring: 'Playground').
]
