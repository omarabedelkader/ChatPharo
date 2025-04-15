Class {
	#name : 'OllamaApiTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaAPI'
	],
	#category : 'AI-ChatPharo-Tests-Ollama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ollama'
}

{ #category : 'running' }
OllamaApiTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaAPI := OllamaApi new.
	ollamaAPI model: OllamaApi modelNames first.
]

{ #category : 'tests' }
OllamaApiTest >> testModelInformation [
	"test that the connection to the model works"

	self 
		assert: ollamaAPI modelInformation class 
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
OllamaApiTest >> testOllamaList [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaApi models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaApiTest >> testOllamaVersion [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaApi ollamaVersion.
	"If will fail if last become above 100"
	self assert: (res >= '0.5.10')
	
]
