"
Wraps one executed tool call in a form that can be injected back into the chat log to keep the assistant and the tool responses in sync.
"
Class {
	#name : 'ChatPharoHistoryToolCall',
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

{ #category : 'contents' }
ChatPharoHistoryToolCall class >> id: anId functionName: aName arguments: someArgs content: aContent [ 

    ^ self basicNew initializeWithID: anId functionName: aName arguments: someArgs content: aContent; yourself
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> arguments: anObject [

	arguments := anObject
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> functionName [

	^ functionName
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> functionName: anObject [

	functionName := anObject
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> id [

	^ id
]

{ #category : 'accessing' }
ChatPharoHistoryToolCall >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
ChatPharoHistoryToolCall >> initializeWithID: anId functionName: aName arguments: someArgs content: aContent [ 

    id := anId.
    functionName := aName.
    arguments := someArgs.
    content := aContent.
]

{ #category : 'initialization' }
ChatPharoHistoryToolCall >> toolCall [ 

    ^ Dictionary
        with: 'type' -> 'function'
        with: 'id' -> id
        with: 'function' -> (Dictionary with: 'name' -> functionName with: 'arguments' -> arguments)
]

{ #category : 'initialization' }
ChatPharoHistoryToolCall >> toolMessage [ 

    ^ Dictionary with: 'role' -> 'tool' with: 'tool_call_id' -> id with: 'content' -> content
]
