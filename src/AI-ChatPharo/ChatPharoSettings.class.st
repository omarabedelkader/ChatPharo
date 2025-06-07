"
User-editable configuration.

* Knows the currently selected `agent`.
* Produces the list of **available API choices** by returning associations `displayName -> class`.
* Delegates model selection (`useModel:`) and agent swapping (`useApi:`) to the agent it owns.
* **Why** – separates persistent/user-configurable concerns from transient chat state.


```smalltalk
(ChatPharoSettings new
	useModel: 'codellama:7b';
	ollamaApi)
		getResponseForPrompt: 'Bonjour'.

```
"
Class {
	#name : 'ChatPharoSettings',
	#superclass : 'Object',
	#instVars : [
		'agent'
	],
	#classInstVars : [
		'Default'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoSettings class >> default [ 

    Default ifNil: [ Default := self loadOrNew ].
    ^ Default
]

{ #category : 'accessing' }
ChatPharoSettings class >> loadOrNew [ 

    | path file settings |
path := FileLocator imageDirectory / 'chatpharo-settings.ston'.

    file := path exists ifTrue: [ path readStream ] ifFalse: [ ^ self new ].
    
    [ settings := STON fromStream: file ]
        on: Error
        do: [ ^ self new ].
        
    ^ settings
]

{ #category : 'accessing' }
ChatPharoSettings class >> resetDefault [ 

    Default := nil
]

{ #category : 'accessing' }
ChatPharoSettings class >> saveDefault [ 

    | path |
    path := FileLocator imageDirectory / 'chatpharo-settings.ston'.
    path writeStreamDo: [ :stream | STON put: self default onStream: stream ].

]

{ #category : 'initialization' }
ChatPharoSettings >> agent [

	^ agent
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApiChoices [

	^ (self availableApis collect: [ :cls | cls displayName -> cls ])
		  asOrderedCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApis [

	^ {
		  ChatPharoNullAgent.
		  ChatPharoOllamaAgent.
		  ChatPharoGeminiAgent.
		ChatPharoMistralAgent }
]

{ #category : 'initialization' }
ChatPharoSettings >> initialize [

	super initialize.
	agent := ChatPharoNullAgent new
]

{ #category : 'initialization' }
ChatPharoSettings >> models [

	^ agent class modelNames
]

{ #category : 'initialization' }
ChatPharoSettings >> presenter [

	^  ChatPharoSettingsPresenter on: self
]

{ #category : 'initialization' }
ChatPharoSettings >> useApi: anAgentClass [

	agent := anAgentClass new.
	self class saveDefault
]

{ #category : 'initialization' }
ChatPharoSettings >> useModel: aModelName [

	agent model: aModelName.
	self class saveDefault
]
