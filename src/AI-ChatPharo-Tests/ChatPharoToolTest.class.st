Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoToolTest >> setUp [ 

    super setUp.
    tool := ChatPharoTool new
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionWithNoTools [ 

    | result |
    result := tool applyToolFunction: 'dummy' arguments: Dictionary new.
    self assert: (result at: 'error') notNil
]
