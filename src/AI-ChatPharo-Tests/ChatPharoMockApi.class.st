"
a mock class
"
Class {
	#name : 'ChatPharoMockApi',
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
ChatPharoMockApi class >> modelNames [
	^ #('mock-default' 'mock-advanced')
]

{ #category : 'private - uffi' }
ChatPharoMockApi >> getResponseForPrompt: aPromptString [

	conversationHistory addLast: { (#userPrompt -> aPromptString) }.
	^ '<<' , currentModel asUppercase , '-REPLY to: ' , aPromptString
	  , '>>'
]

{ #category : 'initialization' }
ChatPharoMockApi >> initialize [
	super initialize.
	conversationHistory := OrderedCollection new.
	currentModel := 'mock-default'.
]

{ #category : 'initialization' }
ChatPharoMockApi >> model: aString [
	currentModel := aString.
]

{ #category : 'private - uffi' }
ChatPharoMockApi >> system: aSystemPrompt [

	conversationHistory addLast: { (#systemPrompt -> aSystemPrompt) }.
	^ self
]
