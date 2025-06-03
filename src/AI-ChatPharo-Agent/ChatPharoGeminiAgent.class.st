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
		'temperature'
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

	"Gemini’s REST does not expose a discover‑models endpoint
	 yet, so list a few common ones."
	^ #('gemini-pro' 'gemini-pro-vision')
]

{ #category : 'api' }
ChatPharoGeminiAgent class >> settingsPresenterFor: anAgent [
	^ GeminiSettingsPresenter on: anAgent
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
	api := ChatPharoTool
		geminiWithAPIKey: apiKey
		system: (system ifEmpty: ['']).
	temperature ifNotNil:[
		api model: model ].
	"prepare history as ChatPharoHistorySaver objects"
	result := api getResponseForHistory:
		(ChatPharoHistorySaver role:'user' content:userPrompt).
	^ result content  "return plain assistant text to existing UI"
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
	host        := 'generativelanguage.googleapis.com'.
	apiKey      := ''.
	model       := 'gemini-pro'.
	temperature := 0.7
]

{ #category : 'as yet unclassified' }
ChatPharoGeminiAgent >> modelInformation [
	^ self shouldBeImplemented
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> temperature [

	^ temperature
]

{ #category : 'accessing' }
ChatPharoGeminiAgent >> temperature: anObject [

	temperature := anObject
]

{ #category : 'as yet unclassified' }
ChatPharoGeminiAgent >> tools [
    ^ ChatPharoBrowserEnvironment new tools
]
