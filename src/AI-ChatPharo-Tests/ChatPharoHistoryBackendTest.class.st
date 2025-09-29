Class {
	#name : 'ChatPharoHistoryBackendTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoHistoryBackendTest >> setUp [

    super setUp.
    history := ChatPharoHistory new.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testAddAssistantMessageAppendsAssistantRole [

    history addAssistant: 'answer'.
    self assert: history messages last role equals: 'assistant'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testAddMessageStoresExactInstance [

    | message |
    message := ChatPharoHistoryMessage role: 'system' content: 'prompt'.
    history addMessage: message.
    self assert: history messages first == message.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testAddUserMessageAppendsUserRole [

    history addUser: 'question'.
    self assert: history messages last role equals: 'user'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testAsPromptPrefixConcatenatesMessagesWithNewlines [

    history addUser: 'one'.
    history addAssistant: 'two'.
    self assert: (history asPromptPrefix includesSubstring: 'user: one').
    self assert: (history asPromptPrefix includesSubstring: 'assistant: two').
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testChatMessagesOnWritesMessagesInOrder [

    | entries |
    history addUser: 'first'.
    history addAssistant: 'second'.
    entries := Array streamContents: [ :stream | history chatMessagesOn: stream ].
    self assert: (entries first at: 'role') equals: 'user'.
    self assert: (entries second at: 'role') equals: 'assistant'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testClearRemovesAllMessages [

    history addUser: 'remove'.
    history clear.
    self assert: history messages isEmpty.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistoryMessageFactoryIncludesToolCalls [ 

    | tool message |
    tool := Dictionary with: 'custom' -> true.
    message := ChatPharoHistoryMessage role: 'assistant' content: 'reply' toolCalls: { tool }.
    self assert: (message toolCalls first at: 'custom').
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistoryMessageFactorySetsRoleAndContent [

    | message |
    message := ChatPharoHistoryMessage role: 'system' content: 'prompt'.
    self assert: message role equals: 'system'.
    self assert: message content equals: 'prompt'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistoryMessageHistoryStringOnTerminatesWithNewline [

    | output |
    output := String streamContents: [ :stream |
        (ChatPharoHistoryMessage role: 'user' content: 'ask') historyStringOn: stream ].
    self assert: (output endsWith: String cr).
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistorySaverHistoryStringOnFormatsContent [

    | saver output |
    saver := ChatPharoHistorySaver role: 'assistant' content: 'done'.
    output := String streamContents: [ :stream | saver historyStringOn: stream ].
    self assert: (output includesSubstring: 'assistant: done').
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistorySaverPutOpenAIChatMessagesOnAddsToolEntries [

    | call saver entries |
    call := ChatPharoHistorySaverToolCall id: 'id' functionName: 'fn' arguments: '{}' content: 'result'.
    saver := ChatPharoHistorySaver role: 'assistant' content: 'done' toolCalls: { call }.
    entries := Array streamContents: [ :stream | saver putOpenAIChatMessagesOn: stream ].
    self assert: entries size equals: 2.
    self assert: (entries first at: 'role') equals: 'assistant'.
    self assert: (entries second at: 'role') equals: 'tool'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistorySaverToolCallOpenAIChatToolCallSerializesArguments [

    | call payload |
    call := ChatPharoHistorySaverToolCall id: '1' functionName: 'run' arguments: (Dictionary with: 'value' -> 42) content: 'ok'.
    payload := call openAIChatToolCall.
    self assert: ((payload at: 'function') at: 'arguments') equals: '{"value":42}'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testHistorySaverToolCallOpenAIChatToolMessageUsesPlaceholderWhenNil [

    | call message |
    call := ChatPharoHistorySaverToolCall id: '1' functionName: 'run' arguments: '{}' content: nil.
    message := call openAIChatToolMessage.
    self assert: (message at: 'content') equals: '[No tool result]'.
]

{ #category : 'running' }
ChatPharoHistoryBackendTest >> testPutOpenAIChatMessagesOnDelegatesToChatMessagesOn [

    | entries |
    history addUser: 'first'.
    entries := Array streamContents: [ :stream | history putOpenAIChatMessagesOn: stream ].
    self assert: entries size equals: 1.
    self assert: (entries first at: 'role') equals: 'user'.
]
