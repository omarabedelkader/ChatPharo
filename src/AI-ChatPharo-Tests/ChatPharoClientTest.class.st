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
