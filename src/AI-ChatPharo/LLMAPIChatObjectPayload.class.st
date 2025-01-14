"
### `LLMAPIChatObjectPayload` Class
Encapsulates the payload for a chat request.

- **`asJsonableObject`**: Converts the payload to a JSON-compatible object, including parameters like model, temperature, etc.
"
Class {
	#name : 'LLMAPIChatObjectPayload',
	#superclass : 'LLMAPIObject',
	#instVars : [
		'model',
		'temperature',
		'top_p',
		'max_tokens',
		'stream',
		'stop',
		'random_seed',
		'messages',
		'response_format',
		'tools',
		'tool_choice',
		'presence_penalty',
		'frequence_penalty',
		'n',
		'safe_prompt'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> asJsonableObject [

	| dic |
	dic := Dictionary new.
	self messages ifNotNil: [ :_messages |
		dic
			at: #messages
			put: (_messages collect: [ :message | message asJsonableObject ]) ].
	self temperature ifNotNil: [ :v | dic at: #temperature put: v ].
	self top_p ifNotNil: [ :v | dic at: #top_p put: v ].
	self model ifNotNil: [ :v | dic at: #model put: v ].
	self max_tokens ifNotNil: [ :v | dic at: #max_tokens put: v ].
	^ dic
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> frequence_penalty [

	^ frequence_penalty
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> frequence_penalty: anObject [

	frequence_penalty := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> max_tokens [

	^ max_tokens
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> max_tokens: anObject [

	max_tokens := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> messages [

	^ messages
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> messages: anObject [

	messages := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> model [

	^ model
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> n [

	^ n
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> n: anObject [

	n := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> presence_penalty [

	^ presence_penalty
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> presence_penalty: anObject [

	presence_penalty := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> random_seed [

	^ random_seed
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> random_seed: anObject [

	random_seed := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> response_format [

	^ response_format
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> response_format: anObject [

	response_format := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> safe_prompt [

	^ safe_prompt
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> safe_prompt: anObject [

	safe_prompt := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> stop [

	^ stop
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> stop: anObject [

	stop := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> stream [

	^ stream
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> stream: anObject [

	stream := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> temperature [

	^ temperature
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> temperature: anObject [

	temperature := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> tool_choice [

	^ tool_choice
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> tool_choice: anObject [

	tool_choice := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> tools [

	^ tools
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> tools: anObject [

	tools := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> top_p [

	^ top_p
]

{ #category : 'accessing' }
LLMAPIChatObjectPayload >> top_p: anObject [

	top_p := anObject
]
