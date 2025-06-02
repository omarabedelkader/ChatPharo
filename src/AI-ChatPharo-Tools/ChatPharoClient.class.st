"
Metadata wrapper for **one tool/function**.

* Stores `name`, human `description`, JSON `parameters` schema, and the executable Smalltalk block.
* Can be serialised into the format expected by OpenAI’s `tool` array.
* **Why** – clean separation between *declaring* a tool (what it is) and *executing* it (done later by `ChatPharoTool` when the assistant calls it).
"
Class {
	#name : 'ChatPharoClient',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'parameters',
		'block'
	],
	#category : 'AI-ChatPharo-Tools',
	#package : 'AI-ChatPharo-Tools'
}

{ #category : 'as yet unclassified' }
ChatPharoClient class >> name: n description: d parameters: p block: b [ 

	^ self basicNew
		initializeWithName: n description: d parameters: p block: b;
		yourself
]

{ #category : 'initialization' }
ChatPharoClient >> applyTo: json [ 

	^ block value: json
]

{ #category : 'accessing' }
ChatPharoClient >> block [

	^ block
]

{ #category : 'accessing' }
ChatPharoClient >> block: anObject [

	block := anObject
]

{ #category : 'accessing' }
ChatPharoClient >> description [

	^ description
]

{ #category : 'accessing' }
ChatPharoClient >> description: anObject [

	description := anObject
]

{ #category : 'initialization' }
ChatPharoClient >> initializeWithName: n description: d parameters: p block: b [ 

	super initialize.
	name := n. description := d. parameters := p. block := b.
]

{ #category : 'accessing' }
ChatPharoClient >> name [

	^ name
]

{ #category : 'accessing' }
ChatPharoClient >> name: anObject [

	name := anObject
]

{ #category : 'initialization' }
ChatPharoClient >> openAIChatTool [ 

	^ Dictionary
		with:'type'->'function'
		with:'function'->(Dictionary
			with:'name'->name
			with:'description'->description
			with:'parameters'->parameters)
]

{ #category : 'accessing' }
ChatPharoClient >> parameters [

	^ parameters
]

{ #category : 'accessing' }
ChatPharoClient >> parameters: anObject [

	parameters := anObject
]
