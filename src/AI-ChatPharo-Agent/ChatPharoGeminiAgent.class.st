"
Concrete agent for **Google Gemini REST**.

* Holds extra knobs: `apiKey`, `host`, `temperature`.
* Builds a `ChatPharoTool` preconfigured for Google’s “OpenAI-compatible” endpoint and delegates the heavy lifting to it.
* **Why** – same role as the Ollama agent but targeting Gemini; packaging all Gemini-specific wiring in one place keeps the rest of the codebase backend-agnostic.



```smalltalk
| chat gemini |
gemini := GeminiAgent new
	apiKey: '';
	model: 'models/gemini-2.0-flash';
	yourself.

chat := ChatPharoChat new
	agent: gemini;
	yourself.

chat sendMessage: 'Hello Gemini!'.
chat waitForPromptProcessDone.
(chat messages last answer) inspect.

```
"
Class {
	#name : 'ChatPharoGeminiAgent',
	#superclass : 'ChatPharoAgent',
	#instVars : [
		'host',
		'apiKey',
		'temperature',
		'packageName'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'api' }
ChatPharoGeminiAgent class >> displayName [

	^ 'Gemini'
]

{ #category : 'api' }
ChatPharoGeminiAgent class >> isReachable [
	[ | url |
		url := 'https://generativelanguage.googleapis.com/v1beta/models?key=dummy'.
		ZnClient new head: url.
		true ] on: NetworkError do: [ false ]
]

{ #category : 'api' }
ChatPharoGeminiAgent class >> modelNames [

	^ #( 'Enter your API-Key' )
]

{ #category : 'api' }
ChatPharoGeminiAgent class >> settingsPresenterFor: anAgent [
	^ ChatPharoGeminiSettingsPresenter on: anAgent
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'initialization' }
ChatPharoGeminiAgent >> getResponseForPrompt: userPrompt [
	| api result |
	
	self halt.
	api := ChatPharoTool
		geminiWithAPIKey: apiKey
		system: self systemPrompt
		tools: self tools.

	model ifNotEmpty: [ api model: model ].

	result := api getResponseForHistory:
		(ChatPharoHistorySaver
			role: 'user'
			content: userPrompt).

	^ result content
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> host [

	^ host
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
ChatPharoGeminiAgent >> initialize [

	super initialize.
	host := 'generativelanguage.googleapis.com'.
	apiKey := ''.
	model := ''.
	temperature := 0.7
]

{ #category : 'initialization' }
ChatPharoGeminiAgent >> modelInformation [
	^ self shouldBeImplemented
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> modelNames [ 

        apiKey isEmpty ifTrue: [ ^ self class modelNames ].

        ^ [
                (ChatPharoTool
                        geminiWithAPIKey: apiKey
                        system: nil) modelNames
        ] on: Error do: [ self class modelNames ]
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> packageName: aString [

	packageName := aString.
	self systemPrompt: 'You are an AI coding assistant inside the user''s Pharo image. The user is currently browsing the package ', packageName ,' Assume the user''s question is about classes or methods in that package and proactively explore its code.'
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> temperature [

	^ temperature
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> temperature: anObject [

	temperature := anObject
]

{ #category : 'tools support' }
ChatPharoGeminiAgent >> tools [
    ^ ChatPharoBrowserEnvironment new tools
]
