Class {
	#name : 'OpenAIChatAPI',
	#superclass : 'Object',
	#instVars : [
		'baseURL',
		'model',
		'system'
	],
	#category : 'AI-ChatPharo-OpenAI',
	#package : 'AI-ChatPharo',
	#tag : 'OpenAI'
}

{ #category : 'instance creation' }
OpenAIChatAPI class >> baseURL: baseURL system: system [

	^ self basicNew initializeWithBaseURL: baseURL system: system; yourself
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> new [

	^ self ollamaWithSystem: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> ollamaWithSystem: system [

	^ self baseURL: (ZnUrl fromString: 'http://localhost:11434/v1') system: system
]

{ #category : 'accessing' }
OpenAIChatAPI >> baseURL [

	^ baseURL
]

{ #category : 'private' }
OpenAIChatAPI >> client [

	^ ZnClient new
		url: baseURL;
		yourself
]

{ #category : 'api' }
OpenAIChatAPI >> getResponseForHistory: history [

	| messages data response |

	messages := Array streamContents: [ :stream |
		system ifNotNil: [
			stream nextPut: (Dictionary with: 'role' -> 'system' with: 'content' -> system) ].
		history putOpenAIChatMessagesOn: stream ].
	data := Dictionary with: 'model' -> model with: 'messages' -> messages.
	response := self client addPath: #('chat' 'completions');
		entity: (ZnEntity json: (STONJSON toString: data));
		timeout: (Duration minutes: 5) asSeconds;
		post;
		response.
	response isSuccess ifFalse: [ Error signal: 'Could not get chat completion' ].
	^ (((STONJSON fromString: response contents) at: 'choices') first at: 'message') at: 'content'
]

{ #category : 'initialization' }
OpenAIChatAPI >> initializeWithBaseURL: initialBaseURL system: initialSystem [

	self initialize.
	baseURL := initialBaseURL.
	system := initialSystem.
	self model: self modelNames first.
]

{ #category : 'accessing' }
OpenAIChatAPI >> model [

	^ model
]

{ #category : 'accessing' }
OpenAIChatAPI >> model: newModel [

	model := newModel
]

{ #category : 'api' }
OpenAIChatAPI >> modelNames [

	| response |

	response := self client addPathSegment: 'models'; get; response.
	response isSuccess ifFalse: [ Error signal: 'Could not retrieve models' ].
	^ ((STONJSON fromString: response contents) at: 'data') collect: [ :modelObject | modelObject at: 'id' ]
]

{ #category : 'accessing' }
OpenAIChatAPI >> system [

	^ system
]
