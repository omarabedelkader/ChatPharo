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
		'spParent',
		'history',
		'inputField',
		'submitButton',
		'cancelButton',
		'clearButton',
		'ollamaProcess'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChat class >> newWithParent: spPresenter [
	"Create an instance of me, with spPresenter as spParent"
	| specChat |
	specChat := self basicNew.
	specChat spParent: spPresenter.
	specChat initialize.
	^ specChat 
]

{ #category : 'actions' }
ChatPharoSpecChat >> askLocalModel [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

	| result |
	history addMessage: (ChatPharoHistorySaver
                            role: 'user'
                            content: inputField text).
	ollamaProcess := [
			inputField text: '(ollama model running)'.
			self ollamaModel promptPrefix: history asPromptPrefix.
			result := self ollamaModel getResponseForPrompt: nil.
			inputField text: ''.
			history addMessage: (ChatPharoHistorySaver
                            role: 'assistant'
                            content: result).
		] fork.
]

{ #category : 'actions' }
ChatPharoSpecChat >> cancelOllamaPrompt [
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

	ollamaProcess ifNotNil: [ollamaProcess terminate].
	history addMessage: (ChatPharoHistorySaver
                            role: 'assistant'
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
   history := ChatPharoSpecChatHistory from: OrderedCollection new parent: self spParent .
	 
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
	^ spParent ollamaModel 
]

{ #category : 'accessing' }
ChatPharoSpecChat >> ollamaProcess [

	^ ollamaProcess
]

{ #category : 'accessing' }
ChatPharoSpecChat >> ollamaProcess: anObject [

	ollamaProcess := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChat >> spParent [
	^ spParent 
]

{ #category : 'accessing' }
ChatPharoSpecChat >> spParent: spPresenter [
	spParent := spPresenter
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
