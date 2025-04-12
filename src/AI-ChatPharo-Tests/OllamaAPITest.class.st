"
An OllamaAPITest is a test class for testing the behavior of OllamaAPI
"
Class {
	#name : 'OllamaAPITest',
	#superclass : 'TestCase',
	#instVars : [
		'ollama'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
OllamaAPITest >> setUp [
	super setUp.
	ollama := OllamaAPI new.
]

{ #category : 'running' }
OllamaAPITest >> tearDown [ 

	ollama := nil.
	super tearDown.	
]

{ #category : 'running' }
OllamaAPITest >> testOllamaAPIHasDefaultModelInitialized [

	self assert: (ollama model isString).
	self assert: (ollama model notEmpty).
]
