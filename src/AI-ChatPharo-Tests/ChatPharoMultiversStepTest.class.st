Class {
	#name : 'ChatPharoMultiversStepTest',
	#superclass : 'TestCase',
	#instVars : [
		'step'
	],
	#category : 'AI-ChatPharo-Tests-Multivers',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Multivers'
}

{ #category : 'running' }
ChatPharoMultiversStepTest >> setUp [

	super setUp.
	step := ChatPharoMultiversStep new
]

{ #category : 'running' }
ChatPharoMultiversStepTest >> tearDown [

	step := nil.
	super tearDown
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentClassDefaultsToNullAgent [

	self assert: step agentClass equals: ChatPharoNullAgent
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentClassFromString [

	step agentClass: 'ChatPharoNullAgent'.
	self assert: step agentClass equals: ChatPharoNullAgent
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentClassFromSymbol [

	step agentClass: #ChatPharoNullAgent.
	self assert: step agentClass equals: ChatPharoNullAgent
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentClassSetClass [

	step agentClass: ChatPharoNullAgent.
	self assert: step agentClass equals: ChatPharoNullAgent
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentClassWithInvalidNameFallsBackToNull [

	step agentClass: 'NonExistentAgentClass'.
	self assert: step agentClass equals: ChatPharoNullAgent
]

{ #category : 'tests - agent class' }
ChatPharoMultiversStepTest >> testAgentDisplayName [

	step agentClass: ChatPharoNullAgent.
	self assert: step agentDisplayName isNotEmpty
]

{ #category : 'tests - agent settings' }
ChatPharoMultiversStepTest >> testAgentSettingsDefaultsToEmptyDictionary [

	self assert: step agentSettings isDictionary.
	self assert: step agentSettings isEmpty
]

{ #category : 'tests - agent settings' }
ChatPharoMultiversStepTest >> testAgentSettingsSetAndGet [

	| settings |
	settings := Dictionary new
		at: 'temperature' put: 0.7;
		at: 'maxTokens' put: 1000;
		yourself.
	step agentSettings: settings.
	self assert: step agentSettings equals: settings
]

{ #category : 'tests - building agent' }
ChatPharoMultiversStepTest >> testBuildAgentCreatesInstance [

	| agent |
	step agentClass: ChatPharoNullAgent.
	step model: 'test-model'.
	agent := step buildAgent.
	self assert: (agent isKindOf: ChatPharoNullAgent).
	self assert: agent model equals: 'test-model'
]

{ #category : 'tests - building agent' }
ChatPharoMultiversStepTest >> testBuildAgentSetsCustomSystemPrompt [

	| agent |
	step agentClass: ChatPharoNullAgent.
	step customSystemPrompt: 'Custom prompt'.
	agent := step buildAgent.
	self assert: agent systemPrompt equals: 'Custom prompt'
]

{ #category : 'tests - custom prompt' }
ChatPharoMultiversStepTest >> testCustomSystemPromptDefaultsToEmpty [

	self assert: step customSystemPrompt isEmpty
]

{ #category : 'tests - custom prompt' }
ChatPharoMultiversStepTest >> testCustomSystemPromptSetAndGet [

	step customSystemPrompt: 'You are an expert reviewer'.
	self assert: step customSystemPrompt equals: 'You are an expert reviewer'
]

{ #category : 'tests - display' }
ChatPharoMultiversStepTest >> testDisplayLabelDefaultsToAgentOrder [

	step order: 3.
	self assert: step displayLabel equals: 'Agent 3'
]

{ #category : 'tests - display' }
ChatPharoMultiversStepTest >> testDisplayLabelWithCustomLabel [

	step label: 'Reviewer'.
	self assert: step displayLabel equals: 'Reviewer'
]

{ #category : 'tests - initialization' }
ChatPharoMultiversStepTest >> testInitializeDefaults [

	self assert: step agentClass equals: ChatPharoNullAgent.
	self assert: step model isEmpty.
	self assert: step customSystemPrompt isEmpty.
	self assert: step order equals: 1.
	self assert: step label isEmpty.
	self assert: step agentSettings isDictionary
]

{ #category : 'tests - configuration' }
ChatPharoMultiversStepTest >> testIsConfiguredReturnsTrueForValidConfig [

	step agentClass: ChatPharoNullAgent.
	self assert: step isConfigured
]

{ #category : 'tests - configuration' }
ChatPharoMultiversStepTest >> testIsConfiguredReturnsTrueWithNullAgent [

	step agentClass: ChatPharoNullAgent.
	self assert: step isConfigured
]

{ #category : 'tests - order' }
ChatPharoMultiversStepTest >> testIsFirstStepReturnsFalseForOtherSteps [

	step order: 2.
	self deny: step isFirstStep
]

{ #category : 'tests - order' }
ChatPharoMultiversStepTest >> testIsFirstStepReturnsTrueForFirstStep [

	step order: 1.
	self assert: step isFirstStep
]

{ #category : 'tests - label' }
ChatPharoMultiversStepTest >> testLabelDefaultsToEmpty [

	self assert: step label isEmpty
]

{ #category : 'tests - label' }
ChatPharoMultiversStepTest >> testLabelSetAndGet [

	step label: 'Code Reviewer'.
	self assert: step label equals: 'Code Reviewer'
]

{ #category : 'tests - model' }
ChatPharoMultiversStepTest >> testModelDefaultsToEmpty [

	self assert: step model isEmpty
]

{ #category : 'tests - model' }
ChatPharoMultiversStepTest >> testModelSetAndGet [

	step model: 'llama3'.
	self assert: step model equals: 'llama3'
]

{ #category : 'tests - order' }
ChatPharoMultiversStepTest >> testOrderDefaultsToOne [

	self assert: step order equals: 1
]

{ #category : 'tests - order' }
ChatPharoMultiversStepTest >> testOrderSetAndGet [

	step order: 5.
	self assert: step order equals: 5
]

{ #category : 'tests - copying' }
ChatPharoMultiversStepTest >> testPostCopyCopiesSettings [

	| copy settings |
	settings := Dictionary new
		at: 'key' put: 'value';
		yourself.
	step agentSettings: settings.
	copy := step copy.
	self assert: copy agentSettings equals: step agentSettings.
	self deny: copy agentSettings == step agentSettings
]

{ #category : 'tests - display' }
ChatPharoMultiversStepTest >> testPrintOn [

	| string |
	step order: 2.
	step agentClass: ChatPharoNullAgent.
	step model: 'test-model'.
	string := String streamContents: [ :s | step printOn: s ].
	self assert: (string includesSubstring: 'Step 2').
	self assert: (string includesSubstring: 'test-model')
]

{ #category : 'tests - display' }
ChatPharoMultiversStepTest >> testStepDescriptionIncludesAgentAndModel [

	step order: 1.
	step agentClass: ChatPharoNullAgent.
	step model: 'test-model'.
	self assert: (step stepDescription includesSubstring: 'Step 1').
	self assert: (step stepDescription includesSubstring: 'test-model')
]

{ #category : 'tests - display' }
ChatPharoMultiversStepTest >> testStepDescriptionWithoutModel [

	step order: 2.
	step agentClass: ChatPharoNullAgent.
	self assert: (step stepDescription includesSubstring: 'Step 2')
]
