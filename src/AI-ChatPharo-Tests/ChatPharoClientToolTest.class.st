Class {
	#name : 'ChatPharoClientToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldPlayground'
	],
	#category : 'AI-ChatPharo-Tests-Tool',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tool'
}

{ #category : 'running' }
ChatPharoClientToolTest >> setUp [ 

    super setUp.
    oldPlayground := Smalltalk at: #StPlayground ifAbsent: [ nil ].
    Smalltalk at: #StPlayground put: ChatPharoPlaygroundStub.
    ChatPharoPlaygroundStub reset.
]

{ #category : 'running' }
ChatPharoClientToolTest >> tearDown [ 

    oldPlayground ifNotNil: [ Smalltalk at: #StPlayground put: oldPlayground ] ifNil: [ Smalltalk removeKey: #StPlayground ].
    super tearDown
]

{ #category : 'running' }
ChatPharoClientToolTest >> testEvaluateExpressionRuntimeError [ 

    | tool result |
    tool := ChatPharoClient toolEvaluateExpression.
    result := tool applyTo: (Dictionary with: 'expression' -> 'Object unknown').
    self assert: (result includesKey: 'evaluation_error').
]

{ #category : 'running' }
ChatPharoClientToolTest >> testEvaluateExpressionSuccess [ 

    | tool result |
    tool := ChatPharoClient toolEvaluateExpression.
    result := tool applyTo: (Dictionary with: 'expression' -> '1 + 2').
    self assert: (result at: 'value') equals: '3'.
]

{ #category : 'running' }
ChatPharoClientToolTest >> testEvaluateExpressionSyntaxError [ 

    | tool result |
    tool := ChatPharoClient toolEvaluateExpression.
    result := tool applyTo: (Dictionary with: 'expression' -> '1+').
    self assert: (result includesKey: 'syntax_error').
]

{ #category : 'running' }
ChatPharoClientToolTest >> testOpenPlaygroundOpens [ 

    | tool result |
    tool := ChatPharoClient toolOpenPlayground.
    result := tool applyTo: (Dictionary with: 'code' -> '1+2').
    self assert: (result at: 'playground_opened').
    self assert: ChatPharoPlaygroundStub lastOpened equals: '1+2'.
]

{ #category : 'running' }
ChatPharoClientToolTest >> testOpenPlaygroundSyntaxError [ 

    | tool result |
    tool := ChatPharoClient toolOpenPlayground.
    result := tool applyTo: (Dictionary with: 'code' -> '1+').
    self assert: (result includesKey: 'syntax_error').
    self assert: ChatPharoPlaygroundStub lastOpened isNil.
]
