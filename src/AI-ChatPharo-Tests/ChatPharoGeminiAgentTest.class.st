Class {
	#name : 'ChatPharoGeminiAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoGeminiAgentTest >> setUp [

	super setUp.
	agent := ChatPharoGeminiAgent new
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testApiKeySetAndGet [

	agent apiKey: 'test-api-key'.
	self assert: agent apiKey equals: 'test-api-key'
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testCopyForChat [

	| copy |
	agent model: 'gemini-2.0-flash'.
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoGeminiAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testDisplayName [

	self assert: ChatPharoGeminiAgent displayName isNotEmpty.
	self assert: (ChatPharoGeminiAgent displayName includesSubstring: 'Gemini')
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testInitialization [ 

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testModelNamesIsNotEmpty [

	self assert: ChatPharoGeminiAgent modelNames isNotEmpty
]

{ #category : 'running' }
ChatPharoGeminiAgentTest >> testModelSetAndGet [

	agent model: 'gemini-2.0-flash'.
	self assert: agent model equals: 'gemini-2.0-flash'
]
