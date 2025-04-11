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

{ #category : 'layout' }
OllamaApiChat >> ollamaModelSelect_old [
	"Add to ChatPharo a select ollama model"
self halt.
	^ SpDropListPresenter new
			help: 'Select ollama model';
			items: OllamaAPI modelNames;
			display: [ :e | e  ];
			whenSelectedItemChangedDo: [ :e | self model: e];
			yourself
		
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
