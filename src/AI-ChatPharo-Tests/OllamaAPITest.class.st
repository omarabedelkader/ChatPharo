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
OllamaAPITest >> testModelInformation [
	"test that the connection to the model works"

	self 
		assert: ollamaAPI modelInformation class 
		equals: Dictionary 
]

{ #category : 'tests' }
OllamaAPITest >> testModelNames [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI modelNames.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaAPITest >> testModels [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
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

{ #category : 'tests' }
OllamaAPITest >> testOllamaList [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaAPITest >> testOllamaVersion [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI ollamaVersion.
	"If will fail if last become above 100"
	self assert: (res >= '0.5.10')
	
]
