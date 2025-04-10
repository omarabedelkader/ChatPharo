Class {
	#name : 'AI_OllamaPromptingTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaPrompte'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
AI_OllamaPromptingTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	
	ollamaPrompte := Ollama
		       newSystem: ''
		       promptPrefix: ''.
]

{ #category : 'tests' }
AI_OllamaPromptingTest >> testGetResonceForPrompt [
	| result |
	result := Ollama new 
		getResponseForPrompt: ' Please answer Yes or no. Can you read these words'.
	self assert: (result includesSubstring: 'Yes')
]

{ #category : 'tests' }
AI_OllamaPromptingTest >> testNewSystemPromptPrefix [
	"test that the connection to the model works"

	| ollamaPrompting |
	ollamaPrompting := Ollama newSystem: 'Killroy was ' promptPrefix: 'here'.
	self assert: ollamaPrompting system = 'Killroy was '.
	self assert: ollamaPrompting promptPrefix = 'here'
]

{ #category : 'tests' }
AI_OllamaPromptingTest >> testOllamaList [
	"check at the list function works, and is larger than 0"
	| res |
	res := Ollama ollamaList.
	self assert: res size >= 1
	
]
