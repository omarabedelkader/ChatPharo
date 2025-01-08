Class {
	#name : 'LLMAPISpecChat',
	#superclass : 'SpPresenter',
	#instVars : [
		'history',
		'inputField',
		'submitButton'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'initialization' }
LLMAPISpecChat >> askLLM [

	| api result resultContent |
	history addMessage:
		(LLMAPIChatObjectMessage role: 'user' content: inputField text).
	api := LLMAPI chat.
	api host: 'api.mistral.ai'.
	api payload
		temperature: 0.5;
		model: 'mistral-small-latest';
		top_p: 1;
		max_tokens: 250;
		messages: history model.

	result := api performRequest.
	resultContent := result choices anyOne message content.
	history addMessage:
		(LLMAPIChatObjectMessage role: 'assistant' content: resultContent).

	inputField text: ''
]

{ #category : 'layout' }
LLMAPISpecChat >> defaultLayout [

	| submitRow |
	submitRow := SpBoxLayout newLeftToRight
		             add: inputField;
		             spacing: 5;
		             add: submitButton withConstraints: [ :constraints |
			             constraints height: 27.
			             constraints width: 70 ];
		             yourself.

	^ SpBoxLayout newTopToBottom
		  add: history;
		  spacing: 5;
		  add: submitRow expand: false;
		  yourself
]

{ #category : 'initialization' }
LLMAPISpecChat >> initializePresenters [

	submitButton := self newButton
		                label: 'Submit';
		                icon: (self iconNamed: #glamorousGo);
		                help: 'Submit prompt to LLM';
		                action: [ self askLLM ];
		                yourself.

	inputField := self newTextInput.
	inputField whenSubmitDo: [ :text | self askLLM ].
	history := LLMAPISpecChatHistory from: OrderedCollection new
]
