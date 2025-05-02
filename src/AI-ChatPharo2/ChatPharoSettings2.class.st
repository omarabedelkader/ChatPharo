"
```smalltalk
(ChatPharoSettings new
	useModel: 'codellama:7b';
	ollamaApi)
		getResponseForPrompt: 'Bonjour'.

```
"
Class {
	#name : 'ChatPharoSettings2',
	#superclass : 'Object',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'initialization' }
ChatPharoSettings2 >> agent [

	^ agent
]

{ #category : 'initialization' }
ChatPharoSettings2 >> availableApis [ 

    ^ { NullAgent. OllamaApi }   "add more as you implement them"
]

{ #category : 'initialization' }
ChatPharoSettings2 >> initialize [

	super initialize.
	agent := NullAgent new
]

{ #category : 'initialization' }
ChatPharoSettings2 >> models [

	^ agent class modelNames
]

{ #category : 'initialization' }
ChatPharoSettings2 >> presenter [

	^  ChatPharoSettingsPresenter2 on: self
]

{ #category : 'initialization' }
ChatPharoSettings2 >> useApi: anAgentClass [ 
    (anAgentClass inheritsFrom: Agent)
        ifFalse: [ self error: 'Not an Agent subclass' ].
    agent := anAgentClass new

]

{ #category : 'initialization' }
ChatPharoSettings2 >> useModel: aModelName [ 

    agent model: aModelName
]
