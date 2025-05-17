"
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
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'initialization' }
ChatPharoSettings >> agent [

	^ agent
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApiChoices [
	"Return an OrderedCollection of associations  
	 displayName -> class so the UI can show the name
	 but keep the class itself."
	^ (self availableApis collect: [ :cls |
			cls displayName -> cls ]) asOrderedCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApis [

	^ {
		  NullAgent.
		  OllamaAgent.
		GeminiAgent } "add more as you implement them"
]

{ #category : 'initialization' }
ChatPharoSettings >> initialize [

	super initialize.
	agent := NullAgent new
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
    (anAgentClass inheritsFrom: Agent)
        ifFalse: [ self error: 'Not an Agent subclass' ].
    agent := anAgentClass new

]

{ #category : 'initialization' }
ChatPharoSettings >> useModel: aModelName [ 

    agent model: aModelName
]
