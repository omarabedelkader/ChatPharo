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
        tool := ChatPharoMockTool baseURL: (ZnUrl fromString: 'http://x') system: nil
]

{ #category : 'running' }
ChatPharoToolTest >> testBaseURLAccessor [ 

        self assert: tool baseURL asString equals: 'http://x/'
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
