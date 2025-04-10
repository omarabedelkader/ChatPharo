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
OllamaAPI >> getOllamaModelInformation [
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
OllamaAPI >> getResponseForPrompt: prompt [
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
OllamaAPI >> initialize [ 
	model := ''.
	system := ''.
	promptPrefix := ''.
]

{ #category : 'accessing' }
OllamaAPI >> model [
	^ model
]

{ #category : 'accessing' }
OllamaAPI >> model: aValue [
	model	:=	aValue.
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
