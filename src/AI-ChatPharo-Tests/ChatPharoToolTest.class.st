Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool',
		'adder',
		'boom'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoToolTest >> setUp [ 

    super setUp.
    adder := ChatPharoClient
                name: 'add'
                description: 'adds numbers'
                parameters: Dictionary new
                block: [ :args | Dictionary with: 'result' -> ((args at: 'a') + (args at: 'b')) ].
    boom := ChatPharoClient
                name: 'boom'
                description: 'fails'
                parameters: Dictionary new
                block: [ :args | Error signal: 'fail' ].
    tool := ChatPharoTool new.
    tool tools: { adder. boom }.
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionCatchesError [ 

    | result |
    result := tool applyToolFunction: 'boom' arguments: Dictionary new.
    self assert: (result at: 'error') equals: 'fail'.
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionRunsBlock [ 

    | result |
    result := tool applyToolFunction: 'add'
                        arguments: (Dictionary with: 'a' -> 2 with: 'b' -> 3).
    self assert: (result at: 'result') equals: 5.
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionUnknown [ 

    | result |
    result := tool applyToolFunction: 'other' arguments: Dictionary new.
    self assert: ((result at: 'error') includesSubstring: 'other').
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionWithNoTools [ 

    | result |
    result := tool applyToolFunction: 'dummy' arguments: Dictionary new.
    self assert: (result at: 'error') notNil
]

{ #category : 'running' }
ChatPharoToolTest >> testToolCallsFromMessage [ 

    | msg calls call |
    msg := Dictionary with: 'tool_calls' -> (Array with:
                (Dictionary
                        with: 'id' -> '1'
                        with: 'function' -> (Dictionary
                                with: 'name' -> 'add'
                                with: 'arguments' -> '{"a":2,"b":3}'))).
    calls := tool toolCallsFromMessage: msg.
    call := calls first.
    self assert: call id equals: '1'.
    self assert: call functionName equals: 'add'.
    self assert: call arguments equals: '{"a":2,"b":3}'.
    self assert: call content equals: '{"result":5}'.
]
