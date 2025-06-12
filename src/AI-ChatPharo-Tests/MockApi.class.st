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

{ #category : 'private - uffi' }
MockApi >> history [ 

        ^ conversationHistory
]

{ #category : 'private - uffi' }
MockApi >> history: aHistory [ 

        "ignore history"
]

{ #category : 'initialization' }
MockApi >> initialize [
	super initialize.
	conversationHistory := OrderedCollection new.
	currentModel := 'mock-default'.
]

{ #category : 'initialization' }
MockApi >> model [

        ^ currentModel
]

{ #category : 'initialization' }
MockApi >> model: aString [
	currentModel := aString.
]

{ #category : 'private - uffi' }
MockApi >> promptPrefix [ 

        ^ ''
]

{ #category : 'private - uffi' }
MockApi >> promptPrefix: aString [ 

        "ignored for tests"
]

{ #category : 'private - uffi' }
MockApi >> system: aSystemPrompt [

	conversationHistory addLast: { (#systemPrompt -> aSystemPrompt) }.
	^ self
]

{ #category : 'accessing' }
MockApi >> systemPrompt [ 

        ^ ''
]

{ #category : 'private - uffi' }
MockApi >> systemPrompt: aString [ 

        self system: aString
]
