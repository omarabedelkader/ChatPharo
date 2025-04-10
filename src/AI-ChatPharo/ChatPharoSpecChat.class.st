"
### `ChatPharoSpecChat` Class
Handles the specific chat functionalities in the application.

- **`askLLM`**: Sends the chat input to a remote language model and processes the response.
- **`askLocalModel`**: Handles the communication with a local language model to get responses.
- **`defaultLayout`**: Sets up the layout for the chat interface including the history and input field.
- **`initializePresenters`**: Sets up the chat interface components like the input field and submit button.





## Instance variables (AI generated comments)
**history** : Stores chat messages for history display
**inputField** : Input field for user messages in chat application
**submitButton** : Submits user input to the language model
**clearButton** : ```
Button to clear chat history
```
-----


"
Class {
	#name : 'ChatPharoSpecChat',
	#superclass : 'SpPresenter',
	#instVars : [
		'history',
		'inputField',
		'submitButton',
		'cancelButton',
		'clearButton',
		'ollamaModel',
		'ollamaProcess'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'initialization' }
ChatPharoSpecChat >> askLocalModel [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

	| result |
	history addMessage: (ChatPharoHistorySaver
                            role: 'user'
                            content: inputField text).
	ollamaProcess := [ 
			result := ollamaModel getResponseForPrompt:inputField text.
			history addMessage: (ChatPharoHistorySaver
                            role: 'ChatPharo'
                            content: result).
		] fork.
	inputField text: ''
]

{ #category : 'initialization' }
ChatPharoSpecChat >> askLocalModel_new [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

	| result |
	history addMessage: (ChatPharoHistorySaver
                            role: 'user'
                            content: inputField text).
	ollamaProcess := [ 
			result := ollamaModel getResponseForPrompt:inputField text.
			history addMessage: (ChatPharoHistorySaver
                            role: 'ChatPharo'
                            content: result).
		] fork.
	inputField text: ''
]

{ #category : 'initialization' }
ChatPharoSpecChat >> askLocalModel_old [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

    | result |
    history addMessage: (ChatPharoHistorySaver
                            role: 'user'
                            content: inputField text).
	 result := ollamaModel getResponseForPrompt:inputField text.
    history addMessage: (ChatPharoHistorySaver
                            role: 'ChatPharo'
                            content: result).
    inputField text: ''
]

{ #category : 'initialization' }
ChatPharoSpecChat >> cancelOllamaPrompt [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

	|  |
	ollamaProcess terminate.
	history addMessage: (ChatPharoHistorySaver
                            role: 'ChatPharo'
                            content: 'Canceled').
	inputField text: ''
]

{ #category : 'accessing' }
ChatPharoSpecChat >> clearButton [
	"Returns the clear button instance."

	^ clearButton
]

{ #category : 'accessing' }
ChatPharoSpecChat >> clearButton: anObject [
	"Sets `clearButton` to the provided object."

	clearButton := anObject
]

{ #category : 'actions' }
ChatPharoSpecChat >> clearChat [
	"Resets chat history by clearing it."

    history clear.
]

{ #category : 'layout' }
ChatPharoSpecChat >> defaultLayout [
	"Creates a vertical layout with history above a horizontal row containing input field and submit button."

	| submitRow |
	submitRow := SpBoxLayout newLeftToRight
		add: inputField;
		spacing: 5;
		add: submitButton withConstraints: [ :constraints |
             constraints height: 27.
             constraints width: 70 ];
		add: cancelButton withConstraints: [ :constraints |
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
	"Returns the history object."

	^ history
]

{ #category : 'accessing' }
ChatPharoSpecChat >> history: anObject [
	"Stores the provided object as the current history."

	history := anObject
]

{ #category : 'initialization' }
ChatPharoSpecChat >> initializePresenters [

   history := ChatPharoSpecChatHistory from: OrderedCollection new.
	 
   inputField := self newTextInput
			placeholder: 'Type your message here...';
			yourself.
			
   inputField whenSubmitDo: [ :text | self askLocalModel ].

	submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        help: 'Submit prompt to Ollama model';
        action: [ self askLocalModel ];  
        yourself.

	cancelButton := self newButton
        label: 'Cancel';
        icon: (self iconNamed: #delete);
        help: 'Cancel prompt to Ollama model';
        action: [ self cancelOllamaPrompt ];  
        yourself.

	clearButton := self newButton
        label: 'Clear Chat';
        icon: (self iconNamed: #glamorousTrash);
        help: 'Clear chat history';
        action: [ self clearChat ];
        yourself.
]

{ #category : 'accessing' }
ChatPharoSpecChat >> inputField [
	"Returns the input field."

	^ inputField
]

{ #category : 'accessing' }
ChatPharoSpecChat >> inputField: anObject [
	"Assigns an object to the instance variable inputField."

	inputField := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChat >> ollamaModel [
	^ ollamaModel 
]

{ #category : 'accessing' }
ChatPharoSpecChat >> ollamaModel: model [
	ollamaModel := model
]

{ #category : 'accessing' }
ChatPharoSpecChat >> submitButton [
	"Returns the submit button instance variable."

	^ submitButton
]

{ #category : 'accessing' }
ChatPharoSpecChat >> submitButton: anObject [
	"Sets the submit button to the specified object."

	submitButton := anObject
]
