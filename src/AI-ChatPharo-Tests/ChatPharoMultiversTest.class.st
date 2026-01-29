Class {
	#name : 'ChatPharoMultiversTest',
	#superclass : 'TestCase',
	#instVars : [
		'multivers'
	],
	#category : 'AI-ChatPharo-Tests-Multivers',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Multivers'
}

{ #category : 'running' }
ChatPharoMultiversTest >> setUp [

	super setUp.
	multivers := ChatPharoMultivers new
]

{ #category : 'running' }
ChatPharoMultiversTest >> tearDown [

	multivers := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoMultiversTest >> testAddEmptyStep [

	| step |
	step := multivers addStep.
	self assert: multivers steps size equals: 1.
	self assert: step order equals: 1.
	self assert: (multivers steps includes: step)
]

{ #category : 'running' }
ChatPharoMultiversTest >> testAddMultipleSteps [

	| step1 step2 step3 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	step3 := multivers addStep.
	self assert: multivers steps size equals: 3.
	self assert: step1 order equals: 1.
	self assert: step2 order equals: 2.
	self assert: step3 order equals: 3
]

{ #category : 'running' }
ChatPharoMultiversTest >> testAddStep [

	| step |
	step := ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		model: 'test-model';
		yourself.
	multivers addStep: step.
	self assert: multivers steps size equals: 1.
	self assert: step order equals: 1
]

{ #category : 'running' }
ChatPharoMultiversTest >> testCanExecuteReturnsFalseWhenDisabled [

	multivers enabled: false.
	multivers addStep: (ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		yourself).
	multivers addStep: (ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		yourself).
	self deny: multivers canExecute
]

{ #category : 'running' }
ChatPharoMultiversTest >> testCanExecuteReturnsFalseWithLessThanTwoSteps [

	multivers enabled: true.
	multivers addStep: (ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		yourself).
	self deny: multivers canExecute
]

{ #category : 'running' }
ChatPharoMultiversTest >> testCanExecuteReturnsTrueWithValidConfiguration [

	multivers enabled: true.
	multivers addStep: (ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		yourself).
	multivers addStep: (ChatPharoMultiversStep new
		agentClass: ChatPharoNullAgent;
		yourself).
	self assert: multivers canExecute
]

{ #category : 'running' }
ChatPharoMultiversTest >> testChainPromptTemplateCustom [

	| customTemplate |
	customTemplate := 'Previous: {previousOutput}, Next: {userPrompt}'.
	multivers chainPromptTemplate: customTemplate.
	self assert: multivers chainPromptTemplate equals: customTemplate
]

{ #category : 'running' }
ChatPharoMultiversTest >> testChainPromptTemplateDefault [

	self assert: (multivers chainPromptTemplate includesSubstring: '{previousOutput}').
	self assert: (multivers chainPromptTemplate includesSubstring: '{userPrompt}')
]

{ #category : 'running' }
ChatPharoMultiversTest >> testDefaultReturnsMultivers [

	| defaultMultivers |
	defaultMultivers := ChatPharoMultivers default.
	self assert: (defaultMultivers isKindOf: ChatPharoMultivers).
	self assert: defaultMultivers name equals: 'Default Chain'
]

{ #category : 'running' }
ChatPharoMultiversTest >> testEnabledDefaultsToFalse [

	self deny: multivers enabled
]

{ #category : 'running' }
ChatPharoMultiversTest >> testEnabledSetsAndGetsValue [

	multivers enabled: true.
	self assert: multivers enabled.
	multivers enabled: false.
	self deny: multivers enabled
]

{ #category : 'running' }
ChatPharoMultiversTest >> testExecuteForPromptFailsWhenNotConfigured [

	multivers enabled: false.
	self should: [ multivers executeForPrompt: 'test' ] raise: Error
]

{ #category : 'running' }
ChatPharoMultiversTest >> testInitializeStartsEmpty [

	self assert: multivers steps isEmpty.
	self deny: multivers enabled.
	self assert: multivers name equals: 'Multiverse Chain'
]

{ #category : 'running' }
ChatPharoMultiversTest >> testMoveStepDown [

	| step1 step2 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	multivers moveStepDown: step1.
	self assert: (multivers steps at: 1) equals: step2.
	self assert: (multivers steps at: 2) equals: step1.
	self assert: step1 order equals: 2.
	self assert: step2 order equals: 1
]

{ #category : 'running' }
ChatPharoMultiversTest >> testMoveStepDownAtEndDoesNothing [

	| step1 step2 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	multivers moveStepDown: step2.
	self assert: (multivers steps at: 1) equals: step1.
	self assert: (multivers steps at: 2) equals: step2
]

{ #category : 'running' }
ChatPharoMultiversTest >> testMoveStepUp [

	| step1 step2 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	multivers moveStepUp: step2.
	self assert: (multivers steps at: 1) equals: step2.
	self assert: (multivers steps at: 2) equals: step1.
	self assert: step1 order equals: 2.
	self assert: step2 order equals: 1
]

{ #category : 'running' }
ChatPharoMultiversTest >> testMoveStepUpAtStartDoesNothing [

	| step1 step2 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	multivers moveStepUp: step1.
	self assert: (multivers steps at: 1) equals: step1.
	self assert: (multivers steps at: 2) equals: step2
]

{ #category : 'running' }
ChatPharoMultiversTest >> testNameSetAndGet [

	multivers name: 'Test Chain'.
	self assert: multivers name equals: 'Test Chain'
]

{ #category : 'running' }
ChatPharoMultiversTest >> testRemoveStep [

	| step1 step2 step3 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	step3 := multivers addStep.
	multivers removeStep: step2.
	self assert: multivers steps size equals: 2.
	self deny: (multivers steps includes: step2).
	self assert: step1 order equals: 1.
	self assert: step3 order equals: 2
]

{ #category : 'running' }
ChatPharoMultiversTest >> testRemoveStepAt [

	| step1 step2 step3 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	step3 := multivers addStep.
	multivers removeStepAt: 2.
	self assert: multivers steps size equals: 2.
	self assert: (multivers steps includes: step1).
	self assert: (multivers steps includes: step3).
	self deny: (multivers steps includes: step2)
]

{ #category : 'running' }
ChatPharoMultiversTest >> testStepAt [

	| step1 step2 |
	step1 := multivers addStep.
	step2 := multivers addStep.
	self assert: (multivers stepAt: 1) equals: step1.
	self assert: (multivers stepAt: 2) equals: step2.
	self assert: (multivers stepAt: 99) isNil
]

{ #category : 'running' }
ChatPharoMultiversTest >> testStepsCount [

	self assert: multivers stepsCount equals: 0.
	multivers addStep.
	self assert: multivers stepsCount equals: 1.
	multivers addStep.
	self assert: multivers stepsCount equals: 2
]
