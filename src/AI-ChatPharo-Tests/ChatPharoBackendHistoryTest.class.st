Class {
	#name : 'ChatPharoBackendHistoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoBackendHistoryTest >> setUp [

    super setUp.
    history := ChatPharoHistory new
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAddAssistantAndUserCreateDistinctMessages [

    history addUser: 'Hello'.
    history addAssistant: 'Hi'.
    self assert: history messages size equals: 2.
    self deny: (history messages first) identicalTo: (history messages second)
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAddAssistantCreatesHistoryMessage [

    history addAssistant: 'Answer'.
    self assert: history messages size equals: 1.
    self assert: history messages first role equals: 'assistant'.
    self assert: history messages first content equals: 'Answer'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAddMessageAppendsCustomHistoryMessage [

    | message |
    message := ChatPharoHistoryMessage role: 'system' content: 'Rules'.
    history addMessage: message.
    self assert: history messages size equals: 1.
    self assert: history messages first identicalTo: message
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAddMessageMaintainsInsertionOrder [

    | first second |
    first := ChatPharoHistoryMessage role: 'system' content: 'Rules'.
    second := ChatPharoHistoryMessage role: 'assistant' content: 'Okay'.
    history addMessage: first.
    history addMessage: second.
    self assert: history messages first identicalTo: first.
    self assert: history messages second identicalTo: second
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAddUserCreatesHistoryMessage [

    history addUser: 'Question'.
    self assert: history messages size equals: 1.
    self assert: history messages first role equals: 'user'.
    self assert: history messages first content equals: 'Question'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAsPromptPrefixConcatenatesEntries [

    history addUser: 'Hello'.
    history addAssistant: 'Hi there'.
    self assert: history asPromptPrefix equals: 'user: Hello', String cr, 'assistant: Hi there', String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testAsPromptPrefixOnEmptyHistoryIsEmptyString [

    self assert: history asPromptPrefix equals: ''
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testChatMessagesOnIncludesToolCallMessages [

    | stream messages toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'tool-1'
        functionName: 'lookup'
        arguments: (Dictionary with: 'key' -> 'value')
        content: 'result'.
    history addMessage: (ChatPharoHistoryMessage
        role: 'assistant'
        content: nil
        toolCalls: { toolCall }).
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 2.
    self assert: ((messages first) at: 'tool_calls') size equals: 1.
    self assert: ((messages second) at: 'role') equals: 'tool'.
    self assert: ((messages second) at: 'content') equals: 'result'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testChatMessagesOnMaintainsOrderForMultipleEntries [

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
ChatPharoBackendHistoryTest >> testChatMessagesOnOmitsNilContentKey [

    | message stream json |
    message := ChatPharoHistoryMessage role: 'assistant' content: nil.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    json := stream contents first.
    self deny: (json includesKey: 'content')
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testChatMessagesOnOrdersToolResultAfterAssistant [

    | message stream messages toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'call'
        functionName: 'f'
        arguments: '{}'
        content: 'done'.
    message := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Working'
        toolCalls: { toolCall }.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 2.
    self assert: ((messages first) at: 'role') equals: 'assistant'.
    self assert: ((messages second) at: 'role') equals: 'tool'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testChatMessagesOnProducesRoleDictionaries [

    | stream messages |
    history addUser: 'Hello'.
    stream := OrderedCollection new writeStream.
    history chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 1.
    self assert: ((messages first) at: 'role') equals: 'user'.
    self assert: ((messages first) at: 'content') equals: 'Hello'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testClearOnEmptyHistoryLeavesMessagesEmpty [

    history clear.
    self assert: history messages isEmpty
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testClearRemovesAllMessages [

    history addUser: 'A'.
    history addAssistant: 'B'.
    history clear.
    self assert: history messages isEmpty
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistoryMessageChatMessagesIncludesContent [

    | message stream messages |
    message := ChatPharoHistoryMessage role: 'assistant' content: 'Answer'.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 1.
    self assert: ((messages first) at: 'role') equals: 'assistant'.
    self assert: ((messages first) at: 'content') equals: 'Answer'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistoryMessageChatMessagesSerializesToolCalls [

    | message stream messages toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'call-1'
        functionName: 'lookup'
        arguments: (Dictionary with: 'id' -> 42)
        content: 'done'.
    message := ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Using tool'
        toolCalls: { toolCall }.
    stream := OrderedCollection new writeStream.
    message chatMessagesOn: stream.
    messages := stream contents.
    self assert: ((messages first) at: 'tool_calls') size equals: 1.
    self assert: ((messages second) at: 'role') equals: 'tool'.
    self assert: ((messages second) at: 'content') equals: 'done'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistoryMessageHistoryStringHandlesNilContent [

    | text |
    text := String streamContents: [ :stream |
        (ChatPharoHistoryMessage role: 'user' content: nil) historyStringOn: stream ].
    self assert: text equals: 'user: ', String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistoryMessageHistoryStringOnIncludesRole [

    | text |
    text := String streamContents: [ :stream |
        (ChatPharoHistoryMessage role: 'assistant' content: 'Answer') historyStringOn: stream ].
    self assert: text equals: 'assistant: Answer', String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistoryMessagePutOpenAIChatMessagesOmitsNilContent [

    | stream entry |
    stream := OrderedCollection new writeStream.
    (ChatPharoHistoryMessage role: 'assistant' content: nil) putOpenAIChatMessagesOn: stream.
    entry := stream contents first.
    self deny: (entry includesKey: 'content')
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistorySaverHistoryStringHandlesNilContent [

    | text |
    text := String streamContents: [ :stream |
        (ChatPharoHistorySaver role: 'assistant' content: nil) historyStringOn: stream ].
    self assert: text equals: 'assistant: ', String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testHistorySaverPutOpenAIChatMessagesIncludesToolCalls [

    | saver stream messages toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: '1'
        functionName: 'lookup'
        arguments: '{}'
        content: 'result'.
    saver := ChatPharoHistorySaver role: 'assistant' content: 'Using tool' toolCalls: { toolCall }.
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    messages := stream contents.
    self assert: ((messages first) at: 'tool_calls') size equals: 1.
    self assert: ((messages second) at: 'role') equals: 'tool'
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testMessagesAccessorReturnsSameCollectionInstance [

    | messagesCollection message |
    messagesCollection := history messages.
    message := ChatPharoHistoryMessage role: 'system' content: 'Remember'.
    messagesCollection add: message.
    self assert: history messages size equals: 1.
    self assert: history messages first identicalTo: message
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testMessagesReturnsOrderedCollection [

    history addUser: 'Hello'.
    self assert: history messages class equals: OrderedCollection.
    self assert: history messages size equals: 1
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testPutOpenAIChatMessagesMatchesChatMessages [

    | streamOne streamTwo |
    history addUser: 'Hello'.
    streamOne := OrderedCollection new writeStream.
    history chatMessagesOn: streamOne.
    streamTwo := OrderedCollection new writeStream.
    history putOpenAIChatMessagesOn: streamTwo.
    self assert: streamTwo contents equals: streamOne contents
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testPutOpenAIChatMessagesMatchesChatMessagesWithToolCall [

    | streamOne streamTwo toolCall |
    toolCall := ChatPharoHistorySaverToolCall
        id: 'x'
        functionName: 'lookup'
        arguments: '{}'
        content: 'result'.
    history addMessage: (ChatPharoHistoryMessage
        role: 'assistant'
        content: 'Using tool'
        toolCalls: { toolCall }).
    streamOne := OrderedCollection new writeStream.
    history chatMessagesOn: streamOne.
    streamTwo := OrderedCollection new writeStream.
    history putOpenAIChatMessagesOn: streamTwo.
    self assert: streamTwo contents equals: streamOne contents
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testSaverHistoryStringOnUsesDefaultFormatting [

    | text |
    text := String streamContents: [ :stream |
        (ChatPharoHistorySaver role: 'assistant' content: 'Saved') historyStringOn: stream ].
    self assert: text equals: 'assistant: Saved', String cr
]

{ #category : 'running' }
ChatPharoBackendHistoryTest >> testSaverPutOpenAIChatMessagesDefaultsContentWhenNil [

    | saver stream messages |
    saver := ChatPharoHistorySaver role: 'assistant' content: nil.
    stream := OrderedCollection new writeStream.
    saver putOpenAIChatMessagesOn: stream.
    messages := stream contents.
    self assert: messages size equals: 1.
    self assert: ((messages first) at: 'role') equals: 'assistant'.
    self assert: ((messages first) at: 'content') equals: '[No assistant response]'
]
