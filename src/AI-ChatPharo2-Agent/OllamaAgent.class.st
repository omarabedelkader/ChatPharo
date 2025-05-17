Class {
	#name : 'OllamaAgent',
	#superclass : 'Agent',
	#category : 'AI-ChatPharo2-Agent',
	#package : 'AI-ChatPharo2-Agent'
}

{ #category : 'api' }
OllamaAgent class >> displayName [

	^ 'Ollama'
]

{ #category : 'api' }
OllamaAgent class >> isReachable [

	[ self ollamaVersion ] on: NetworkError do: [ ^ false ].

	^ true
]

{ #category : 'api' }
OllamaAgent class >> modelNames [
	"returns an array with one item per model."
	^ self models collect: [ :ollamaModel | ollamaModel at: 'name' ]
]

{ #category : 'api' }
OllamaAgent class >> models [
	"returns an array with one item per model. Each item has nested informations, and some arrays"
	| response  |
	
	self isReachable ifFalse: [ ^ OrderedCollection empty ].
	response := ZnClient new get: 'http://localhost:11434/api/tags'.
	^ (STONJSON fromString: response) at: 'models'
]

{ #category : 'api' }
OllamaAgent class >> newSystem: synstemText promptPrefix: promptPrefixText [
	"Create and return an instance with predefined system and prompt prefix for Ollama queries."
	| prompter |
	prompter := self new.
	prompter system: synstemText.
	prompter promptPrefix: promptPrefixText.
	^ prompter 
]

{ #category : 'api' }
OllamaAgent class >> ollamaVersion [
	"Retrieve the Ollama version"
	| response  |
	
	response := ZnClient new get: 'http://localhost:11434/api/version'.
	^ (STONJSON fromString: response) at: 'version'
]

{ #category : 'api' }
OllamaAgent class >> settingsPresenterFor: anAgent [
	^ OllamaSettingsPresenter on: anAgent
]

{ #category : 'initialization' }
OllamaAgent >> getResponseForPrompt: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| apiGenerateUrl jsonResponse requestDictionary requestBody|
	apiGenerateUrl := 'http://localhost:11434/api/generate'.
	requestDictionary := Dictionary newFrom:  { 
		#model -> model.
		#system -> self system.
		#prompt -> (String streamContents: [ :stream |
			stream nextPutAll: self promptPrefix.
			prompt ifNotNil: [ stream nextPutAll: ' '; nextPutAll: prompt ] ]).
		#stream -> false.
		#options -> (Dictionary newFrom: {
    		#temperature -> 0})
	} .
	requestBody := (STONJSON toString: requestDictionary).
	jsonResponse := ZnClient new
	    url: apiGenerateUrl;
	    entity: (ZnEntity with: requestBody);
	    post;
	    contents.
	self response: ((STONJSON fromString: jsonResponse) at: 'response').
	^ self response contents.
]

{ #category : 'initialization' }
OllamaAgent >> initialize [ 

	super initialize.
	self model: nil.
	self system: ''.
	self promptPrefix: ''.
]

{ #category : 'initialization' }
OllamaAgent >> modelInformation [
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

{ #category : 'api' }
OllamaAgent >> modelNames [

	^ self class modelNames
]
