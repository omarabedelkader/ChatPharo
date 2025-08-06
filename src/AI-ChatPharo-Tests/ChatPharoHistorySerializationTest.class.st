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
