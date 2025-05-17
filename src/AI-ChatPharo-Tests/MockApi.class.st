Class {
	#name : 'MockApi',
	#superclass : 'Object',
	#instVars : [
		'conversationHistory',
		'currentModel'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'api' }
MockApi class >> modelNames [
	^ #('mock-default' 'mock-advanced')
]

{ #category : 'private - uffi' }
MockApi >> getResponseForPrompt: aPromptString [
	"Return something deterministic and easy to recognise in assertions."
	conversationHistory addLast: { #userPrompt -> aPromptString }.
	^ '<<', currentModel asUppercase, '-REPLY to: ', aPromptString, '>>'
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
	"store the running history just like the real client does and answer self
	 so that calls can be chained the same way the real API supports."
	conversationHistory addLast: { #systemPrompt -> aSystemPrompt }.
	^ self
]
