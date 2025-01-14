"
### `LLMAPIChat` Class
Specific implementation for making chat API requests.

- **`path`**: Returns the endpoint path for chat requests.
- **`payloadClass`**: Specifies the payload class for chat.
- **`performRequest`**: Prepares and performs a POST request for chat.
"
Class {
	#name : 'LLMAPIChat',
	#superclass : 'LLMAPI',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
LLMAPIChat >> path [
	^ 'v1/chat/completions'
]

{ #category : 'accessing' }
LLMAPIChat >> payloadClass [

	^ LLMAPIChatObjectPayload
]

{ #category : 'accessing' }
LLMAPIChat >> performRequest [

	self prepareRequest.
	self client entity: (ZnEntity json:
			 (NeoJSONWriter toString: self content asJsonableObject)).
	^ self client post
]
