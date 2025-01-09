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
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
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
    
    "Step 1) Add user message to chat history"
    history addMessage: (LLMAPIChatObjectMessage
                            role: 'user'
                            content: inputField text).

    "Step 2) Create and configure the local OllamaAPI instance"
    ollama := OllamaAPI new.
    ollama host: '127.0.0.1'.          " Typically the local Ollama server "
    ollama port: 11434.                " Default Ollama port (or whatever you run on)"
    
    "Pick whichever model you like; by default, it uses OCodeLlamaModel b7:
       ollama model: (OCodeLlamaModel b7). 
     Or explicitly pick any other OModel, e.g.:
       ollama model: (OPhi3Model mini)  etc.
    "
    
    "If you do not want streaming responses, set stream: false"
    ollama stream: false.

    "Step 3) Actually query the model with user’s text"
    "The #query: method returns either the model’s generated text or a dictionary with #response."
    result := ollama query: inputField text.

    "In OllamaAPI >> #query:, if stream=false, we do:
         ^ znClient post at: #response
     which is the final string from the model.
     So 'result' should be a string. 
    "

    "Step 4) Append the AI's reply (assistant) to your history."
    history addMessage: (LLMAPIChatObjectMessage
                            role: 'ChatPharo'
                            content: result).

    "Step 5) Clear out the user’s input field"
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

{ #category : 'initialization' }
ChatPharoSpecChat >> initializePresenters [

    submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        help: 'Submit prompt to LLM';
        action: [ self askLocalModel ];  " <— here we wire it to askLocalModel "
        yourself.

    inputField := self newTextInput.
    inputField whenSubmitDo: [ :text | self askLocalModel ].

    history := ChatPharoSpecChatHistory from: OrderedCollection new
]
