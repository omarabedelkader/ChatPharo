Class {
	#name : 'BrowserToolset',
	#superclass : 'Object',
	#instVars : [
		'tools'
	],
	#category : 'AI-ChatPharo-Tools',
	#package : 'AI-ChatPharo-Tools'
}

{ #category : 'instance creation' }
BrowserToolset class >> new [
    ^ (super new)
        initialize;
        yourself.
]

{ #category : 'initialization' }
BrowserToolset >> initialize [
    tools := {
        self toolEvaluateExpression.
        self toolGetPackages }.
]

{ #category : 'initialization' }
BrowserToolset >> toolEvaluateExpression [
    ^ ToolFunction
        name: 'evaluate_expression'
        description: 'Evaluates a Smalltalk expression in the current image.'
        parameters: (Dictionary
            with: 'type' -> 'object'
            with: 'properties' -> (Dictionary
                with: 'expression' -> (Dictionary
                    with: 'type' -> 'string'
                    with: 'description' -> 'Smalltalk expression'))
            with: 'required' -> #('expression'))
        block: [ :args |
            | expr value |
            expr := args at: 'expression'.
            [ value := Smalltalk compiler evaluate: expr ]
                on: Error
                do: [ :e | ^ Dictionary with: 'error' -> e messageText ].
            Dictionary with: 'value' -> value printString ].
]

{ #category : 'initialization' }
BrowserToolset >> toolGetPackages [
    ^ ToolFunction
        name: 'get_packages'
        description: 'Returns the list of loaded packages.'
        parameters: (Dictionary
            with: 'type' -> 'object'
            with: 'properties' -> Dictionary new
            with: 'required' -> #())
        block: [ :ignored |
            Dictionary with: 'packages'
                -> (RBBrowserEnvironment default packages collect: [ :p | p name ]) ]
]

{ #category : 'initialization' }
BrowserToolset >> tools [
    ^ tools

]
