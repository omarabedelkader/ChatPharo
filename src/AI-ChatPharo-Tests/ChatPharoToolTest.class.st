Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool',
		'called'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoToolTest >> setUp [ 
    super setUp.
    called := false.
    tool := ChatPharoTool
                ollamaWithSystem: nil
                tools: {
                    ChatPharoClient
                        name: 'fn'
                        description: ''
                        parameters: Dictionary new
                        block: [ :args | called := true. 42 ] }.

]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionExecutes [ 

    | result |
    result := tool applyToolFunction: 'fn' arguments: Dictionary new.
    self assert: called.
    self assert: result equals: 42.
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionUnknownReturnsError [ 

    | result |
    result := tool applyToolFunction: 'missing' arguments: Dictionary new.
    self assert: (result at: 'error') notNil.
]

{ #category : 'running' }
ChatPharoToolTest >> testToolCallsFromMessageParses [ 
    | msg calls |
    msg := Dictionary with: 'tool_calls'
                -> (Array with:
                        (Dictionary
                                with: 'id' -> '1'
                                with: 'function'
                                -> (Dictionary
                                        with: 'name' -> 'fn'
                                        with: 'arguments' -> '{}'))).
    calls := tool toolCallsFromMessage: msg.
    self assert: calls size equals: 1.
    self assert: calls first functionName equals: 'fn'.
]
