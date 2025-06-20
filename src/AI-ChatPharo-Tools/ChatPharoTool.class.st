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
		'onToolExecution'
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

	^ ZnClient new
		url: baseURL;
		setBearerAuthentication: apiKey;
		yourself
]

{ #category : 'initialization' }
ChatPharoTool >> getResponseForHistory: history [ 

	| messages data response message |
	messages := Array streamContents: [ :stream |
		systemPrompt ifNotNil: [
			stream nextPut: (Dictionary with: 'role'->'system' with: 'content'->systemPrompt) ].
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
ChatPharoTool >> initializeWithBaseURL: initialBaseURL apiKey: initialAPIKey system: initialSystem tools: initialTools [

	super initialize.
	baseURL := initialBaseURL.
	apiKey := initialAPIKey.
	systemPrompt := initialSystem.
	tools := initialTools.
	onToolExecution := nil.
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

{ #category : 'accessing' }
ChatPharoTool >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
ChatPharoTool >> systemPrompt: aString [

	^ systemPrompt := aString 
]

{ #category : 'initialization' }
ChatPharoTool >> toolCallsFromMessage: message [ 

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
ChatPharoTool >> tools [

	^ tools
]

{ #category : 'accessing' }
ChatPharoTool >> tools: anObject [

	tools := anObject
]
