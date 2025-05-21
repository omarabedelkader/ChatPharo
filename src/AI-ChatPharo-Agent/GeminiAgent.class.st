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
	"Build JSON → POST → extract the assistant text"
	| url body jsonResponse |
	
	url  := String streamContents: [ :s |
		s
			nextPutAll: 'https://';
			nextPutAll: host;
			nextPutAll: '/v1/models/';
			nextPutAll: model;
			nextPutAll: ':generateContent?key=';
			nextPutAll: apiKey ].

	body := STONJSON toString: {
		'contents' -> {			"Gemini chat format"
			Dictionary newFrom: {
				'role'  -> 'user'.
				'parts' -> { Dictionary newFrom: {
					'text' -> ((promptPrefix ifEmpty: [''] ifNotEmpty: [promptPrefix , ' ']) , userPrompt)
				}}
			}
		}.
		'safetySettings' -> #().
		'generationConfig' -> Dictionary newFrom: {
			'temperature' -> temperature.
			'maxOutputTokens' -> 4096 } 
	}.

	jsonResponse := ZnClient new
		url: url;
		entity: (ZnEntity with: body contentType: ZnMimeType applicationJson);
		post;
		contents.

	"Gemini returns { 'candidates':[ { 'content': { 'parts':[ {text: …} ]}} ] }"
	^ (((STONJSON fromString: jsonResponse)
			at: 'candidates') first
			atPath: 'content.parts.1.text').
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
