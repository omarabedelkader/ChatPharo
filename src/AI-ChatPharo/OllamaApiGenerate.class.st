"
I am intended to implement the api/generate ollama api

See ""https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion""
"
Class {
	#name : 'OllamaApiGenerate',
	#superclass : 'OllamaApi',
	#instVars : [
		'system',
		'promptPrefix',
		'response'
	],
	#category : 'AI-ChatPharo-Ullama',
	#package : 'AI-ChatPharo',
	#tag : 'Ullama'
}

{ #category : 'ollama models' }
OllamaApiGenerate >> getResponseForPrompt: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| url jsonResponse requestDictionary requestBody|
	url := 'http://localhost:11434/api/generate'.
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
	    url: url;
	    entity: (ZnEntity with: requestBody);
	    post;
	    contents.
	self response: ((STONJSON fromString: jsonResponse) at: 'response').
	^ self response contents.
]

{ #category : 'initialization' }
OllamaApiGenerate >> initialize [ 
	super initialize.
	
	self system: ''.
	self promptPrefix: ''.
]

{ #category : 'accessing' }
OllamaApiGenerate >> promptPrefix [

	^ promptPrefix
]

{ #category : 'accessing' }
OllamaApiGenerate >> promptPrefix: anObject [

	promptPrefix := anObject
]

{ #category : 'accessing' }
OllamaApiGenerate >> response [

	^ response
]

{ #category : 'accessing' }
OllamaApiGenerate >> response: anObject [

	response := anObject
]

{ #category : 'accessing' }
OllamaApiGenerate >> system [

	^ system
]

{ #category : 'accessing' }
OllamaApiGenerate >> system: anObject [

	system := anObject
]
