"
### `ChatPharoSpecChat` Class
Handles the specific chat functionalities in the application.

- **`askLLM`**: Sends the chat input to a remote language model and processes the response.
- **`askLocalModel`**: Handles the communication with a local language model to get responses.
- **`defaultLayout`**: Sets up the layout for the chat interface including the history and input field.
- **`initializePresenters`**: Sets up the chat interface components like the input field and submit button.
"
Class {
	#name : 'ChatPharoSpecChat',
	#superclass : 'SpPresenter',
	#instVars : [
		'history',
		'inputField',
		'submitButton'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'initialization' }
ChatPharoSpecChat >> askLLM [

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

{ #category : 'initialization' }
ChatPharoSpecChat >> askLocalModel [

    | ollama result |
    history addMessage: (LLMAPIChatObjectMessage
                            role: 'user'
                            content: inputField text).
    ollama := OllamaAPI new.
    ollama host: '127.0.0.1'.
    ollama port: 11434.
    ollama stream: false.
    result := ollama query: inputField text.
    history addMessage: (LLMAPIChatObjectMessage
                            role: 'ChatPharo'
                            content: result).
    inputField text: ''
]

{ #category : 'layout' }
ChatPharoSpecChat >> defaultLayout [

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

{ #category : 'accessing' }
ChatPharoSpecChat >> history [

	^ history
]

{ #category : 'accessing' }
ChatPharoSpecChat >> history: anObject [

	history := anObject
]

{ #category : 'initialization' }
ChatPharoSpecChat >> initializePresenters [

    submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        help: 'Submit prompt to LLM';
        action: [ self askLocalModel ];  " <— here we wire it to askLocalModel "
        yourself.
 
    inputField := self newTextInput
			placeholder: 'Type your message here...'; 
			yourself.
			
    inputField whenSubmitDo: [ :text | self askLocalModel ].

    history := ChatPharoSpecChatHistory from: OrderedCollection new
]

{ #category : 'accessing' }
ChatPharoSpecChat >> inputField [

	^ inputField
]

{ #category : 'accessing' }
ChatPharoSpecChat >> inputField: anObject [

	inputField := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChat >> submitButton [

	^ submitButton
]

{ #category : 'accessing' }
ChatPharoSpecChat >> submitButton: anObject [

	submitButton := anObject
]
