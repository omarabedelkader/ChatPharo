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
	#category : 'AI-ChatPharo-Tools',
	#package : 'AI-ChatPharo-Tools'
}

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> baseURL: baseURL apiKey: apiKey system: system [

	^ self
		  baseURL: baseURL
		  apiKey: apiKey
		  system: system
		  tools: nil
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> baseURL: baseURL apiKey: apiKey system: system tools: tools [

	^ self basicNew
		  initializeWithBaseURL: baseURL
		  apiKey: apiKey
		  system: system
		  tools: tools;
		  yourself
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> baseURL: baseURL system: system [

	^ self baseURL: baseURL system: system tools: nil
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> baseURL: baseURL system: system tools: tools [

	^ self
		  baseURL: baseURL
		  apiKey: nil
		  system: system
		  tools: tools
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> geminiWithAPIKey: apiKey system: system [

	^ self geminiWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> geminiWithAPIKey: apiKey system: system tools: tools [

	^ self
		  baseURL: (ZnUrl fromString:
				   'https://generativelanguage.googleapis.com/v1beta/openai')
		  apiKey: apiKey
		  system: system
		  tools: tools
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> ollamaWithSystem: system [ 

	^ self ollamaWithSystem: system tools: nil
]

{ #category : 'as yet unclassified' }
OpenAIChatAPI class >> ollamaWithSystem: system tools: tools [ 

	^ self baseURL: (ZnUrl fromString: 'http://localhost:11434/v1') system: system tools: tools
]

{ #category : 'accessing' }
OpenAIChatAPI >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
OpenAIChatAPI >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'initialization' }
OpenAIChatAPI >> applyToolFunction: functionName arguments: arguments [ 

	tools do:[:tool|
		tool name = functionName ifTrue:[
			^ [ tool applyTo: arguments ] on:Error do:[:e| Dictionary with:'error'->e messageText ] ] ].
	^ Dictionary with:'error'->('There is no function named "{1}"' format:{ functionName })
]

{ #category : 'accessing' }
OpenAIChatAPI >> baseURL [

	^ baseURL
]

{ #category : 'accessing' }
OpenAIChatAPI >> baseURL: anObject [

	baseURL := anObject
]

{ #category : 'initialization' }
OpenAIChatAPI >> client [ 

	^ ZnClient new
		url: baseURL;
		setBearerAuthentication: apiKey;
		yourself
]

{ #category : 'initialization' }
OpenAIChatAPI >> getResponseForHistory: history [ 

	| messages data response message |
	messages := Array streamContents: [ :stream |
		system ifNotNil: [
			stream nextPut: (Dictionary with: 'role'->'system' with: 'content'->system) ].
		history putOpenAIChatMessagesOn: stream ].

	data := Dictionary with:'model'->model with:'messages'->messages.
	tools ifNotNil:[
		data add:'tools'->(tools collect:[:t| t openAIChatTool ] as:Array);
		add:'tool_choice'->'auto'].

	response := self client addPath: #('chat' 'completions');
		entity:(ZnEntity json:(STONJSON toString:data));
		timeout:(Duration minutes:5) asSeconds;
		post;
		response.

	response isSuccess ifFalse:[ Error signal:'Could not get chat completion' ].

	message := ((STONJSON fromString: response contents) at:'choices') first at:'message'.
	^ ChatPharoHistorySaver
		role:'assistant'
		content:(message at:'content' ifAbsent:[ nil ])
		toolCalls:(self toolCallsFromMessage: message)
]

{ #category : 'initialization' }
OpenAIChatAPI >> initializeWithBaseURL: initialBaseURL apiKey: initialAPIKey system: initialSystem tools: initialTools [ 

	super initialize.
	baseURL := initialBaseURL.
	apiKey  := initialAPIKey.
	system  := initialSystem.
	tools   := initialTools.
	self model: self modelNames first.
]

{ #category : 'accessing' }
OpenAIChatAPI >> model [

	^ model
]

{ #category : 'accessing' }
OpenAIChatAPI >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
OpenAIChatAPI >> modelNames [ 

	| response |
	response := self client addPathSegment:'models'; get; response.
	response isSuccess ifFalse:[ Error signal:'Could not retrieve models' ].
	^ ((STONJSON fromString: response contents) at:'data') collect:[:m| m at:'id' ]
]

{ #category : 'accessing' }
OpenAIChatAPI >> system [

	^ system
]

{ #category : 'accessing' }
OpenAIChatAPI >> system: anObject [

	system := anObject
]

{ #category : 'initialization' }
OpenAIChatAPI >> toolCallsFromMessage: message [ 

	^ message at:'tool_calls'
		ifPresent:[:calls|
			calls collect:[:c|
				| fn args content |
				fn   := (c at:'function') at:'name'.
				args := (c at:'function') at:'arguments'.
				content := STONJSON toString:
					(self applyToolFunction: fn
						arguments:([ STONJSON fromString: args ] on:STONReaderError do:[ Dictionary with:'error'->'Invalid arguments' ])).
				ChatPharoHistorySaverToolCall
					id:(c at:'id') functionName:fn arguments:args content:content ] ]
		ifAbsent:[ nil ]
]

{ #category : 'accessing' }
OpenAIChatAPI >> tools [

	^ tools
]

{ #category : 'accessing' }
OpenAIChatAPI >> tools: anObject [

	tools := anObject
]
