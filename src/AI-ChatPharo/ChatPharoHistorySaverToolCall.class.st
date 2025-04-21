Class {
	#name : 'ChatPharoHistorySaverToolCall',
	#superclass : 'Object',
	#instVars : [
		'id',
		'functionName',
		'arguments',
		'content'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'instance creation' }
ChatPharoHistorySaverToolCall class >> id: id functionName: functionName arguments: arguments content: content [

	^ self basicNew initializeWithID: id functionName: functionName arguments: arguments content: content; yourself
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> functionName [

	^ functionName
]

{ #category : 'accessing' }
ChatPharoHistorySaverToolCall >> id [

	^ id
]

{ #category : 'initialization' }
ChatPharoHistorySaverToolCall >> initializeWithID: initialID functionName: initialFunctionName arguments: initialArguments content: initialContent [

	self initialize.
	id := initialID.
	functionName := initialFunctionName.
	arguments := initialArguments.
	content := initialContent.
]

{ #category : 'openAI API' }
ChatPharoHistorySaverToolCall >> openAIChatToolCall [

	^ Dictionary
		with: 'type' -> 'function'
		with: 'id' -> id
		with: 'function' -> (Dictionary with: 'name' -> functionName with: 'arguments' -> arguments)
]

{ #category : 'openAI API' }
ChatPharoHistorySaverToolCall >> openAIChatToolMessage [

	^ Dictionary with: 'role' -> 'tool' with: 'tool_call_id' -> id with: 'content' -> content
]
