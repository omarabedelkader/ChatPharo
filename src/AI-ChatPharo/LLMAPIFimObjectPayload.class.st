"
### `LLMAPIFimObjectPayload` Class
Defines the payload for fim requests.

- **`asJsonableObject`**: Converts the fim payload to a JSON-compatible object.
"
Class {
	#name : 'LLMAPIFimObjectPayload',
	#superclass : 'LLMAPIObject',
	#instVars : [
		'model',
		'temperature',
		'top_p',
		'max_tokens',
		'stream',
		'stop',
		'random_seed',
		'prompt',
		'suffix',
		'min_tokenss'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> asJsonableObject [

	| dic |
	dic := Dictionary new.
	self temperature ifNotNil: [ :v | dic at: #temperature put: v ].
	self top_p ifNotNil: [ :v | dic at: #top_p put: v ].
	self model ifNotNil: [ :v | dic at: #model put: v ].
	self prompt ifNotNil: [ :v | dic at: #prompt put: v ].
	self max_tokens ifNotNil: [ :v | dic at: #max_tokens put: v ].
	^ dic
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> max_tokens [

	^ max_tokens
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> max_tokens: anObject [

	max_tokens := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> min_tokenss [

	^ min_tokenss
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> min_tokenss: anObject [

	min_tokenss := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> model [

	^ model
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> prompt [

	^ prompt
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> prompt: anObject [

	prompt := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> random_seed [

	^ random_seed
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> random_seed: anObject [

	random_seed := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> stop [

	^ stop
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> stop: anObject [

	stop := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> stream [

	^ stream
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> stream: anObject [

	stream := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> suffix [

	^ suffix
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> suffix: anObject [

	suffix := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> temperature [

	^ temperature
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> temperature: anObject [

	temperature := anObject
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> top_p [

	^ top_p
]

{ #category : 'accessing' }
LLMAPIFimObjectPayload >> top_p: anObject [

	top_p := anObject
]
