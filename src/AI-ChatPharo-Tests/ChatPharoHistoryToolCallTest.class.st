Class {
	#name : 'ChatPharoHistoryToolCallTest',
	#superclass : 'TestCase',
	#instVars : [
		'call'
	],
	#category : 'AI-ChatPharo-Tests-Tools',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> setUp [ 

        super setUp.
        call := ChatPharoHistoryToolCall id: '1' functionName: 'fn' arguments: '{}' content: 'c'
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testArgumentsSetterGetter [ 

        call arguments: '{"a":1}'.
        self assert: call arguments equals: '{"a":1}'.
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testFunctionNameSetterGetter [ 

        call functionName: 'bar'.
        self assert: call functionName equals: 'bar'.
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testIdSetterGetter [ 

        call id: '2'.
        self assert: call id equals: '2'.
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testInitializeWithIdFunctionNameArgumentsContent [ 

        self assert: call id equals: '1'.
        self assert: call functionName equals: 'fn'.
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testToolCallDictionary [ 

        | dict |
        dict := call toolCall.
        self assert: (dict at: 'id') equals: '1'.
        self assert: ((dict at: 'function') at: 'name') equals: 'fn'.
]

{ #category : 'running' }
ChatPharoHistoryToolCallTest >> testToolMessageDictionary [ 

        | dict |
        dict := call toolMessage.
        self assert: (dict at: 'tool_call_id') equals: '1'.
        self assert: (dict at: 'content') equals: 'c'.
]
