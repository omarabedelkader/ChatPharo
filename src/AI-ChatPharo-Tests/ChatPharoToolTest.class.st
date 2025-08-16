Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool',
		'testTool'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
ChatPharoToolTest >> setUp [ 

    super setUp.
    testTool := ChatPharoToolTestTool new.
    tool := ChatPharoTool basicNew.
    tool instVarNamed: #tools put: { testTool }.
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionHandlesToolError [ 
    | result |
    testTool shouldError: true.
    result := tool applyToolFunction: 'testTool' arguments: Dictionary new.
    self assert: (result at: 'error') equals: 'boom'.

]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionReturnsErrorWhenUnknown [

    | result |
    tool instVarNamed: #tools put: {}.
    result := tool applyToolFunction: 'unknown' arguments: Dictionary new.
    self assert: (result at: 'error') equals: 'There is no function named "unknown"'.
]

{ #category : 'running' }
ChatPharoToolTest >> testOnToolExecutionCallbackTriggered [

    | count |
    count := 0.
    tool onToolExecution: [ count := count + 1 ].
    tool applyToolFunction: 'testTool' arguments: Dictionary new.
    self assert: count equals: 1.
]

{ #category : 'running' }
ChatPharoToolTest >> testToolCallsFromMessageParsesAndExecutesCall [


      | message calls expected count |
      count := 0.
      tool onToolExecution: [ count := count + 1 ].
      message := Dictionary with: 'tool_calls' -> (Array with: (Dictionary
          with: 'id' -> '1'
          with: 'function' -> (Dictionary
              with: 'name' -> 'testTool'
              with: 'arguments' -> '{}'))).
      calls := tool toolCallsFromMessage: message.
      expected := STONJSON toString: (Dictionary with: 'ok' -> true).
      self assert: calls size equals: 1.
      self assert: count equals: 1.
      self assert: calls first id equals: '1'.
      self assert: calls first functionName equals: 'testTool'.
      self assert: calls first arguments equals: '{}'.
      self assert: calls first content equals: expected.
]

{ #category : 'running' }
ChatPharoToolTest >> testToolCallsFromMessageWithoutToolCallsReturnsNil [

    | message calls |
    message := Dictionary new.
    calls := tool toolCallsFromMessage: message.
    self assert: calls isNil.
]
