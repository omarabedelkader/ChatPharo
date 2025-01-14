"
### `LLMAPI` Class
Base class for making API requests to language models.

- **`apiKey`**: Handles the API key for the service.
- **`chat`**: Returns a new instance for chat API interaction.
- **`fim`**: Returns a new instance for fim API interaction.
- **`host`**: Manages the API host setting.
- **`initialize`**: Sets up the HTTP client with API key and host.
- **`performRequest`**: Should be implemented by subclasses to perform specific API requests.
"
Class {
	#name : 'LLMAPI',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'client',
		'content',
		'apiKey'
	],
	#classInstVars : [
		'apiKey',
		'host'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
LLMAPI class >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
LLMAPI class >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'as yet unclassified' }
LLMAPI class >> chat [

	^ LLMAPIChat new
]

{ #category : 'as yet unclassified' }
LLMAPI class >> fim [

	^ LLMAPIFim new
]

{ #category : 'accessing' }
LLMAPI class >> host [

	^ host
]

{ #category : 'accessing' }
LLMAPI class >> host: anObject [

	host := anObject
]

{ #category : 'as yet unclassified' }
LLMAPI class >> llmSettingOn: aBuilder [

	<systemsettings>
	(aBuilder group: #ChatPharo)
		parent: #tools;
		name: 'ChatPharo';
		with: [
			(aBuilder setting: #apiKey)
				order: -100000;
				label: 'LLM API Key';
				target: self;
				default: '';
				ghostHelp: 'My key'.
			(aBuilder setting: #host)
				order: 0;
				label: 'LLM host';
				target: self;
				default: 'api.mistral.ai';
				ghostHelp: 'api.mistral.ai' ]
]

{ #category : 'accessing' }
LLMAPI >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
LLMAPI >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'accessing' }
LLMAPI >> client [

	^ client
]

{ #category : 'accessing' }
LLMAPI >> client: anObject [

	client := anObject
]

{ #category : 'accessing' }
LLMAPI >> content [

	^ content
]

{ #category : 'accessing' }
LLMAPI >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
LLMAPI >> host [

	^ host
]

{ #category : 'accessing' }
LLMAPI >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
LLMAPI >> initialize [

	super initialize.
	client := ZnClient new.
	self apiKey: self apiKey.
	self host: self  host.
]

{ #category : 'accessing' }
LLMAPI >> path [

	self subclassResponsibility
]

{ #category : 'accessing' }
LLMAPI >> payload [
	"return the content or a new class for this type of API"

	^ self content ifNil: [
		  self content: self payloadClass new.
		  self content ]
]

{ #category : 'accessing' }
LLMAPI >> payloadClass [
	"return the class of the main  LLMAPIObject that one should use with this API. This API helps to prevent some bugs or usage issue"

	^ self subclassResponsibility
]

{ #category : 'api' }
LLMAPI >> performRequest [
	self subclassResponsibility
]

{ #category : 'accessing' }
LLMAPI >> port [

	^ port
]

{ #category : 'accessing' }
LLMAPI >> port: anObject [

	port := anObject
]

{ #category : 'accessing' }
LLMAPI >> prepareRequest [

	self apiKey ifNotNil: [ :_apiKey |
		client setBearerAuthentication: _apiKey ].
	client forJsonREST.
	client https.
	client host: self host.
	client path: self path
]
