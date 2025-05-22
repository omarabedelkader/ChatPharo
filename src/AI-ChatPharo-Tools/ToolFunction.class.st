Class {
	#name : 'ToolFunction',
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
ToolFunction class >> name: aName description: aDescription parameters: aParameters block: aBlock [
    ^ self new
        initializeWithName: aName
        description: aDescription
        parameters: aParameters
        block: aBlock;
        yourself.
]

{ #category : 'initialization' }
ToolFunction >> applyTo: jsonDict [
    "Run the Smalltalk block that actually fulfils the function."
    ^ block value: jsonDict.
]

{ #category : 'initialization' }
ToolFunction >> initializeWithName: n description: d parameters: p block: b [
    name        := n.
    description := d.
    parameters  := p.
    block       := b.
]

{ #category : 'initialization' }
ToolFunction >> openAITool [
    "Shape required by the /chat/completions endpoint."
    ^ Dictionary
        with: 'type'     -> 'function'
        with: 'function' -> (Dictionary
                                with: 'name'        -> name
                                with: 'description' -> description
                                with: 'parameters'  -> parameters)
]
