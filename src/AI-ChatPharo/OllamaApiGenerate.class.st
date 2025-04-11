"
I am intended to implement the api/generate ollama api

See ""https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion""
"
Class {
	#name : 'OllamaApiGenerate',
	#superclass : 'OllamaAPI',
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
		#system -> system.
		#prompt -> (promptPrefix , ' ', prompt).
		#stream -> false.
	} .
	requestBody := (STONJSON toString: requestDictionary).
	jsonResponse := ZnClient new
	    url: url;
	    entity: (ZnEntity with: requestBody);
	    post;
	    contents.
	response := (STONJSON fromString: jsonResponse) at: 'response'.
	^ response contents.
]
