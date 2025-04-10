Class {
	#name : 'OllamaClassTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Ullama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ullama'
}

{ #category : 'tests' }
OllamaClassTest >> testModelNames [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI modelNames.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaClassTest >> testModels [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaClassTest >> testOllamaList [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaClassTest >> testOllamaVersion [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI ollamaVersion.
	"If will fail if last become above 100"
	self assert: (res >= '0.5.10')
	
]
