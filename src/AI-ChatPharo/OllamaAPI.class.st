"
Killroy was here, but went away
"
Class {
	#name : 'OllamaAPI',
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
OllamaAPI class >> modelNames [
	"returns an array with one item per model."
	^ self models collect: [ :ollamaModel | ollamaModel at: 'name' ]
]

{ #category : 'ollama models' }
OllamaAPI class >> models [
	"returns an array with one item per model. Each item has nested informations, and some arrays"
	| response  |

	response := ZnClient new get: 'http://localhost:11434/api/tags'.
	^ (STONJSON fromString: response) at: 'models'  .
]

{ #category : 'instance creation' }
OllamaAPI class >> newSystem: synstemText promptPrefix: promptPrefixText [
	"Create and return an instance with predefined system and prompt prefix for Ollama queries."
	| prompter |
	prompter := self new.
	prompter system: synstemText.
	prompter promptPrefix: promptPrefixText.
	^ prompter 
]

{ #category : 'ollama models' }
OllamaAPI class >> ollamaVersion [
	"Retrieve the Ollama version"
	| response  |
	
	response := ZnClient new get: 'http://localhost:11434/api/version'.
	^ (STONJSON fromString: response) at: 'version'  .
]

{ #category : 'initialization' }
OllamaAPI >> initialize [ 
	super initialize.
	self model: (self class modelNames) first.
	system := ''.
	promptPrefix := ''.
]

{ #category : 'accessing' }
OllamaAPI >> model [

	^ model
]

{ #category : 'accessing' }
OllamaAPI >> model: anObject [

	model := anObject
]

{ #category : 'ollama models' }
OllamaAPI >> modelInformation [
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

{ #category : 'accessing' }
OllamaAPI >> promptPrefix [
	^ promptPrefix .
]

{ #category : 'accessing' }
OllamaAPI >> promptPrefix: aValue [
	promptPrefix	:=	aValue.
]

{ #category : 'accessing' }
OllamaAPI >> response [
	^ response .
]

{ #category : 'accessing' }
OllamaAPI >> response: aValue [
	response	 :=	aValue.
]

{ #category : 'accessing' }
OllamaAPI >> system [
	^ system .
]

{ #category : 'accessing' }
OllamaAPI >> system: aValue [
	system	 :=	aValue.
]
