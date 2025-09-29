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
ChatPharoBackendHistoryTest >> testHistoryMessageHistoryStringOnIncludesRole [

    | text |
    text := String streamContents: [ :stream |
        (ChatPharoHistoryMessage role: 'assistant' content: 'Answer') historyStringOn: stream ].
    self assert: text equals: 'assistant: Answer', String cr
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
