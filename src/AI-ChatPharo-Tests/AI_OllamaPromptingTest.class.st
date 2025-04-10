Class {
	#name : 'AI_OllamaPromptingTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'tests' }
AI_OllamaPromptingTest >> testGetResonceForPrompt [
	| ollamaModel |
	ollamaModel := Ollama new.
	ollamaModel model: Ollama modelNames first.
	ollamaModel getResponseForPrompt: 'Can you read these words. Please answer Yes or no'.
	self assert: (ollamaModel response includesSubstring: 'Yes')
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
	res := Ollama models.
	self assert: res size >= 1
	
]
