"
I contain the code needed to select one of the ollama models in on your computer.
I should be made a SpPresenter subclass (as the other aspects)
"
Class {
	#name : 'OllamaApiChat',
	#superclass : 'OllamaAPI',
	#category : 'AI-ChatPharo-Ullama',
	#package : 'AI-ChatPharo',
	#tag : 'Ullama'
}

{ #category : 'as yet unclassified' }
OllamaApiChat >> fibbe [
	^ 'messages' -> {
    {
      'role' -> 'user'.
      'content' -> 'why is the sky blue?'
    }
  }
]

{ #category : 'ollama models' }
OllamaApiChat >> getResponseForPrompt: prompt [
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

{ #category : 'ollama models' }
OllamaApiChat >> getResponseForPrompt_old: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| url jsonResponse requestBody|
	url := 'http://localhost:11434/api/chat'.

	requestBody := STONJSON toString: { 
		#model -> model.
		#system -> system.
		#messages -> (self role: 'user' content: ("promptPrefix , ' ', "prompt)).
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

{ #category : 'as yet unclassified' }
OllamaApiChat >> role: roleType content: contentString [
	|res|
		res := { {
			#role -> roleType.
			#content -> contentString
		}} .
	^res
]
