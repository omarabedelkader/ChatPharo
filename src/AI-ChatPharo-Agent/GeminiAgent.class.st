"
```smalltalk
| chat gemini |
gemini := GeminiAgent new
	apiKey: 'YOUR‑KEY';
	model: 'gemini-pro';
	yourself.

chat := ChatPharoChat new
	ollamaApi: gemini;   ""the ivar is badly named, but still just an Agent""
	yourself.

chat presenter open.
```
"
Class {
	#name : 'GeminiAgent',
	#superclass : 'Agent',
	#instVars : [
		'host',
		'apiKey',
		'temperature'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'api' }
GeminiAgent class >> displayName [

	^ 'Gemini'
]

{ #category : 'api' }
GeminiAgent class >> isReachable [
	[ | url |
		url := 'https://generativelanguage.googleapis.com/v1beta/models?key=dummy'.
		ZnClient new head: url.
		true ] on: NetworkError do: [ false ]
]

{ #category : 'api' }
GeminiAgent class >> modelNames [

	"Gemini’s REST does not expose a discover‑models endpoint
	 yet, so list a few common ones."
	^ #('gemini-pro' 'gemini-pro-vision')
]

{ #category : 'api' }
GeminiAgent class >> settingsPresenterFor: anAgent [
	^ GeminiSettingsPresenter on: anAgent
]

{ #category : 'accessing' }
GeminiAgent >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
GeminiAgent >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'initialization' }
GeminiAgent >> getResponseForPrompt: userPrompt [ 
	| api result |
	api := OpenAIChatAPI
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
GeminiAgent >> host [

	^ host
]

{ #category : 'accessing' }
GeminiAgent >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
GeminiAgent >> initialize [
	super initialize.
	host        := 'generativelanguage.googleapis.com'.
	apiKey      := ''.
	model       := 'gemini-pro'.
	temperature := 0.7
]

{ #category : 'as yet unclassified' }
GeminiAgent >> modelInformation [
	^ self shouldBeImplemented
]

{ #category : 'accessing' }
GeminiAgent >> temperature [

	^ temperature
]

{ #category : 'accessing' }
GeminiAgent >> temperature: anObject [

	temperature := anObject
]
