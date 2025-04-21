"
For each aspect of History, I store role and content.
"
Class {
	#name : 'ChatPharoHistorySaver',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content',
		'toolCalls'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'instance creation' }
ChatPharoHistorySaver class >> role: aRole content: aContent [

	^ self role: aRole content: aContent toolCalls: nil
]

{ #category : 'instance creation' }
ChatPharoHistorySaver class >> role: role content: content toolCalls: toolCalls [

	^ self new
		role: role;
		content: content;
		toolCalls: toolCalls;
		yourself
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content [

	^ content
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content: anObject [

	content := anObject
]

{ #category : 'ollama models' }
ChatPharoHistorySaver >> historyStringOn: stream [
	"I return a role content string"
	stream 
		nextPutAll: role;
		nextPutAll: ': ';
		nextPutAll: content;
		nextPutAll: String cr.
]

{ #category : 'openAI API' }
ChatPharoHistorySaver >> putOpenAIChatMessagesOn: stream [

	| message |

	message := Dictionary with: 'role' -> role.
	content ifNotNil: [
		message add: 'content' -> content ].
	toolCalls ifNotNil: [
		message add: 'tool_calls' -> (toolCalls collect: [ :toolCall | toolCall openAIChatToolCall ] as: Array) ].
	stream nextPut: message.
	toolCalls ifNotNil: [
		toolCalls do: [ :toolCall |
			stream nextPut: toolCall openAIChatToolMessage ] ].
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role [

	^ role
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role: anObject [

	role := anObject
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> toolCalls [

	^ toolCalls
]

{ #category : 'accessing' }
ChatPharoHistorySaver >> toolCalls: newToolCalls [

	toolCalls := newToolCalls
]

{ #category : 'displaying' }
ChatPharoHistorySaver >> toolCallsDisplay [

	^ toolCalls ifNotNil: [
		'(tools called: {1})' format: { ', ' join: (toolCalls collect: [ :toolCall | toolCall functionName ]) } ]
]
