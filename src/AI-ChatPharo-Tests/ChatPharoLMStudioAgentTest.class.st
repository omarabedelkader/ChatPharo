Class {
	#name : 'ChatPharoLMStudioAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> setUp [

	super setUp.
	agent := ChatPharoLMStudioAgent new
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testCopyForChat [

	| copy |
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoLMStudioAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testDisplayName [

	self assert: ChatPharoLMStudioAgent displayName isNotEmpty.
	self assert: (ChatPharoLMStudioAgent displayName includesSubstring: 'LM Studio')
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testHasHost [

	agent host: 'http://localhost:1234'.
	self assert: agent host isNotNil
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testHostSetAndGet [

	agent host: 'http://localhost:1234'.
	self assert: agent host equals: 'http://localhost:1234'
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoLMStudioAgentTest >> testModelSetAndGet [

	agent model: 'local-model'.
	self assert: agent model equals: 'local-model'
]
