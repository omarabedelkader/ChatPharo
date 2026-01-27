"
A **general OpenAI-style REST client**.

* Configured through a family of factory methods (`geminiWithAPIKey:`, `ollamaWithSystem:` …) which set `baseURL`, `apiKey`, default `model`, etc.
* Accepts a list of **tools** (see `ChatPharoClient`) so that function-calling requests can be routed automatically.
* Central routine `getResponseForHistory:` posts *one composite JSON* (`model`, `messages`, optional `tools/tool_choice`) to `/chat/completions`, then converts the reply back into `ChatPharoHistorySaver` plus `ChatPharoHistorySaverToolCall` objects.
* **Why** – unifies all “talk to an LLM” code in one tested component, eliminating duplication in the agent subclasses.


```smalltalk
(ChatPharoBrowserEnvironment new functionGetClassesInPackages
    applyTo: (Dictionary with: 'packages' -> #('AI-ChatPharo-Agent')))
```
"
Class {
	#name : 'ChatPharoTool',
	#superclass : 'Object',
	#instVars : [
		'baseURL',
		'apiKey',
		'model',
		'tools',
		'systemPrompt',
		'onToolExecution',
		'extraParameters',
		'extraHeaders'
	],
	#category : 'AI-ChatPharo-Tools-Core',
	#package : 'AI-ChatPharo-Tools',
	#tag : 'Core'
}

