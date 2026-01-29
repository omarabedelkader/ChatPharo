Class {
	#name : 'ChatPharoMistralAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoMistralAgentTest >> setUp [

	super setUp.
	agent := ChatPharoMistralAgent new
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testApiKeySetAndGet [

	agent apiKey: 'test-api-key'.
	self assert: agent apiKey equals: 'test-api-key'
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testCopyForChat [

	| copy |
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoMistralAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testDisplayName [

	self assert: ChatPharoMistralAgent displayName isNotEmpty.
	self assert: (ChatPharoMistralAgent displayName includesSubstring: 'Mistral')
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testModelNamesIsNotEmpty [

	self assert: ChatPharoMistralAgent modelNames isNotEmpty
]

{ #category : 'running' }
ChatPharoMistralAgentTest >> testModelSetAndGet [

	agent model: 'mistral-large'.
	self assert: agent model equals: 'mistral-large'
]
