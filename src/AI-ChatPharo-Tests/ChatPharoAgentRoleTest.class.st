Class {
	#name : 'ChatPharoAgentRoleTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Director',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Director'
}

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testBaseRoleDefaultNameIsSubclassResponsibility [

	self should: [ ChatPharoAgentRole defaultName ] raise: Error
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testCoderRoleCustomParametersEmpty [

	| role |
	role := ChatPharoCoderRole new.
	self assert: role customParameters isEmpty
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testCoderRoleDefaultName [

	self assert: ChatPharoCoderRole defaultName equals: 'Coder'
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testCoderRoleInitializesCapabilities [

	| role |
	role := ChatPharoCoderRole new.

	self assert: (role capabilities includes: 'code-generation').
	self assert: (role capabilities includes: 'refactoring').
	self assert: (role capabilities includes: 'bug-fixing').
	self assert: (role capabilities includes: 'code-analysis').
	self assert: role capabilities size equals: 4
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testCoderRoleSystemPromptContainsPharo [

	| role |
	role := ChatPharoCoderRole new.
	self assert: (role systemPrompt includesSubstring: 'Pharo')
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testResearcherRoleCustomParameters [

	| role |
	role := ChatPharoResearcherRole new.
	self assert: (role customParameters at: 'preferHighTokens') equals: true
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testResearcherRoleDefaultName [

	self assert: ChatPharoResearcherRole defaultName equals: 'Researcher'
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testResearcherRoleInitializesCapabilities [

	| role |
	role := ChatPharoResearcherRole new.

	self assert: (role capabilities includes: 'codebase-exploration').
	self assert: (role capabilities includes: 'architecture-analysis').
	self assert: (role capabilities includes: 'dependency-tracking').
	self assert: (role capabilities includes: 'documentation').
	self assert: role capabilities size equals: 4
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testResearcherRoleSystemPromptContainsResearch [

	| role |
	role := ChatPharoResearcherRole new.
	self assert: (role systemPrompt includesSubstring: 'researcher')
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testRoleCapabilitiesSetter [

	| role caps |
	role := ChatPharoCoderRole new.
	caps := OrderedCollection with: 'custom-capability'.
	role capabilities: caps.
	self assert: role capabilities size equals: 1.
	self assert: (role capabilities includes: 'custom-capability')
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testRoleCustomParametersSetter [

	| role params |
	role := ChatPharoCoderRole new.
	params := Dictionary with: 'temp' -> 0.7.
	role customParameters: params.
	self assert: (role customParameters at: 'temp') equals: 0.7
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testRoleNameSetter [

	| role |
	role := ChatPharoCoderRole new.
	role name: 'Custom Coder'.
	self assert: role name equals: 'Custom Coder'
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testRoleSystemPromptSetter [

	| role |
	role := ChatPharoCoderRole new.
	role systemPrompt: 'Custom prompt'.
	self assert: role systemPrompt equals: 'Custom prompt'
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testSummarizerRoleCustomParametersEmpty [

	| role |
	role := ChatPharoSummarizerRole new.
	self assert: role customParameters isEmpty
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testSummarizerRoleDefaultName [

	self assert: ChatPharoSummarizerRole defaultName equals: 'Summarizer'
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testSummarizerRoleInitializesCapabilities [

	| role |
	role := ChatPharoSummarizerRole new.

	self assert: (role capabilities includes: 'information-synthesis').
	self assert: (role capabilities includes: 'conflict-resolution').
	self assert: (role capabilities includes: 'result-merging').
	self assert: (role capabilities includes: 'communication').
	self assert: role capabilities size equals: 4
]

{ #category : 'tests' }
ChatPharoAgentRoleTest >> testSummarizerRoleSystemPromptContainsSynthesis [

	| role |
	role := ChatPharoSummarizerRole new.
	self assert: (role systemPrompt includesSubstring: 'synthesizing')
]
