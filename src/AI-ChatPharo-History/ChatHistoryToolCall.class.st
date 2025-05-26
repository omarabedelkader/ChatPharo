Class {
	#name : 'ChatHistoryToolCall',
	#superclass : 'Object',
	#instVars : [
		'id',
		'functionName',
		'arguments',
		'content'
	],
	#category : 'AI-ChatPharo-History',
	#package : 'AI-ChatPharo-History'
}

{ #category : 'as yet unclassified' }
ChatHistoryToolCall class >> id: anId functionName: aName arguments: someArgs content: aContent [ 

    ^ self basicNew initializeWithID: anId functionName: aName arguments: someArgs content: aContent; yourself
]

{ #category : 'accessing' }
ChatHistoryToolCall >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ChatHistoryToolCall >> arguments: anObject [

	arguments := anObject
]

{ #category : 'accessing' }
ChatHistoryToolCall >> content [

	^ content
]

{ #category : 'accessing' }
ChatHistoryToolCall >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatHistoryToolCall >> functionName [

	^ functionName
]

{ #category : 'accessing' }
ChatHistoryToolCall >> functionName: anObject [

	functionName := anObject
]

{ #category : 'accessing' }
ChatHistoryToolCall >> id [

	^ id
]

{ #category : 'accessing' }
ChatHistoryToolCall >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
ChatHistoryToolCall >> initializeWithID: anId functionName: aName arguments: someArgs content: aContent [ 

    id := anId.
    functionName := aName.
    arguments := someArgs.
    content := aContent.
]

{ #category : 'initialization' }
ChatHistoryToolCall >> toolCall [ 

    ^ Dictionary
        with: 'type' -> 'function'
        with: 'id' -> id
        with: 'function' -> (Dictionary with: 'name' -> functionName with: 'arguments' -> arguments)
]

{ #category : 'initialization' }
ChatHistoryToolCall >> toolMessage [ 

    ^ Dictionary with: 'role' -> 'tool' with: 'tool_call_id' -> id with: 'content' -> content
]
