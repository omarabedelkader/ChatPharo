Class {
	#name : 'OllamaAPIClassTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Ullama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ullama'
}

{ #category : 'tests' }
OllamaAPIClassTest >> testModelNames [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI modelNames.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaAPIClassTest >> testModels [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaAPIClassTest >> testOllamaList [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI models.
	self assert: res size >= 1
	
]

{ #category : 'tests' }
OllamaAPIClassTest >> testOllamaVersion [
	"check at the list function works, and is larger than 0"
	| res |
	res := OllamaAPI ollamaVersion.
	"If will fail if last become above 100"
	self assert: (res >= '0.5.10')
	
]
