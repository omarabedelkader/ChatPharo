Class {
	#name : 'ChatPharoBackendHistorySaverExpandedTest',
	#superclass : 'TestCase',
	#instVars : [
		'saver',
		'toolCall'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> setUp [

    super setUp.
    saver := ChatPharoHistorySaver role: 'assistant' content: 'Response'.
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: (Dictionary with: 'value' -> '42')
        content: 'result'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testClassRoleContentConvenienceInitializesFields [

    | instance |
    instance := ChatPharoHistorySaver role: 'system' content: 'Prompt'.
    self assert: instance role equals: 'system'.
    self assert: instance content equals: 'Prompt'.
    self assert: instance toolCalls isNil
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testClassRoleContentToolCallsConvenienceInitializesFields [

    | instance |
    instance := ChatPharoHistorySaver role: 'assistant' content: 'Answer' toolCalls: { toolCall }.
    self assert: instance role equals: 'assistant'.
    self assert: instance content equals: 'Answer'.
    self assert: instance toolCalls size equals: 1
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testContentAccessorAcceptsNil [

    saver content: nil.
    self assert: saver content isNil
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testContentAccessorReturnsValue [

    self assert: saver content equals: 'Response'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testHistoryStringOnFormatsRoleAndContent [

    | text |
    text := String streamContents: [ :stream | saver historyStringOn: stream ].
    self assert: text equals: 'assistant: Response' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testHistoryStringOnHandlesNilContentAsEmpty [

    | text |
    saver content: nil.
    text := String streamContents: [ :stream | saver historyStringOn: stream ].
    self assert: text equals: 'assistant: ' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testPutOpenAIChatMessagesOnEmitsToolMessagesAfterAssistant [

    | stream messages |
    saver toolCalls: { toolCall }.
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 2.
    self assert: ((messages first) at: 'role') equals: 'assistant'.
    self assert: ((messages second) at: 'role') equals: 'tool'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testPutOpenAIChatMessagesOnIncludesRoleAndContent [

    | stream payload |
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    payload := stream contents first.
    self assert: (payload at: 'role') equals: 'assistant'.
    self assert: (payload at: 'content') equals: 'Response'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testPutOpenAIChatMessagesOnReplacesNilContentWithPlaceholder [

    | stream payload |
    saver content: nil.
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    payload := stream contents first.
    self assert: (payload at: 'content') equals: '[No assistant response]'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testPutOpenAIChatMessagesOnWritesToolCallsWhenPresent [ 

    | stream payload |
    saver toolCalls: { toolCall }.
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    payload := stream contents first.
    self assert: ((payload at: 'tool_calls') first at: 'id') equals: 'tool-1'

]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testRoleAccessorCanBeUpdated [

    saver role: 'system'.
    self assert: saver role equals: 'system'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testRoleAccessorReturnsValue [

    self assert: saver role equals: 'assistant'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallArgumentsAccessorStoresValue [ 

    toolCall arguments: (Dictionary with: 'query' -> 'value').
    self assert: (toolCall arguments at: 'query') equals: 'value'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallContentAccessorAcceptsNil [

    toolCall content: nil.
    self assert: toolCall content isNil
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallContentAccessorReturnsValue [

    self assert: toolCall content equals: 'result'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallFunctionNameAccessorReturnsValue [

    self assert: toolCall functionName equals: 'lookup'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolCallEncodesArgumentsDictionary [

    | payload function |
    toolCall arguments: (Dictionary with: 'key' -> 'value').
    payload := toolCall openAIChatToolCall.
    function := payload at: 'function'.
    self assert: ((function at: 'arguments') includesSubstring: '"key"').
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolCallIncludesFunctionType [

    | payload |
    payload := toolCall openAIChatToolCall.
    self assert: (payload at: 'type') equals: 'function'.
    self assert: (payload at: 'id') equals: 'tool-1'

]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolCallPreservesStringArguments [

    | payload |
    toolCall arguments: '{}'.
    payload := toolCall openAIChatToolCall.
    self assert: ((payload at: 'function') at: 'arguments') equals: '{}'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolMessageFallsBackWhenContentNil [

    | payload |
    toolCall content: nil.
    payload := toolCall openAIChatToolMessage.
    self assert: (payload at: 'content') equals: '[No tool result]'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolMessageIncludesToolCallId [

    | payload |
    payload := toolCall openAIChatToolMessage.
    self assert: (payload at: 'tool_call_id') equals: 'tool-1'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallOpenAIChatToolMessageUsesProvidedContent [

    | payload |
    payload := toolCall openAIChatToolMessage.
    self assert: (payload at: 'content') equals: 'result'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallStoresIdentifier [

    self assert: toolCall id equals: 'tool-1'
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallsAccessorCanBeUpdated [

    saver toolCalls: { toolCall }.
    self assert: saver toolCalls size equals: 1
]

{ #category : 'running' }
ChatPharoBackendHistorySaverExpandedTest >> testToolCallsAccessorReturnsNilByDefault [

    saver toolCalls: nil.
    self assert: saver toolCalls isNil
]
