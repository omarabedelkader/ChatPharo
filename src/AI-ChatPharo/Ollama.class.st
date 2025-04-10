"
Killroy was here, but went away
"
Class {
	#name : 'Ollama',
	#superclass : 'Object',
	#instVars : [
		'model',
		'system',
		'promptPrefix',
		'response'
	],
	#category : 'AI-ChatPharo-Ullama',
	#package : 'AI-ChatPharo',
	#tag : 'Ullama'
}

{ #category : 'ollama models' }
Ollama class >> modelNames [
	"returns an array with one item per model."
	^ self models collect: [ :ollamaModel | ollamaModel at: 'name' ]
]

{ #category : 'ollama models' }
Ollama class >> models [
	"returns an array with one item per model. Each item has nested informations, and some arrays"
	| response  |

	response := ZnClient new get: 'http://localhost:11434/api/tags'.
	^ (STONJSON fromString: response) at: 'models'  .
]

{ #category : 'instance creation' }
Ollama class >> newSystem: synstemText promptPrefix: promptPrefixText [
	"Create and return an instance with predefined system and prompt prefix for Ollama queries."
	| prompter |
	prompter := self new.
	prompter system: synstemText.
	prompter promptPrefix: promptPrefixText.
	^ prompter 
]

{ #category : 'ollama models' }
Ollama class >> ollamaVersion [
	"Retrieve the Ollama version"
	| response  |
	
	response := ZnClient new get: 'http://localhost:11434/api/version'.
	^ (STONJSON fromString: response) at: 'version'  .
]

{ #category : 'ollama models' }
Ollama >> getOllamaModelInformation [
	"Show information about a model including details, modelfile, template, parameters, license, system prompt."
	"Check https://github.com/ollama/ollama/blob/main/docs/api.md#show-model-information for details"
	| url jsonResponse requestBody|
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
Ollama >> getOllamaVersion [
	"Retrieve the Ollama version"
	| url  |
	url := 'http://localhost:11434/api/version'.
	
	response := ZnClient new get: url.
	^ (STONJSON fromString: response) at: 'version'  .
]

{ #category : 'ollama models' }
Ollama >> getResponseForPrompt: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| url jsonResponse requestBody|
	url := 'http://localhost:11434/api/generate'.

	requestBody := STONJSON toString: { 
		#model -> model.
		#system -> system.
		#prompt -> (promptPrefix , ' ', prompt).
		#stream -> false.
	} asDictionary.
	jsonResponse := ZnClient new
	    url: url;
	    entity: (ZnEntity with: requestBody);
	    post;
	    contents.
	response := (STONJSON fromString: jsonResponse) at: 'response'.
	^ response contents.
]

{ #category : 'initialization' }
Ollama >> initialize [ 
	model := ''.
	system := ''.
	promptPrefix := ''.
]

{ #category : 'accessing' }
Ollama >> model [
	^ model
]

{ #category : 'accessing' }
Ollama >> model: aValue [
	model	:=	aValue.
]

{ #category : 'accessing' }
Ollama >> promptPrefix [
	^ promptPrefix .
]

{ #category : 'accessing' }
Ollama >> promptPrefix: aValue [
	promptPrefix	:=	aValue.
]

{ #category : 'accessing' }
Ollama >> response [
	^ response .
]

{ #category : 'accessing' }
Ollama >> response: aValue [
	response	 :=	aValue.
]

{ #category : 'accessing' }
Ollama >> system [
	^ system .
]

{ #category : 'accessing' }
Ollama >> system: aValue [
	system	 :=	aValue.
]
