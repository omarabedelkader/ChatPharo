Class {
	#name : 'OllamaAPITest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaAPI'
	],
	#category : 'AI-ChatPharo-Tests-Ullama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ullama'
}

{ #category : 'running' }
OllamaAPITest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaAPI := OllamaAPI new.
	ollamaAPI model: OllamaAPI modelNames first.
]

{ #category : 'tests' }
OllamaAPITest >> testGetResonceForPrompt [
	ollamaAPI getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaAPI response includesSubstring: 'Yes')
]

{ #category : 'tests' }
OllamaAPITest >> testModelInformation [
	"test that the connection to the model works"

	self 
		assert: ollamaAPI modelInformation class 
		equals: Dictionary 
]

{ #category : 'tests' }
OllamaAPITest >> testNewSystemPromptPrefix [
	"test that the connection to the model works"

	ollamaAPI
		system: 'Killroy was ';
		promptPrefix: 'here'.
	self assert: ollamaAPI system = 'Killroy was '.
	self assert: ollamaAPI promptPrefix = 'here'
]
