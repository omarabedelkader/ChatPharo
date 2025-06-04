"
a mock class
"
Class {
	#name : 'MockApi',
	#superclass : 'Object',
	#instVars : [
		'conversationHistory',
		'currentModel'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'api' }
MockApi class >> modelNames [
	^ #('mock-default' 'mock-advanced')
]

{ #category : 'private - uffi' }
MockApi >> getResponseForPrompt: aPromptString [

	conversationHistory addLast: { (#userPrompt -> aPromptString) }.
	^ '<<' , currentModel asUppercase , '-REPLY to: ' , aPromptString
	  , '>>'
]

{ #category : 'initialization' }
MockApi >> initialize [
	super initialize.
	conversationHistory := OrderedCollection new.
	currentModel := 'mock-default'.
]

{ #category : 'initialization' }
MockApi >> model: aString [
	currentModel := aString.
]

{ #category : 'private - uffi' }
MockApi >> system: aSystemPrompt [

	conversationHistory addLast: { (#systemPrompt -> aSystemPrompt) }.
	^ self
]
