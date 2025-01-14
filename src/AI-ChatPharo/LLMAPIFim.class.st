"
### `LLMAPIFim` Class
Handles fim (Feature Integration Model) API requests.

- **`path`**: Specifies the endpoint for fim requests.
- **`payloadClass`**: Returns the class used for fim payloads.
- **`performRequest`**: Executes the fim API request.

"
Class {
	#name : 'LLMAPIFim',
	#superclass : 'LLMAPI',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
LLMAPIFim >> path [
	^ 'v1/fim/completions'
]

{ #category : 'accessing' }
LLMAPIFim >> payloadClass [

	^ LLMAPIFimObjectPayload
]

{ #category : 'accessing' }
LLMAPIFim >> performRequest [

	self prepareRequest.
	self client entity: (ZnEntity json:
			 (NeoJSONWriter toString: self content asJsonableObject)).
	^ self client post
]
