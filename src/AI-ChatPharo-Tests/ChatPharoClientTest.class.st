Class {
	#name : 'ChatPharoClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoClientTest >> setUp [ 

        super setUp.
        client := ChatPharoClient name: 'n' description: 'd' parameters: (Dictionary new) block: [ :a | a at: 'value' ]
]

{ #category : 'running' }
ChatPharoClientTest >> testAccessors [ 

        self assert: client name equals: 'n'.
        self assert: client description equals: 'd'.
]

{ #category : 'running' }
ChatPharoClientTest >> testApplyToExecutesBlock [ 

        | result |
        result := client applyTo: (Dictionary with: 'value' -> 5).
        self assert: result equals: 5.
]

{ #category : 'running' }
ChatPharoClientTest >> testBlockSetterGetter [

        | newBlock result |
        newBlock := [ :a | (a at: 'value') * 2 ].
        client block: newBlock.
        result := client applyTo: (Dictionary with: 'value' -> 3).
        self assert: result equals: 6.
]

{ #category : 'running' }
ChatPharoClientTest >> testDescriptionSetterGetter [

        client description: 'x'.
        self assert: client description equals: 'x'.
]

{ #category : 'running' }
ChatPharoClientTest >> testNameSetterGetter [ 

        client name: 'x'.
        self assert: client name equals: 'x'.
]

{ #category : 'running' }
ChatPharoClientTest >> testOpenAIChatToolStructure [

	| d |
	d := client openAIChatTool.
	self assert: (d at: 'function' at: 'name') equals: 'n'
]

{ #category : 'running' }
ChatPharoClientTest >> testParametersSetterGetter [ 

        client parameters: (Dictionary with: 'a' -> 1).
        self assert: (client parameters at: 'a') equals: 1.
]

{ #category : 'running' }
ChatPharoClientTest >> testToolCheckSyntaxReportsError [ 

        | tool result |
        tool := ChatPharoClient toolCheckSyntax.
        result := tool applyTo: (Dictionary with: 'code' -> '1 +').
        self assert: (result includesKey: 'syntax_error').
]

{ #category : 'running' }
ChatPharoClientTest >> testToolCheckSyntaxValid [ 

        | tool result |
        tool := ChatPharoClient toolCheckSyntax.
        result := tool applyTo: (Dictionary with: 'code' -> '1 + 2').
        self assert: (result at: 'syntax_ok') equals: true.
]
