"
An LLMAPITest is a test class for testing the behavior of LLMAPI.
"
Class {
	#name : 'LLMAPITest',
	#superclass : 'TestCase',
	#instVars : [
		'llmAPI'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
LLMAPITest >> setUp [
	super setUp.
	llmAPI := LLMAPI new.
]

{ #category : 'running' }
LLMAPITest >> tearDown [ 

	llmAPI := nil.
	super tearDown.
]

{ #category : 'tests' }
LLMAPITest >> testLLMAPIHasDefaultHost [

	self assert: (llmAPI host isString).
	self assert: (llmAPI host size > 0).
]

{ #category : 'tests' }
LLMAPITest >> testLLMAPIHasClientInitialized [

	self assert: (llmAPI client isKindOf: ZnClient).
]

{ #category : 'tests' }
LLMAPITest >> testLLMAPIHandlesAPIKey [

	llmAPI apiKey: 'test-key'.
	self assert: (llmAPI apiKey = 'test-key').
]

{ #category : 'tests' }
LLMAPITest >> testLLMAPIChatInstance [
	| chatInstance |
	chatInstance := LLMAPI chat.
	self assert: (chatInstance isKindOf: LLMAPIChat).
]
