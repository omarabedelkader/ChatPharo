Class {
	#name : 'OpenAIChatToolFunction',
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
OpenAIChatToolFunction class >> name: n description: d parameters: p block: b [ 

	^ self basicNew
		initializeWithName: n description: d parameters: p block: b;
		yourself
]

{ #category : 'initialization' }
OpenAIChatToolFunction >> applyTo: json [ 

	^ block value: json
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> block [

	^ block
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> block: anObject [

	block := anObject
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> description [

	^ description
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> description: anObject [

	description := anObject
]

{ #category : 'initialization' }
OpenAIChatToolFunction >> initializeWithName: n description: d parameters: p block: b [ 

	super initialize.
	name := n. description := d. parameters := p. block := b.
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> name [

	^ name
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> name: anObject [

	name := anObject
]

{ #category : 'initialization' }
OpenAIChatToolFunction >> openAIChatTool [ 

	^ Dictionary
		with:'type'->'function'
		with:'function'->(Dictionary
			with:'name'->name
			with:'description'->description
			with:'parameters'->parameters)
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> parameters [

	^ parameters
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> parameters: anObject [

	parameters := anObject
]
