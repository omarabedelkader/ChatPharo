"
Thin convenience subclass used inside agents when they build synthetic history entries (e.g., the solitary user prompt passed to ChatPharoTool).
"
Class {
	#name : 'ChatPharoHistorySaver',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content',
		'toolCalls'
	],
	#category : 'AI-ChatPharo-History',
	#package : 'AI-ChatPharo-History'
}

{ #category : 'as yet unclassified' }
ChatPharoHistorySaver class >> role: r content: c [
	^ self role: r content: c toolCalls: nil
]

{ #category : 'as yet unclassified' }
ChatPharoHistorySaver class >> role: r content: c toolCalls: t [ 

	^ self new
		role: r; content: c; toolCalls: t;
		yourself
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> content: anObject [

	content := anObject
]

{ #category : 'as yet unclassified' }
ChatPharoHistorySaver >> historyStringOn: strm [ 

	strm nextPutAll: role; nextPutAll: ': '; nextPutAll: content; cr
]

{ #category : 'as yet unclassified' }
ChatPharoHistorySaver >> putOpenAIChatMessagesOn: stream [
		| msg |
		msg := Dictionary with: 'role' -> role.
		content ifNotNil: [ msg add: 'content' -> content ].
		toolCalls ifNotNil: [
				msg add: 'tool_calls'
					-> (toolCalls collect: [ :tc | tc openAIChatToolCall ] as: Array) ].
		stream nextPut: msg.
		toolCalls ifNotNil: [
			toolCalls do: [ :tc | stream nextPut: tc openAIChatToolMessage ] ] 
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> role [

	^ role
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> role: anObject [

	role := anObject
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> toolCalls [

	^ toolCalls
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> toolCalls: anObject [

	toolCalls := anObject
]
