"
Counterpart produced by ChatPharoTool when the assistant requests a function call; later replayed as JSON so the model sees the result.

"
Class {
	#name : 'ChatPharoHistorySaverToolCall',
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
ChatPharoHistorySaverToolCall class >> id: anId functionName: aFn arguments: args content: c [ 

	^ self basicNew initializeWithID: anId functionName: aFn arguments: args content: c; yourself
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> arguments: anObject [

	arguments := anObject
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> functionName [

	^ functionName
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> functionName: anObject [

	functionName := anObject
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> id [

	^ id
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> id: anObject [

	id := anObject
]

{ #category : 'initialization' }
ChatPharoHistorySaverToolCall >> initializeWithID: anId functionName: aFn arguments: args content: c [

	id := anId.
	functionName := aFn.
	arguments := args.
	content := c
]

{ #category : 'initialization' }
ChatPharoHistorySaverToolCall >> openAIChatToolCall [ 

	^ Dictionary
		with:'type'->'function'
		with:'id'->id
		with:'function'->(Dictionary with:'name'->functionName with:'arguments'->arguments)
]

{ #category : 'initialization' }
ChatPharoHistorySaverToolCall >> openAIChatToolMessage [ 

	^ Dictionary
	with: 'role' -> 'tool'
	with: 'tool_call_id' -> id
	with: 'content' -> (content ifNil: [ '[No tool result]' ])
]
