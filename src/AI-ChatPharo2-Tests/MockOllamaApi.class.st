Class {
	#name : 'MockOllamaApi',
	#superclass : 'Object',
	#instVars : [
		'conversationHistory',
		'currentModel'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'api' }
MockOllamaApi class >> modelNames [
	^ #('mock-default' 'mock-advanced')
]

{ #category : 'private - uffi' }
MockOllamaApi >> getResponseForPrompt: aPromptString [
	"Return something deterministic and easy to recognise in assertions."
	conversationHistory addLast: { #userPrompt -> aPromptString }.
	^ '<<', currentModel asUppercase, '-REPLY to: ', aPromptString, '>>'
]

{ #category : 'initialization' }
MockOllamaApi >> initialize [
	super initialize.
	conversationHistory := OrderedCollection new.
	currentModel := 'mock-default'.
]

{ #category : 'initialization' }
MockOllamaApi >> model: aString [
	currentModel := aString.
]

{ #category : 'private - uffi' }
MockOllamaApi >> system: aSystemPrompt [
	"store the running history just like the real client does and answer self
	 so that calls can be chained the same way the real API supports."
	conversationHistory addLast: { #systemPrompt -> aSystemPrompt }.
	^ self
]
