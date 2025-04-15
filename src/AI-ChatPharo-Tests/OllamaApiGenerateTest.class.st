Class {
	#name : 'OllamaApiGenerateTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaApiGenerate'
	],
	#category : 'AI-ChatPharo-Tests-Ollama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ollama'
}

{ #category : 'running' }
OllamaApiGenerateTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaApiGenerate := OllamaApiGenerate new.
	ollamaApiGenerate model: OllamaApiGenerate modelNames first.
]

{ #category : 'tests' }
OllamaApiGenerateTest >> testGetResponseForPrompt [
	ollamaApiGenerate getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaApiGenerate response includesSubstring: 'Yes')
]

{ #category : 'tests' }
OllamaApiGenerateTest >> testNewSystemPromptPrefix [
	"test that the connection to the model works "

	ollamaApiGenerate
		system: 'Killroy was ';
		promptPrefix: 'here'.
	self assert: ollamaApiGenerate system = 'Killroy was '.
	self assert: ollamaApiGenerate promptPrefix = 'here'
]