{ #category : 'instance creation' }
ChatPharoTool class >> baseURL: baseURL apiKey: apiKey system: system [

	^ self
		  baseURL: baseURL
		  apiKey: apiKey
		  system: system
		  tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> baseURL: baseURL apiKey: apiKey system: system tools: tools [

	^ self basicNew
		  initializeWithBaseURL: baseURL
		  apiKey: apiKey
		  system: system
		  tools: tools;
		  yourself
]

{ #category : 'instance creation' }
ChatPharoTool class >> baseURL: baseURL system: system [

	^ self baseURL: baseURL system: system tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> baseURL: baseURL system: system tools: tools [

	^ self
		  baseURL: baseURL
		  apiKey: nil
		  system: system
		  tools: tools
]

{ #category : 'instance creation' }
ChatPharoTool class >> claudeWithAPIKey: apiKey system: system [

	^ self claudeWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> claudeWithAPIKey: apiKey system: system tools: tools [

	| tool |
	tool := self
		baseURL: (ZnUrl fromString: 'https://api.anthropic.com/v1')
		apiKey: apiKey
		system: system
		tools: tools.
	tool extraHeaders: (Dictionary new
		at: 'x-api-key' put: apiKey;
		at: 'anthropic-version' put: '2023-06-01';
		yourself).
	^ tool
]

{ #category : 'instance creation' }
ChatPharoTool class >> deepSeekWithAPIKey: apiKey system: system [

	^ self deepSeekWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> deepSeekWithAPIKey: apiKey system: system tools: tools [

	^ self
		baseURL: (ZnUrl fromString: 'https://api.deepseek.com/v1')
		apiKey: apiKey
		system: system
		tools: tools
]

{ #category : 'instance creation' }
ChatPharoTool class >> geminiWithAPIKey: apiKey system: system [

	^ self geminiWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> geminiWithAPIKey: apiKey system: system tools: tools [

	^ self
		  baseURL: (ZnUrl fromString:
				   'https://generativelanguage.googleapis.com/v1beta/openai')
		  apiKey: apiKey
		  system: system
		  tools: tools
]

{ #category : 'as yet unclassified' }
ChatPharoTool class >> mistralWithAPIKey: apiKey system: system [ 


        ^ self mistralWithAPIKey: apiKey system: system tools: nil
]

{ #category : 'as yet unclassified' }
ChatPharoTool class >> mistralWithAPIKey: apiKey system: system tools: tools [ 


        ^ self
                  baseURL: (ZnUrl fromString: 'https://api.mistral.ai/v1')
                  apiKey: apiKey
                  system: system
                  tools: tools
]

{ #category : 'instance creation' }
ChatPharoTool class >> new [

	^ self ollamaWithSystem: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> ollamaWithSystem: system [ 

	^ self ollamaWithSystem: system tools: nil
]

{ #category : 'instance creation' }
ChatPharoTool class >> ollamaWithSystem: system tools: tools [ 

	^ self baseURL: (ZnUrl fromString: 'http://localhost:11434/v1') system: system tools: tools
]

{ #category : 'accessing' }
ChatPharoTool >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
ChatPharoTool >> apiKey: anObject [

	apiKey := anObject
]

{ #category : 'initialization' }
ChatPharoTool >> applyToolFunction: functionName arguments: arguments [

onToolExecution ifNotNil: [ :blk | blk value ].
	tools ifNil: [
			^ Dictionary with: 'error'
				  -> ('There is no function named "{1}"' format: { functionName }) ].
	tools do: [ :tool |
			tool name = functionName ifTrue: [
					^ [ tool applyTo: arguments ]
						  on: Error
						  do: [ :e | Dictionary with: 'error' -> e messageText ] ] ].
	^ Dictionary with: 'error'
		  -> ('There is no function named "{1}"' format: { functionName })
]

{ #category : 'accessing' }
ChatPharoTool >> baseURL [

	^ baseURL
]

{ #category : 'accessing' }
ChatPharoTool >> baseURL: anObject [

	baseURL := anObject
]

{ #category : 'initialization' }
ChatPharoTool >> client [

	| client |
	client := ZnClient new
		url: baseURL;
		yourself.
	extraHeaders ifNotNil: [
		extraHeaders keysAndValuesDo: [ :key :value |
			client headerAt: key put: value ] ]
	ifNil: [
		apiKey ifNotNil: [ client setBearerAuthentication: apiKey ] ].
	^ client
]

{ #category : 'accessing' }
ChatPharoTool >> extraHeaders [

	^ extraHeaders
]

{ #category : 'accessing' }
ChatPharoTool >> extraHeaders: aDictionary [

	extraHeaders := aDictionary
]

{ #category : 'initialization' }
ChatPharoTool >> getResponseForHistory: history [

	| messages data response message |
	messages := Array streamContents: [ :stream |
			            systemPrompt ifNotNil: [ stream nextPut: (Dictionary with: 'role' -> 'system' with: 'content' -> systemPrompt) ].
			            history putOpenAIChatMessagesOn: stream ].

	data := Dictionary with: 'model' -> model with: 'messages' -> messages.
	extraParameters ifNotNil: [ data addAll: extraParameters ].
	tools ifNotNil: [
			data
				add: 'tools' -> (tools collect: [ :t | t openAIChatTool ] as: Array);
				add: 'tool_choice' -> 'auto' ].

	response := self client
		            addPath: #( 'chat' 'completions' );
		            entity: (ZnEntity json: (STONJSON toString: data));
		            timeout: (Duration minutes: 5) asSeconds;
		            post;
		            response.

	response isSuccess ifFalse: [ Error signal: 'Could not get chat completion' ].

	message := ((STONJSON fromString: response contents) at: 'choices') first at: 'message'.
	^ ChatPharoHistorySaver
		  role: 'assistant'
		  content: (message at: 'content' ifAbsent: [ nil ])
		  toolCalls: (self toolCallsFromMessage: message)
]

{ #category : 'initialization' }
ChatPharoTool >> initializeWithBaseURL: initialBaseURL apiKey: initialAPIKey system: initialSystem tools: initialTools [

	super initialize.
	baseURL := initialBaseURL.
	apiKey := initialAPIKey.
	systemPrompt := initialSystem.
	tools := initialTools.
	onToolExecution := nil.
	extraParameters := Dictionary new.
	self model: self modelNames first
]

{ #category : 'accessing' }
ChatPharoTool >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoTool >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
ChatPharoTool >> modelNames [ 

	| response |
	response := self client addPathSegment:'models'; get; response.
	response isSuccess ifFalse:[ Error signal:'Could not retrieve models' ].
	^ ((STONJSON fromString: response contents) at:'data') collect:[:m| m at:'id' ]
]

{ #category : 'accessing' }
ChatPharoTool >> onToolExecution [ 

        ^ onToolExecution
]

{ #category : 'accessing' }
ChatPharoTool >> onToolExecution: aBlock [ 

        onToolExecution := aBlock
]

{ #category : 'initialization' }
ChatPharoTool >> requestParameters [

	^ extraParameters ifNil: [ extraParameters := Dictionary new ]
]

{ #category : 'initialization' }
ChatPharoTool >> requestParameters: aDictionary [

	extraParameters := aDictionary ifNil: [ Dictionary new ]
]

{ #category : 'accessing' }
ChatPharoTool >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
ChatPharoTool >> systemPrompt: aString [

	^ systemPrompt := aString 
]

{ #category : 'accessing' }
ChatPharoTool >> toolCallsFromMessage: message [

    | calls |
    calls := message at: 'tool_calls' ifAbsent: [ nil ].
    calls isNil ifTrue: [ ^ nil ].

    ^ calls collect: [ :c |
        | fn rawArgs parsedArgs content callId |
        fn := (c at: 'function') at: 'name'.
        rawArgs := (c at: 'function') at: 'arguments' ifAbsent: [ '{}' ].
        parsedArgs := (rawArgs isString
            ifTrue: [
                [ STONJSON fromString: rawArgs ]
                    on: Error do: [ Dictionary with: 'error' -> 'Invalid arguments' ] ]
            ifFalse: [ rawArgs ifNil: [ Dictionary new ] ]).

        content := STONJSON toString:
            (self applyToolFunction: fn arguments: parsedArgs).

        callId := c at: 'id' ifAbsent: [ 'tool-', (DateAndTime now asString) ].

        ChatPharoHistorySaverToolCall
            id: callId
            functionName: fn
            arguments: (rawArgs isString ifTrue: [ rawArgs ] ifFalse: [ STONJSON toString: parsedArgs ])
            content: content
    ].
]

{ #category : 'accessing' }
ChatPharoTool >> tools [

	^ tools
]

{ #category : 'accessing' }
ChatPharoTool >> tools: anObject [

	tools := anObject
]
