Class {
	#name : 'ChatHistoryMessage',
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
ChatHistoryMessage class >> role: aRole content: content [ 

    ^ self role: aRole content: content toolCalls: nil
]

{ #category : 'as yet unclassified' }
ChatHistoryMessage class >> role: role content: content toolCalls: toolCalls [ 

    ^ self new
        role: role;
        content: content;
        toolCalls: toolCalls;
        yourself
]

{ #category : 'accessing' }
ChatHistoryMessage >> chatMessagesOn: aStream [

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
ChatHistoryMessage >> content [

	^ content
]

{ #category : 'accessing' }
ChatHistoryMessage >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatHistoryMessage >> historyStringOn: aStream [ 

    aStream
        nextPutAll: role;
        nextPutAll: ': ';
        nextPutAll: content;
        nextPutAll: String cr
]

{ #category : 'accessing' }
ChatHistoryMessage >> role [

	^ role
]

{ #category : 'accessing' }
ChatHistoryMessage >> role: anObject [

	role := anObject
]

{ #category : 'accessing' }
ChatHistoryMessage >> toolCalls [

	^ toolCalls
]

{ #category : 'accessing' }
ChatHistoryMessage >> toolCalls: anObject [

	toolCalls := anObject
]
