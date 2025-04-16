Class {
	#name : 'OllamaApiTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaApi'
	],
	#category : 'AI-ChatPharo-Tests-Ollama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ollama'
}

{ #category : 'running' }
OllamaApiTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaApi := OllamaApi new.
	ollamaApi model: OllamaApi modelNames first.
]

{ #category : 'tests' }
OllamaApiTest >> testGetResponseForPrompt [
	ollamaApi getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaApi response includesSubstring: 'Yes')
]

{ #category : 'tests' }
OllamaApiTest >> testModelInformation [
	"test that the connection to the model works"

	self 
		assert: ollamaApi modelInformation class 
		equals: Dictionary 
]

{ #category : 'tests' }
OllamaApiTest >> testModelNames [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaApi modelNames.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaApiTest >> testModels [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaApi models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaApiTest >> testNewSystemPromptPrefix [
	"test that the connection to the model works "

	ollamaApi
		system: 'Killroy was ';
		promptPrefix: 'here'.
	self assert: ollamaApi system equals: 'Killroy was '.
	self assert: ollamaApi promptPrefix equals: 'here'
]

{ #category : 'tests' }
OllamaApiTest >> testOllamaVersion [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaApi ollamaVersion.
	"If will fail if last become above 100"
	self assert: (res >= '0.5.10')
	
]
