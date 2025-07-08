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

{ #category : 'contents' }
ChatPharoHistorySaver class >> role: r content: c [
	^ self role: r content: c toolCalls: nil
]

{ #category : 'contents' }
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

{ #category : 'history' }
ChatPharoHistorySaver >> historyStringOn: strm [

	        strm
                nextPutAll: role;
                nextPutAll: ': ';
                nextPutAll: (content ifNil: [ '' ]);
                cr
]

{ #category : 'history' }
ChatPharoHistorySaver >> putOpenAIChatMessagesOn: stream [
		| msg |
		msg := Dictionary with: 'role' -> role.
		msg add: 'content' -> (content ifNil: [ '[No assistant response]' ]).
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
