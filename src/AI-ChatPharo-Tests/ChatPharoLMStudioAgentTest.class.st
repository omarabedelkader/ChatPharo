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

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testCopyForChat [

	| copy |
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoLMStudioAgent.
	self deny: copy == agent
]

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testDisplayName [

	self assert: ChatPharoLMStudioAgent displayName isNotEmpty.
	self assert: (ChatPharoLMStudioAgent displayName includesSubstring: 'LM Studio')
]

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testHasHost [

	agent host: 'http://localhost:1234'.
	self assert: agent host isNotNil
]

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testHostSetAndGet [

	agent host: 'http://localhost:1234'.
	self assert: agent host equals: 'http://localhost:1234'
]

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'tests' }
ChatPharoLMStudioAgentTest >> testModelSetAndGet [

	agent model: 'local-model'.
	self assert: agent model equals: 'local-model'
]
