"
### `OllamaAPI` Class
Handles interactions with a hypothetical Ollama API server.

- **`query:`**: Sends a query to the Ollama API and returns the response.
- **`initialize`**: Sets default values and initializes the API instance.
- **`list`**: Lists available models on the Ollama server.
- **`delete`**: Deletes a model from the Ollama server.
"
Class {
	#name : 'OllamaApi',
	#superclass : 'Object',
	#instVars : [
		'model',
		'system',
		'promptPrefix',
		'response'
	],
	#category : 'AI-ChatPharo-Ollama',
	#package : 'AI-ChatPharo',
	#tag : 'Ollama'
}

{ #category : 'ollama models' }
OllamaApi class >> modelNames [
	"returns an array with one item per model."
	^ self models collect: [ :ollamaModel | ollamaModel at: 'name' ]
]

{ #category : 'ollama models' }
OllamaApi class >> models [
	"returns an array with one item per model. Each item has nested informations, and some arrays"
	| response  |

	response := ZnClient new get: 'http://localhost:11434/api/tags'.
	^ (STONJSON fromString: response) at: 'models'  .
]

{ #category : 'instance creation' }
OllamaApi class >> newSystem: synstemText promptPrefix: promptPrefixText [
	"Create and return an instance with predefined system and prompt prefix for Ollama queries."
	| prompter |
	prompter := self new.
	prompter system: synstemText.
	prompter promptPrefix: promptPrefixText.
	^ prompter 
]

{ #category : 'ollama models' }
OllamaApi class >> ollamaVersion [
	"Retrieve the Ollama version"
	| response  |
	
	response := ZnClient new get: 'http://localhost:11434/api/version'.
	^ (STONJSON fromString: response) at: 'version'  .
]

{ #category : 'ollama models' }
OllamaApi >> getStreamedResponseForPrompt: prompt [
	"Sends a prompt and receives tokens streamed line by line"
	| apiGenerateUrl requestBody responseStream resultBuffer |
	apiGenerateUrl := 'http://localhost:11434/api/generate'.
	requestBody := STONJSON toString: {
		#model -> model.
		#system -> self system.
		#prompt -> (self promptPrefix , ' ', prompt).
		#stream -> true.
		#options -> (Dictionary newFrom: {
			#temperature -> 0.7 })
	} asDictionary.

	resultBuffer := ''.
	responseStream := ZnClient new
		url: apiGenerateUrl;
		entity: (ZnEntity with: requestBody);
		headerAt: 'Accept' put: 'text/event-stream';
		post;
		stream.

	[responseStream atEnd] whileFalse: [
		| line parsed token |
		line := responseStream nextLine.
		(line isEmpty or: [ line beginsWith: 'data: null' ]) ifFalse: [
			parsed := STONJSON fromString: (line copyAfter: 'data: ').
			token := parsed at: 'response' ifAbsent: [''].
			Transcript show: token; flush.
			resultBuffer := resultBuffer , token.
		].
	].

	response := resultBuffer.
	^ resultBuffer.
]

{ #category : 'initialization' }
OllamaApi >> initialize [ 
	super initialize.
	self model: (self class modelNames) first.
	self system: ''.
	self promptPrefix: ''.
]

{ #category : 'accessing' }
OllamaApi >> model [

	^ model
]

{ #category : 'accessing' }
OllamaApi >> model: anObject [

	model := anObject
]

{ #category : 'ollama models' }
OllamaApi >> modelInformation [
	"Show information about a model including details, modelfile, template, parameters, license, system prompt."
	"Check https://github.com/ollama/ollama/blob/main/docs/api.md#show-model-information for details"
	| url jsonResponse requestBody  response|
	url := 'http://localhost:11434/api/show'.

	requestBody := STONJSON toString: { 
		#model -> model.
	} asDictionary.
	jsonResponse := ZnClient new
	    url: url;
	    entity: (ZnEntity with: requestBody);
	    post;
	    contents.
	response := (STONJSON fromString: jsonResponse).
	^ response contents.
]

{ #category : 'ollama models' }
OllamaApi class >> ensureModelDownloaded: modelName [
	| installedModels response |
	installedModels := self modelNames.
	(installedModels includes: modelName) ifFalse: [
		"Call /api/pull"
		response := ZnClient new
			url: 'http://localhost:11434/api/pull';
			entity: (ZnEntity with: (STONJSON toString: { #name -> modelName } asDictionary));
			post;
			contents.
		Transcript show: 'Model "', modelName, '" downloaded.'; cr.
	].
]

{ #category : 'ollama models' }
OllamaApi >> useModelNamed: modelName [
	(self class modelNames includes: modelName)
		ifTrue: [ self model: modelName ]
		ifFalse: [
			Transcript show: 'Model "', modelName, '" not found. Attempting download...'; cr.
			self class ensureModelDownloaded: modelName.
			self model: modelName.
		].
]

{ #category : 'instance creation' }
OllamaApi class >> withDefaultModel [
	| instance |
	instance := self new.
	instance model: (self modelNames ifEmpty: [ self error: 'No models available' ]) first.
	^ instance
]

{ #category : 'accessing' }
OllamaApi >> promptPrefix [

	^ promptPrefix
]

{ #category : 'accessing' }
OllamaApi >> promptPrefix: anObject [

	promptPrefix := anObject
]

{ #category : 'accessing' }
OllamaApi >> response [

	^ response
]

{ #category : 'accessing' }
OllamaApi >> response: anObject [

	response := anObject
]

{ #category : 'accessing' }
OllamaApi >> system [

	^ system
]

{ #category : 'accessing' }
OllamaApi >> system: anObject [

	system := anObject
]
