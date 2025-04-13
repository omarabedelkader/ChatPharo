Class {
	#name : 'OllamaApiGenerateTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaApiGenerate'
	],
	#category : 'AI-ChatPharo-Tests-Ullama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ullama'
}

{ #category : 'running' }
OllamaApiGenerateTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaApiGenerate := OllamaApiGenerate new.
	ollamaApiGenerate model: OllamaApiGenerate modelNames first.
]

{ #category : 'tests' }
OllamaApiGenerateTest >> testGetResonceForPrompt [
	ollamaApiGenerate getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaApiGenerate response includesSubstring: 'Yes')
]
