Class {
	#name : 'ChatPharoOllamaAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoOllamaAgentTest >> setUp [

	super setUp.
	agent := ChatPharoOllamaAgent new
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testCopyForChat [

	| copy |
	agent model: 'llama3'.
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoOllamaAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testDisplayName [

	self assert: ChatPharoOllamaAgent displayName isNotEmpty.
	self assert: (ChatPharoOllamaAgent displayName includesSubstring: 'Ollama')
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testHasHost [

	agent host: 'http://localhost:11434'.
	self assert: agent host isNotNil
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testHostSetAndGet [

	agent host: 'http://localhost:11434'.
	self assert: agent host equals: 'http://localhost:11434'
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoOllamaAgentTest >> testModelSetAndGet [

	agent model: 'llama3'.
	self assert: agent model equals: 'llama3'
]
