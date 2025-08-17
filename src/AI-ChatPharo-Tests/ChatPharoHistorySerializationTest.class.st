Class {
	#name : 'ChatPharoHistorySerializationTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoHistorySerializationTest >> setUp [ 

	super setUp.
	history := ChatPharoHistory new
]

{ #category : 'running' }
ChatPharoHistorySerializationTest >> testClearResetsStateCompletely [ 

	history addUser: 'x'.
	history clear.
	self
		assert: history messages isEmpty;
		assert: history asPromptPrefix isEmpty.
]

{ #category : 'running' }
ChatPharoHistorySerializationTest >> testPromptPrefixWithManyMessages [

	1 to: 50 do: [ :i |
		history addUser: 'msg-', i asString ].
	self
		assert: (history asPromptPrefix lines size) equals: 50.
]

{ #category : 'running' }
ChatPharoHistorySerializationTest >> testStonRoundTripPreservesMessages [
    | ston restored |
    history addUser: 'hello'.
    history addAssistant: 'hi'.
    ston := STON toString: history.
    restored := STON fromString: ston.
    self assert: (restored messages collect: #role) equals: (history messages collect: #role).
    self assert: (restored messages collect: #content) equals: (history messages collect: #content).
]

{ #category : 'running' }
ChatPharoHistorySerializationTest >> testStonRoundTripPreservesToolCalls [
    | call ston restored |
    call := ChatPharoHistorySaverToolCall id: '1' functionName: 'fn' arguments: '{}' content: 'out'.
    history addMessage: (ChatPharoHistoryMessage role: 'assistant' content: 'result' toolCalls: { call }).
    ston := STON toString: history.
    restored := STON fromString: ston.
    self assert: (restored messages first toolCalls first id) equals: '1'.
    self assert: (restored messages first toolCalls first functionName) equals: 'fn'.
]
