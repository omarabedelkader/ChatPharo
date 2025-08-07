Class {
	#name : 'ChatPharoHistorySaverToolCallTest',
	#superclass : 'TestCase',
	#instVars : [
		'call'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoHistorySaverToolCallTest >> setUp [ 

        super setUp.
        call := ChatPharoHistorySaverToolCall id: '1' functionName: 'fn' arguments: '{}' content: 'c'
]

{ #category : 'tests' }
ChatPharoHistorySaverToolCallTest >> testArgumentsSetterGetter [ 

        call arguments: '{"a":1}'.
        self assert: call arguments equals: '{"a":1}'.
]

{ #category : 'running' }
ChatPharoHistorySaverToolCallTest >> testCreationStoresValues [ 

        self assert: call id equals: '1'.
        self assert: call functionName equals: 'fn'.
]

{ #category : 'tests' }
ChatPharoHistorySaverToolCallTest >> testFunctionNameSetterGetter [ 

        call functionName: 'bar'.
        self assert: call functionName equals: 'bar'.
]

{ #category : 'tests' }
ChatPharoHistorySaverToolCallTest >> testIdSetterGetter [ 

        call id: '2'.
        self assert: call id equals: '2'.
]

{ #category : 'running' }
ChatPharoHistorySaverToolCallTest >> testInvalidArgumentsHandled [ 

    call arguments: '{invalid-json'.
    self assert: (call arguments includesSubstring: '{invalid-json').
]

{ #category : 'running' }
ChatPharoHistorySaverToolCallTest >> testOpenAIChatToolCall [ 

        | dict |
        dict := call openAIChatToolCall.
        self assert: (dict at: 'id') equals: '1'.
]

{ #category : 'tests' }
ChatPharoHistorySaverToolCallTest >> testOpenAIChatToolMessage [ 

        | dict |
        dict := call openAIChatToolMessage.
        self assert: (dict at: 'tool_call_id') equals: '1'.
]

{ #category : 'tests' }
ChatPharoHistorySaverToolCallTest >> testOpenAIChatToolMessageDefaultsContent [ 

        | dict callWithoutContent |
        callWithoutContent := ChatPharoHistorySaverToolCall id: '2' functionName: 'fn' arguments: '{}' content: nil.
        dict := callWithoutContent openAIChatToolMessage.
        self assert: (dict at: 'content') equals: '[No tool result]'.
]
