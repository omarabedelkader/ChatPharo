"
I contain the code needed to select one of the ollama models in on your computer.
I should be made a SpPresenter subclass (as the other aspects)
"
Class {
	#name : 'OllamaApiChat',
	#superclass : 'OllamaApi',
	#instVars : [
		'messages'
	],
	#category : 'AI-ChatPharo-Ollama',
	#package : 'AI-ChatPharo',
	#tag : 'Ollama'
}

{ #category : 'ollama models' }
OllamaApiChat >> addRole: roleType content: contentString [
	|res|
	res := OrderedDictionary newFrom: { 
		#role -> roleType.
		#content -> contentString
	}.
	self messages add: res.
]

{ #category : 'ollama models' }
OllamaApiChat >> getResponseForPrompt: prompt [
	"Sends a prompt to an API, receives JSON response, and extracts the 'response' value"
	| url messageString jsonResponse requestDictionary requestBody response|
	url := 'http://localhost:11434/api/chat'.
	self messages add: (self role: 'user' content: prompt ).
	messageString := self messages collect: [:item | STONJSON toString: item].
	self halt.
	requestDictionary := Dictionary newFrom:  { 
		#model -> model.
		#messages -> (STONJSON toString: self messages)
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

{ #category : 'initialization' }
OllamaApiChat >> initialize [ 
	super initialize.
	
	self messages: OrderedCollection new.
]

{ #category : 'accessing' }
OllamaApiChat >> messages [

	^ messages
]

{ #category : 'accessing' }
OllamaApiChat >> messages: anObject [

	messages := anObject
]

{ #category : 'ollama models' }
OllamaApiChat >> messagesAdd: content for: role [
	"Add the role and content to the messages. And return the JSON result of it"
	| messageString requestDictionary|
	self messages add: (self role: role content: content ).
	messageString := self messages collect: [:item | STONJSON toString: item].
	requestDictionary := Dictionary newFrom:  { 
		#model -> model.
		#messages -> (STONJSON toString: self messages)
	} .
	^ STONJSON toString: requestDictionary 
]

{ #category : 'ollama models' }
OllamaApiChat >> messagesInJSON [
	"Add the role and content to the messages. And return the JSON result of it"
	| messageString requestDictionary|
	messages size = 0 ifTrue: [ ^ STONJSON toString: { } ].
	messageString := self messages collect: [:item | 
		self halt.
		item first.
		STONJSON toString: item associations ].
	requestDictionary := Dictionary newFrom:  { 
		#model -> model.
		#messages -> (STONJSON toString: self messages)
	} .
	^ STONJSON toString: requestDictionary 
]
