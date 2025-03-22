"### `ChatPharoSpecChat` Class
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
		'submitButton',
		'clearButton'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'initialization' }
ChatPharoSpecChat >> askLLM [

	| api result resultContent timestamp |
	timestamp := DateAndTime now asString.

	history widget addMessage:
		(LLMAPIChatObjectMessage role: 'user' content: inputField text timestamp: timestamp).

	api := LLMAPI chat.
	api host: 'api.mistral.ai'.
	api payload
		temperature: 0.5;
		model: 'mistral-small-latest';
		top_p: 1;
		max_tokens: 250;
		messages: history widget model.

	result := api performRequest.
	resultContent := result choices anyOne message content.
	timestamp := DateAndTime now asString.

	history widget addMessage:
		(LLMAPIChatObjectMessage role: 'assistant' content: resultContent timestamp: timestamp).

	inputField text: ''.
	history widget scrollToBottom.
]

{ #category : 'initialization' }
ChatPharoSpecChat >> askLocalModel [

    | ollama result timestamp |
    timestamp := DateAndTime now asString.

    history widget addMessage: (LLMAPIChatObjectMessage
                            role: 'user'
                            content: inputField text
                            timestamp: timestamp).

    ollama := OllamaAPI new.
    ollama host: '127.0.0.1'.
    ollama port: 11434.
    ollama stream: false.
    result := ollama query: inputField text.

    timestamp := DateAndTime now asString.

    history widget addMessage: (LLMAPIChatObjectMessage
                            role: 'ChatPharo'
                            content: result
                            timestamp: timestamp).

    inputField text: ''.
    history widget scrollToBottom.
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

{ #category : 'actions' }
ChatPharoSpecChat >> clearChat [
	 history widget clear. 
]

{ #category : 'initialization' }
ChatPharoSpecChat >> initializePresenters [

    history := SpBoxLayout newTopToBottom.
    history widget: (ChatPharoSpecChatHistory from: OrderedCollection new).
	
	submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        help: 'Submit prompt to LLM';
        action: [ self askLocalModel ];
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

{ #category : 'accessing' }
ChatPharoSpecChat >> clearButton [
	
	^ clearButton 
]

{ #category : 'accessing' }
ChatPharoSpecChat >> clearButton: anObject [
	
	clearButton := anObject 
]
