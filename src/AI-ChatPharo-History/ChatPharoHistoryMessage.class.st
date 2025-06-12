"
Immutable value object with role, content, and optional toolCalls. Knows how to render itself in both textual and JSON forms.
"
Class {
	#name : 'ChatPharoHistoryMessage',
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
ChatPharoHistoryMessage class >> role: aRole content: content [ 

    ^ self role: aRole content: content toolCalls: nil
]

{ #category : 'contents' }
ChatPharoHistoryMessage class >> role: role content: content toolCalls: toolCalls [ 

    ^ self new
        role: role;
        content: content;
        toolCalls: toolCalls;
        yourself
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> chatMessagesOn: aStream [

    | msg |
    msg := Dictionary with: 'role' -> role.
    content ifNotNil:[ msg add: 'content' -> content ].
    toolCalls ifNotNil:[
        msg add: 'tool_calls' -> (toolCalls collect: [ :tc | tc toolCall ] asArray) ].
    aStream nextPut: msg.
    toolCalls ifNotNil:[
        toolCalls do:[ :tc | aStream nextPut: tc toolMessage ] ]
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> historyStringOn: aStream [ 

    aStream
        nextPutAll: role;
        nextPutAll: ': ';
        nextPutAll: content;
        nextPutAll: String cr
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> putOpenAIChatMessagesOn: aStream [
    "Adaptor so that both Saver and Message respond to the same selector."
    
    ^ self chatMessagesOn: aStream
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> role [

	^ role
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> role: anObject [

	role := anObject
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> toolCalls [

	^ toolCalls
]

{ #category : 'accessing' }
ChatPharoHistoryMessage >> toolCalls: anObject [

	toolCalls := anObject
]
