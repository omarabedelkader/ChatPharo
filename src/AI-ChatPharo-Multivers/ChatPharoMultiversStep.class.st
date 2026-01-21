"
A **single step** in a Multiverse chain.
* Stores the agent class, model name, and custom system prompt for one step in the chain.
* Can build a configured agent instance ready for execution.
* Tracks its position in the chain via `order`.
* **Why** – encapsulates all configuration needed for one agent in a multi-agent workflow.
Example:
```smalltalk
step := ChatPharoMultiversStep new
    agentClass: ChatPharoOllamaAgent;
    model: 'llama3';
    customSystemPrompt: 'You are an expert code reviewer.';
    yourself.
```
"
Class {
	#name : 'ChatPharoMultiversStep',
	#superclass : 'Object',
	#instVars : [
		'agentClass',
		'model',
		'customSystemPrompt',
		'order',
		'label',
		'agentSettings'
	],
	#category : 'AI-ChatPharo-Multivers',
	#package : 'AI-ChatPharo-Multivers'
}

{ #category : 'accessing' }
ChatPharoMultiversStep >> agentClass [

	^ agentClass ifNil: [ agentClass := ChatPharoNullAgent ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> agentClass: aClass [

	agentClass := aClass
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> agentDisplayName [
	"Return display name for the current agent class"

	^ self agentClass displayName
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> agentSettings [
	"Additional settings dictionary for agent-specific configuration"

	^ agentSettings ifNil: [ agentSettings := Dictionary new ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> agentSettings: aDictionary [

	agentSettings := aDictionary
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> buildAgent [
	"Create and configure an agent instance for this step"

	| agent |
	agent := self agentClass new.

	self model ifNotEmpty: [ agent model: self model ].

	self customSystemPrompt ifNotEmpty: [
		agent systemPrompt: self customSystemPrompt ].

	"Apply additional settings"
	self agentSettings keysAndValuesDo: [ :key :value |
		(agent respondsTo: (key , ':') asSymbol) ifTrue: [
			agent perform: (key , ':') asSymbol with: value ] ].

	^ agent
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> customSystemPrompt [

	^ customSystemPrompt ifNil: [ '' ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> customSystemPrompt: aString [

	customSystemPrompt := aString
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> displayLabel [
	"Return a display label for this step"

	^ label ifEmpty: [ 'Agent ' , self order asString ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> initialize [

	super initialize.
	agentClass := ChatPharoNullAgent.
	model := ''.
	customSystemPrompt := ''.
	order := 1.
	label := ''.
	agentSettings := Dictionary new
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> isConfigured [

	"Return true if this step has valid configuration"

	^ self agentClass notNil and: [
		self agentClass ~= ChatPharoNullAgent or: [
			"Allow null agent if intentional - check model is set for others"
			true ] ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> isFirstStep [

	^ order = 1
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> label [

	^ label ifNil: [ '' ]

]

{ #category : 'accessing' }
ChatPharoMultiversStep >> label: aString [ 

	label := aString

]

{ #category : 'accessing' }
ChatPharoMultiversStep >> model [

	^ model ifNil: [ '' ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> model: aString [

	model := aString
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> order [

	^ order ifNil: [ 1 ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> order: aNumber [

	order := aNumber
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> postCopy [

	super postCopy.
	agentSettings := agentSettings copy
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> printOn: aStream [

	aStream
		nextPutAll: 'Step ';
		nextPutAll: self order asString;
		nextPutAll: ': ';
		nextPutAll: self agentDisplayName.
	self model ifNotEmpty: [
		aStream
			nextPutAll: ' (';
			nextPutAll: self model;
			nextPutAll: ')' ]
]

{ #category : 'accessing' }
ChatPharoMultiversStep >> stepDescription [
	"Return a human-readable description of this step"

	^ String streamContents: [ :stream |
		stream nextPutAll: 'Step '.
		stream nextPutAll: self order asString.
		stream nextPutAll: ': '.
		stream nextPutAll: self agentDisplayName.
		self model ifNotEmpty: [
			stream nextPutAll: ' - '.
			stream nextPutAll: self model ] ]
]
