Class {
	#name : 'OpenAIChatAPI',
	#superclass : 'Object',
	#instVars : [
		'baseURL',
		'apiKey',
		'model',
		'system',
		'tools'
	],
	#category : 'AI-ChatPharo-OpenAI',
	#package : 'AI-ChatPharo',
	#tag : 'OpenAI'
}

{ #category : 'instance creation' }
OpenAIChatAPI class >> baseURL: baseURL apiKey: apiKey system: system [

	^ self baseURL: baseURL apiKey: apiKey system: system tools: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> baseURL: baseURL apiKey: apiKey system: system tools: tools [

	^ self basicNew initializeWithBaseURL: baseURL apiKey: apiKey system: system tools: tools; yourself
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> baseURL: baseURL system: system [

	^ self baseURL: baseURL system: system tools: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> baseURL: baseURL system: system tools: tools [

	^ self baseURL: baseURL apiKey: nil system: system tools: tools
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> geminiWithAPIKey: apiKey system: system [

	^ self geminiWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> geminiWithAPIKey: apiKey system: system tools: tools [

	^ self baseURL: (ZnUrl fromString: 'https://generativelanguage.googleapis.com/v1beta/openai')
		apiKey: apiKey system: system tools: tools
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> new [

	^ self ollamaWithSystem: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> ollamaWithSystem: system [

	^ self ollamaWithSystem: system tools: nil
]

{ #category : 'instance creation' }
OpenAIChatAPI class >> ollamaWithSystem: system tools: tools [

	^ self baseURL: (ZnUrl fromString: 'http://localhost:11434/v1') system: system tools: tools
]

{ #category : 'private' }
OpenAIChatAPI >> applyToolFunction: functionName arguments: arguments [

	tools do: [ :tool |
		tool name = functionName ifTrue: [
			^ [ tool applyTo: arguments ] on: Error do: [ Dictionary with: 'error' -> 'Error' ] ] ].
	^ Dictionary with: 'error' -> ('There is no function named "{1}"' format: { functionName })
]

{ #category : 'accessing' }
OpenAIChatAPI >> baseURL [

	^ baseURL
]

{ #category : 'private' }
OpenAIChatAPI >> client [

	^ ZnClient new
		url: baseURL;
		setBearerAuthentication: apiKey;
		yourself
]

{ #category : 'api' }
OpenAIChatAPI >> getResponseForHistory: history [

	| messages data response message |

	messages := Array streamContents: [ :stream |
		system ifNotNil: [
			stream nextPut: (Dictionary with: 'role' -> 'system' with: 'content' -> system) ].
		history putOpenAIChatMessagesOn: stream ].
	data := Dictionary with: 'model' -> model with: 'messages' -> messages.
	tools ifNotNil: [
		data add: 'tools' -> (tools collect: [ :tool | tool openAIChatTool ] as: Array);
			add: 'tool_choice' -> 'auto' ].
	response := self client addPath: #('chat' 'completions');
		entity: (ZnEntity json: (STONJSON toString: data));
		timeout: (Duration minutes: 5) asSeconds;
		post;
		response.
	response isSuccess ifFalse: [ Error signal: 'Could not get chat completion' ].
	message := ((STONJSON fromString: response contents) at: 'choices') first at: 'message'.
	^ ChatPharoHistorySaver role: 'assistant'
		content: (message at: 'content' ifAbsent: [ nil ])
		toolCalls: (self toolCallsFromMessage: message)
]

{ #category : 'initialization' }
OpenAIChatAPI >> initializeWithBaseURL: initialBaseURL apiKey: initialAPIKey system: initialSystem tools: initialTools [

	self initialize.
	baseURL := initialBaseURL.
	apiKey := initialAPIKey.
	system := initialSystem.
	tools := initialTools.
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

{ #category : 'private' }
OpenAIChatAPI >> toolCallsFromMessage: message [

	^ message at: 'tool_calls'
		ifPresent: [ :toolCalls |
			toolCalls collect: [ :toolCall |
				| function functionName arguments content |
				function := toolCall at: 'function'.
				functionName := function at: 'name'.
				arguments := function at: 'arguments'.
				content := STONJSON toString: (self applyToolFunction: functionName
					arguments: ([ STONJSON fromString: arguments ] on: STONReaderError
						do: [ Dictionary with: 'error' -> 'Invalid arguments' ])).
				ChatPharoHistorySaverToolCall id: (toolCall at: 'id') functionName: functionName
					arguments: arguments content: content ] ]
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
OpenAIChatAPI >> tools [

	^ tools
]
