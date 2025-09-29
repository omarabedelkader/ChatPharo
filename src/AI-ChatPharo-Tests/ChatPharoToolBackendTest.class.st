Class {
	#name : 'ChatPharoToolBackendTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool',
		'echoClient'
	],
	#category : 'AI-ChatPharo-Tests-Tools',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
ChatPharoToolBackendTest >> setUp [

    super setUp.
    tool := ChatPharoToolTestDouble
        baseURL: (ZnUrl new
            scheme: 'http';
            host: 'localhost';
            yourself)
        system: 'system'
        tools: nil.
    echoClient := ChatPharoClient
        name: 'echo'
        description: 'Echoes the provided text.'
        parameters: Dictionary new
        block: [ :arguments | arguments ].
    tool tools: { echoClient }.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testApplyToolFunctionInvokesClientBlock [

    | result |
    result := tool applyToolFunction: 'echo' arguments: (Dictionary with: 'message' -> 'hi').
    self assert: (result at: 'message') equals: 'hi'.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testApplyToolFunctionRecordsCall [

    tool applyToolFunction: 'echo' arguments: Dictionary new.
    self assert: tool appliedCalls size equals: 1.
    self assert: tool appliedCalls first first equals: 'echo'.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testApplyToolFunctionReturnsErrorWhenToolMissing [

    tool tools: nil.
    self assert: (((tool applyToolFunction: 'missing' arguments: Dictionary new) at: 'error')
        includesSubstring: 'There is no function named').
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testApplyToolFunctionTriggersOnToolExecutionCallback [

    | triggered |
    triggered := false.
    tool onToolExecution: [ triggered := true ].
    tool applyToolFunction: 'echo' arguments: Dictionary new.
    self assert: triggered.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testApplyToolFunctionWrapsErrorsAsDictionary [

    tool tools: {
        ChatPharoClient
            name: 'boom'
            description: 'Raises an error.'
            parameters: Dictionary new
            block: [ :arguments | Error signal: 'failure' ] }.
    self assert: ((tool applyToolFunction: 'boom' arguments: Dictionary new) at: 'error') equals: 'failure'.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageGeneratesHistorySaverToolCall [

    | message calls |
    tool tools: { echoClient }.
    message := Dictionary
        with: 'tool_calls' -> (Array with: (Dictionary
            with: 'id' -> 'call-1'
            with: 'function' -> (Dictionary
                with: 'name' -> 'echo'
                with: 'arguments' -> '{"value":5}'))).
    calls := tool toolCallsFromMessage: message.
    self assert: calls size equals: 1.
    self assert: calls first id equals: 'call-1'.
    self assert: calls first content equals: '{"value":5}'.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageHandlesInvalidArgumentJson [

    | message calls |
    tool tools: { echoClient }.
    message := Dictionary
        with: 'tool_calls' -> (Array with: (Dictionary
            with: 'function' -> (Dictionary
                with: 'name' -> 'echo'
                with: 'arguments' -> '{invalid json}'))).
    calls := tool toolCallsFromMessage: message.
    self assert: calls size equals: 1.
    self assert: (calls first content includesSubstring: 'Invalid arguments').
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageParsesDictionaryArguments [

    | message calls |
    tool tools: { echoClient }.
    message := Dictionary
        with: 'tool_calls' -> (Array with: (Dictionary
            with: 'id' -> 'generated'
            with: 'function' -> (Dictionary
                with: 'name' -> 'echo'
                with: 'arguments' -> (Dictionary with: 'value' -> 7)))).
    calls := tool toolCallsFromMessage: message.
    self assert: calls size equals: 1.
    self assert: (calls first arguments) equals: '{"value":7}'.

]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageReturnsNilWhenNoToolCallsPresent [

    self assert: (tool toolCallsFromMessage: Dictionary new) isNil.
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageSuppliesGeneratedIdentifierWhenAbsent [

    | message calls |
    tool tools: { echoClient }.
    message := Dictionary
        with: 'tool_calls' -> (Array with: (Dictionary
            with: 'function' -> (Dictionary
                with: 'name' -> 'echo'
                with: 'arguments' -> '{"value":1}'))).
    calls := tool toolCallsFromMessage: message.
    self assert: (calls first id beginsWith: 'tool-').
]

{ #category : 'running' }
ChatPharoToolBackendTest >> testToolCallsFromMessageTriggersClientExecution [

    | message |
    tool tools: { echoClient }.
    message := Dictionary
        with: 'tool_calls' -> (Array with: (Dictionary
            with: 'id' -> 'call'
            with: 'function' -> (Dictionary
                with: 'name' -> 'echo'
                with: 'arguments' -> '{"value":2}'))).
    tool toolCallsFromMessage: message.
    self assert: tool appliedCalls size equals: 1.
]
