Class {
	#name : 'ChatPharoDeepSeekAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> setUp [

	super setUp.
	agent := ChatPharoDeepSeekAgent new
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testApiKeySetAndGet [

	agent apiKey: 'test-api-key'.
	self assert: agent apiKey equals: 'test-api-key'
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testCopyForChat [

	| copy |
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoDeepSeekAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testDisplayName [

	self assert: ChatPharoDeepSeekAgent displayName isNotEmpty.
	self assert: (ChatPharoDeepSeekAgent displayName includesSubstring: 'DeepSeek')
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testModelNamesIsNotEmpty [

	self assert: ChatPharoDeepSeekAgent modelNames isNotEmpty
]

{ #category : 'running' }
ChatPharoDeepSeekAgentTest >> testModelSetAndGet [

	agent model: 'deepseek-chat'.
	self assert: agent model equals: 'deepseek-chat'
]
