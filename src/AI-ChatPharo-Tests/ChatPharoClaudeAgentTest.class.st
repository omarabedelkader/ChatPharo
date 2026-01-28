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

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testApiKeySetAndGet [

	agent apiKey: 'test-api-key'.
	self assert: agent apiKey equals: 'test-api-key'
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testConfigurationErrorMessage [

	self assert: agent configurationErrorMessage isNotEmpty
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testCopyForChat [

	| copy |
	agent model: 'claude-sonnet-4'.
	agent apiKey: 'test-key'.
	copy := agent copyForChat.
	self assert: copy isNotNil.
	self assert: copy class equals: ChatPharoClaudeAgent.
	self deny: copy == agent
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testDisplayName [

	self assert: ChatPharoClaudeAgent displayName isNotEmpty.
	self assert: (ChatPharoClaudeAgent displayName includesSubstring: 'Claude')
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testHasApiKey [

	agent apiKey: 'test'.
	self assert: agent apiKey isNotNil
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testHasHost [

	agent host: 'https://api.anthropic.com'.
	self assert: agent host isNotNil
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testHasTemperature [

	agent temperature: 0.7.
	self assert: agent temperature isNotNil
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testHostSetAndGet [

	agent host: 'https://custom-host.com'.
	self assert: agent host equals: 'https://custom-host.com'
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testInitialization [

	self assert: agent isNotNil.
	self assert: (agent isKindOf: ChatPharoAgent)
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testModelNamesIsNotEmpty [

	self assert: ChatPharoClaudeAgent modelNames isNotEmpty
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testModelSetAndGet [

	agent model: 'claude-sonnet-4'.
	self assert: agent model equals: 'claude-sonnet-4'
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testSettingsPresenter [

	| presenter |
	presenter := ChatPharoClaudeAgent settingsPresenterFor: agent.
	self assert: presenter isNotNil
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testSystemPromptSetAndGet [

	agent systemPrompt: 'Custom system prompt'.
	self assert: agent systemPrompt equals: 'Custom system prompt'
]

{ #category : 'tests' }
ChatPharoClaudeAgentTest >> testTemperatureSetAndGet [

	agent temperature: 0.8.
	self assert: agent temperature equals: 0.8
]
