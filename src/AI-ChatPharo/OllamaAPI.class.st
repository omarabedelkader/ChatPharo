"
Killroy was here, but went away
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
OllamaApi >> getResponseForPrompt: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| apiGenerateUrl jsonResponse requestDictionary requestBody|
	apiGenerateUrl := 'http://localhost:11434/api/generate'.
	requestDictionary := Dictionary newFrom:  { 
		#model -> model.
		#system -> self system.
		#prompt -> (self promptPrefix , ' ', prompt).
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
