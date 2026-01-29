Class {
	#name : 'ChatPharoClaudeAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoClaudeAgentTest >> setUp [

	super setUp.
	agent := ChatPharoClaudeAgent new
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> tearDown [

	agent := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testApiKeySetAndGet [

	agent apiKey: 'test-api-key'.
	self assert: agent apiKey equals: 'test-api-key'
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testConfigurationErrorMessage [

	self assert: agent configurationErrorMessage isNotEmpty
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testCopyForChat [

	| copy |
	agent model: 'claude-sonnet-4'.
	agent apiKey: 'test-key'.
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoClaudeAgent.
	self deny: copy == agent
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testDisplayName [

	self assert: ChatPharoClaudeAgent displayName isNotEmpty.
	self assert: (ChatPharoClaudeAgent displayName includesSubstring: 'Claude')
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testHasApiKey [

	agent apiKey: 'test'.
	self assert: agent apiKey isNotNil
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testHasHost [

	agent host: 'https://api.anthropic.com'.
	self assert: agent host isNotNil
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testHasTemperature [

	agent temperature: 0.7.
	self assert: agent temperature isNotNil
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testHostSetAndGet [

	agent host: 'https://custom-host.com'.
	self assert: agent host equals: 'https://custom-host.com'
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testModelNamesIsNotEmpty [

	self assert: ChatPharoClaudeAgent modelNames isNotEmpty
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testModelSetAndGet [

	agent model: 'claude-sonnet-4'.
	self assert: agent model equals: 'claude-sonnet-4'
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testSettingsPresenter [

	| presenter |
	presenter := ChatPharoClaudeAgent settingsPresenterFor: agent.
	self assert: presenter isNotNil
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testSystemPromptSetAndGet [

	agent systemPrompt: 'Custom system prompt'.
	self assert: agent systemPrompt equals: 'Custom system prompt'
]

{ #category : 'running' }
ChatPharoClaudeAgentTest >> testTemperatureSetAndGet [

	agent temperature: 0.8.
	self assert: agent temperature equals: 0.8
]
