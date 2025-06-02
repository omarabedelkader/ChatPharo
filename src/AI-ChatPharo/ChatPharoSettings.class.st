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
		  ChatPharoNullAgent.
		  ChatPharoOllamaAgent.
		ChatPharoGeminiAgent } "add more as you implement them"
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

    agent := anAgentClass new
]

{ #category : 'initialization' }
ChatPharoSettings >> useModel: aModelName [ 

    agent model: aModelName
]
