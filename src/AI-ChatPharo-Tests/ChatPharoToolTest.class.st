Class {
	#name : 'ChatPharoToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool'
	],
	#category : 'AI-ChatPharo-Tests-Tools',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
ChatPharoToolTest >> setUp [ 

        super setUp.
        tool := ChatPharoTool baseURL: (ZnUrl fromString: 'http://x') system: nil
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionExecutesTool [ 

        | executed |
        executed := false.
        tool tools: { ChatPharoClient name: 't' description: '' parameters: (Dictionary new) block: [ executed := true. Dictionary new ] }.
        tool applyToolFunction: 't' arguments: Dictionary new.
        self assert: executed
]

{ #category : 'running' }
ChatPharoToolTest >> testApplyToolFunctionHandlesMissingTool [ 

        | result |
        result := tool applyToolFunction: 'missing' arguments: Dictionary new.
        self assert: ((result at: 'error') includesSubstring: 'There is no function')
]

{ #category : 'running' }
ChatPharoToolTest >> testBaseURLAccessor [ 

        self assert: tool baseURL asString equals: 'http://x'
]

{ #category : 'running' }
ChatPharoToolTest >> testInitializationSetsModel [ 

        self assert: tool model notNil
]

{ #category : 'running' }
ChatPharoToolTest >> testSystemSetterGetter [ 

        tool system: 'sys'.
        self assert: tool system equals: 'sys'
]
