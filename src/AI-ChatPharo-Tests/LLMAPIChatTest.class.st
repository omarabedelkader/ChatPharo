"
An LLMAPIChatTest is a test class for testing the behavior of LLMAPIChat.
"
Class {
	#name : 'LLMAPIChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chatAPI'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
LLMAPIChatTest >> setUp [
	super setUp.
	chatAPI := LLMAPIChat new.
]

{ #category : 'running' }
LLMAPIChatTest >> tearDown [ 
	chatAPI := nil.
	super tearDown.
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatHasCorrectPath [
	self assert: (chatAPI path = 'v1/chat/completions').
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatHasCorrectPayloadClass [
	self assert: (chatAPI payloadClass = LLMAPIChatObjectPayload).
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatRequestSetup [
	chatAPI apiKey: 'test-key'.
	chatAPI host: 'api.example.com'.
	chatAPI prepareRequest.

	self assert: (chatAPI host = 'api.example.com').

	self assert: ((chatAPI client request headers at: 'Authorization' ifAbsent: [ '' ]) 
		includesSubstring: 'Bearer test-key').
]
