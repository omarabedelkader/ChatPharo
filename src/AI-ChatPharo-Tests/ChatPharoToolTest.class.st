Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool',
		'testTool'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
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
