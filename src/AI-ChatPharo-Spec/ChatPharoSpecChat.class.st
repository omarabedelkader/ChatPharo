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
		'clearButton'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'initialization' }
ChatPharoSpecChat >> askLLM [
	"This method sends a chat request to the Mistral API, processes the response, updates the chat history, and clears the input field."

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
	"This method sends a user's input to an Ollama API and updates the chat history with the response."

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
ChatPharoSpecChat >> submitButton [
	"Returns the submit button instance variable."

	^ submitButton
]

{ #category : 'accessing' }
ChatPharoSpecChat >> submitButton: anObject [
	"Sets the submit button to the specified object."

	submitButton := anObject
]
