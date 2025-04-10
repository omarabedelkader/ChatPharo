Class {
	#name : 'OllamaTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaAPI'
	],
	#category : 'AI-ChatPharo-Tests-Ullama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ullama'
}

{ #category : 'running' }
OllamaTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaAPI := OllamaAPI new.
	ollamaAPI model: OllamaAPI modelNames first.
]

{ #category : 'tests' }
OllamaTest >> testGetResonceForPrompt [
	ollamaAPI getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaAPI response includesSubstring: 'Yes')
]

{ #category : 'tests' }
OllamaTest >> testModelInformation [
	"test that the connection to the model works"

	self 
		assert: ollamaAPI modelInformation class 
		equals: Dictionary 
]

{ #category : 'tests' }
OllamaTest >> testNewSystemPromptPrefix [
	"test that the connection to the model works"

	ollamaAPI
		system: 'Killroy was ';
		promptPrefix: 'here'.
	self assert: ollamaAPI system = 'Killroy was '.
	self assert: ollamaAPI promptPrefix = 'here'
]
