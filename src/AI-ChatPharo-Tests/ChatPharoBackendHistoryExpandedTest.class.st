Class {
	#name : 'ChatPharoBackendHistoryExpandedTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> setUp [

    super setUp.
    history := ChatPharoHistory new
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddAssistantCreatesAssistantMessage [

    history addAssistant: 'hi'.
    self assert: history messages size equals: 1.
    self assert: history messages first role equals: 'assistant'.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddAssistantMessageLeavesToolCallsNil [

    history addAssistant: 'Hello backend'.
    self assert: history messages size equals: 1.
    self assert: history messages first toolCalls isNil
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddAssistantMessageSetsRoleAndContent [

    | message |
    history addAssistant: 'Hello backend'.
    message := history messages first.
    self assert: message role equals: 'assistant'.
    self assert: message content equals: 'Hello backend'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddAssistantSupportsMultipleEntries [

    history addAssistant: 'One'.
    history addAssistant: 'Two'.
    self assert: history messages size equals: 2.
    self assert: history messages last content equals: 'Two'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddMessageStoresProvidedHistoryMessage [

    | custom |
    custom := ChatPharoHistoryMessage role: 'system' content: 'Config'.
    history addMessage: custom.
    self assert: history messages first identicalTo: custom
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddMessageWithToolCallPersistsReference [

    | toolCall custom |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: (Dictionary with: 'value' -> '42')
        content: 'answer'.
    custom := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Working'
        toolCalls: { toolCall }.
    history addMessage: custom.
    self assert: history messages first toolCalls first identicalTo: toolCall
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddUserCreatesUserMessage [

    history addUser: 'hello'.
    self assert: history messages first role equals: 'user'.
    self assert: history messages first content equals: 'hello'.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddUserMessageLeavesToolCallsNil [

    history addUser: 'Hello'.
    self assert: history messages first toolCalls isNil
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddUserMessageSetsRoleAndContent [

    | message |
    history addUser: 'Hello'.
    message := history messages first.
    self assert: message role equals: 'user'.
    self assert: message content equals: 'Hello'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAddUserSupportsMultipleEntries [

    history addUser: 'First'.
    history addUser: 'Second'.
    self assert: history messages size equals: 2.
    self assert: history messages last role equals: 'user'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAsPromptPrefixEndsEachMessageWithCarriageReturn [ 

    history addAssistant: 'Line one'.
    history addUser: 'Line two'.
    self assert: (history asPromptPrefix endsWith: String cr)
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAsPromptPrefixHandlesNilContentAsEmptyString [

    | message |
    message := ChatPharoHistoryMessage role: 'assistant' content: nil.
    history addMessage: message.
    self assert: history asPromptPrefix equals: 'assistant: ' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAsPromptPrefixIncludesAssistantLine [

    history addAssistant: 'Hi'.
    self assert: history asPromptPrefix equals: 'assistant: Hi' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testAsPromptPrefixPreservesMessageOrder [

    history addUser: 'First'.
    history addAssistant: 'Second'.
    self assert: history asPromptPrefix equals: ('user: First' , String cr , 'assistant: Second' , String cr)
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnEmitsAssistantDictionary [

    | stream messages |
    history addAssistant: 'Reply'.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 1.
    self assert: ((messages first) at: 'role') equals: 'assistant'.
    self assert: ((messages first) at: 'content') equals: 'Reply'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnEmitsToolCallMetadata [ 

    | stream messages toolCall assistant |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: '{}'
        content: 'done'.
    assistant := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tool'
        toolCalls: { toolCall }.
    history addMessage: assistant.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: (((messages first) at: 'tool_calls') first at: 'id') equals: 'tool-1'.
    self assert: ((messages second) at: 'tool_call_id') equals: 'tool-1'.
    self assert: ((messages second) at: 'role') equals: 'tool'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnEmitsToolResultForEachToolCall [

    | stream messages toolCall another assistant |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: '{}'
        content: 'done'.
    another := ChatPharoHistorySaverToolCall
        id: 'tool-2'
        functionName: 'search'
        arguments: '{}'
        content: 'ok'.
    assistant := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tools'
        toolCalls: { toolCall. another }.
    history addMessage: assistant.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 3.
    self assert: ((messages second) at: 'tool_call_id') equals: 'tool-1'.
    self assert: ((messages third) at: 'tool_call_id') equals: 'tool-2'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnIncludesToolMessages [

    | toolCall stream collection |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'id-1'
        functionName: 'fn'
        arguments: '{}'
        content: 'tool-result'.
    history addMessage: (ChatPharoHistoryMessage
        role: 'assistant'
        content: nil
        toolCalls: { toolCall }).
    stream := WriteStream on: OrderedCollection new.
    history chatMessagesOn: stream.
    collection := stream contents.
    self assert: collection size equals: 2.
    self assert: (collection first at: 'role') equals: 'assistant'.
    self assert: (collection second at: 'role') equals: 'tool'.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnOmitsContentKeyWhenNil [

    | message stream json |
    message := ChatPharoHistoryMessage role: 'assistant' content: nil.
    history addMessage: message.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    json := stream contents first.
    self deny: (json includesKey: 'content')
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testChatMessagesOnPreservesMessageOrder [

    | stream messages |
    history addUser: 'First'.
    history addAssistant: 'Second'.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: ((messages first) at: 'role') equals: 'user'.
    self assert: ((messages second) at: 'role') equals: 'assistant'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testClearAllowsNewEntriesAfterReset [

    history addUser: 'First'.
    history clear.
    history addAssistant: 'Second'.
    self assert: history messages size equals: 1.
    self assert: history messages first role equals: 'assistant'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testClearRemovesAllMessages [

    history addUser: 'hi'.
    history clear.
    self assert: history messages isEmpty.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageChatMessagesOnEncodesArgumentsDictionary [

    | message stream payload function |
    message := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tool'
        toolCalls: {
            ChatPharoHistorySaverToolCall
                id: 'call-1'
                functionName: 'lookup'
                arguments: (Dictionary with: 'query' -> '42')
                content: 'answer'
        }.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    payload := stream contents first.
    function := payload at: 'tool_calls'.
    self assert: ((((function first) at: 'function') at: 'arguments') includesSubstring: 'query')
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageChatMessagesOnIncludesToolResultFallback [

    | message stream toolResult |
    message := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tool'
        toolCalls: {
            ChatPharoHistorySaverToolCall
                id: 'call-1'
                functionName: 'lookup'
                arguments: '{}'
                content: nil
        }.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    toolResult := stream contents second.
    self assert: (toolResult at: 'content') equals: '[No tool result]'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageContentAccessorAcceptsNil [

    | message |
    message := ChatPharoHistoryMessage new.
    message content: nil.
    self assert: message content isNil
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageHistoryStringOnFormatsLine [

    | message text |
    message := ChatPharoHistoryMessage role: 'assistant' content: 'Hello'.
    text := String streamContents: [ :stream | message historyStringOn: stream ].
    self assert: text equals: 'assistant: Hello' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageHistoryStringOnHandlesNilContent [

    | message text |
    message := ChatPharoHistoryMessage role: 'assistant' content: nil.
    text := String streamContents: [ :stream | message historyStringOn: stream ].
    self assert: text equals: 'assistant: ' , String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessagePutOpenAIChatMessagesOnDelegatesToChatMessagesOn [

    | message first second |
    message := ChatPharoHistoryMessage role: 'user' content: 'Hi'.
    first := OrderedCollection new writeStream.
    second := OrderedCollection new writeStream.
    message chatMessagesOn: first.
    message putOpenAIChatMessagesOn: second.
    self assert: first contents equals: second contents
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageRoleAccessorUpdatesValue [

    | message |
    message := ChatPharoHistoryMessage new.
    message role: 'system'.
    self assert: message role equals: 'system'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageToolCallsAccessorStoresCollection [

    | message calls |
    message := ChatPharoHistoryMessage new.
    calls := { ChatPharoHistorySaverToolCall
        id: 't'
        functionName: 'f'
        arguments: '{}'
        content: 'ok' }.
    message toolCalls: calls.
    self assert: message toolCalls identicalTo: calls
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessageWithToolCallProducesToolRoleEntry [

    | message stream messages |
    message := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tool'
        toolCalls: {
            ChatPharoHistorySaverToolCall
                id: 'call-1'
                functionName: 'lookup'
                arguments: '{}'
                content: 'done'
        }.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 2.
    self assert: ((messages second) at: 'role') equals: 'tool'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testHistoryMessagesAreDistinctInstances [

    history addAssistant: 'One'.
    history addAssistant: 'Two'.
    self deny: history messages first identicalTo: history messages last
]

{ #category : 'tests' }
ChatPharoBackendHistoryExpandedTest >> testHistorySaverHistoryStringIncludesToolCalls [

    | saver stream toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'id-1'
        functionName: 'fn'
        arguments: '{}'
        content: 'result'.
    saver := ChatPharoHistorySaver role: 'assistant' content: 'answer' toolCalls: { toolCall }.
    stream := WriteStream on: String new.
    saver historyStringOn: stream.
    self assert: (stream contents includesSubstring: 'assistant: answer').
]

{ #category : 'tests' }
ChatPharoBackendHistoryExpandedTest >> testHistorySaverToolCallOpenAIChatToolCallStructure [

    | call dict |
    call := ChatPharoHistorySaverToolCall
        id: 'call-1'
        functionName: 'fn'
        arguments: (Dictionary with: 'key' -> 'value')
        content: 'content'.
    dict := call openAIChatToolCall.
    self assert: (dict at: 'id') equals: 'call-1'.
    self assert: (((dict at: 'function') at: 'arguments') includesSubstring: '"key"').
]

{ #category : 'tests' }
ChatPharoBackendHistoryExpandedTest >> testHistorySaverToolCallOpenAIChatToolMessageDefaultsWhenNil [ 

    | call message |
    call := ChatPharoHistorySaverToolCall
        id: 'call-2'
        functionName: 'fn'
        arguments: '{}'
        content: nil.
    message := call openAIChatToolMessage.
    self assert: (message at: 'content') equals: '[No tool result]'.

]

{ #category : 'tests' }
ChatPharoBackendHistoryExpandedTest >> testHistorySaverToolCallsAppendToolMessages [

    | saver stream toolCall collection |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'id-2'
        functionName: 'fn'
        arguments: '{}'
        content: 'result'.
    saver := ChatPharoHistorySaver role: 'assistant' content: nil toolCalls: { toolCall }.
    stream := WriteStream on: OrderedCollection new.
    saver putOpenAIChatMessagesOn: stream.
    collection := stream contents.
    self assert: collection size equals: 2.
    self assert: (collection first at: 'role') equals: 'assistant'.
    self assert: (collection second at: 'role') equals: 'tool'.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testMessagesCollectionIsMutable [

    history messages add: (ChatPharoHistoryMessage role: 'system' content: 'Manual').
    self assert: history messages size equals: 1.
    self assert: history messages first role equals: 'system'
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testMessagesInitiallyEmptyOrderedCollection [ 

    self assert: history messages isEmpty.
    self assert: history messages class equals: OrderedCollection
]

{ #category : 'tests' }
ChatPharoBackendHistoryExpandedTest >> testPutOpenAIChatMessagesOnDelegatesToChatMessagesOn [

    | stream collection |
    history addUser: 'hi'.
    stream := WriteStream on: OrderedCollection new.
    history putOpenAIChatMessagesOn: stream.
    collection := stream contents.
    self assert: collection size equals: 1.
    self assert: (collection first at: 'role') equals: 'user'.
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testPutOpenAIChatMessagesOnIncludesToolCalls [

    | stream messages toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: '{}'
        content: 'result'.
    history addMessage: (ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Use tool'
        toolCalls: { toolCall }).
    stream := OrderedCollection new writeStream.
    history putOpenAIChatMessagesOn: stream.
    messages := stream contents.
    self assert: ((messages first) at: 'tool_calls') notNil
]

{ #category : 'running' }
ChatPharoBackendHistoryExpandedTest >> testPutOpenAIChatMessagesOnMatchesChatMessagesOn [

    | first second |
    history addUser: 'Hello'.
    first := OrderedCollection new writeStream.
    second := OrderedCollection new writeStream.
    history chatMessagesOn: first.
    history putOpenAIChatMessagesOn: second.
    self assert: first contents equals: second contents
]
