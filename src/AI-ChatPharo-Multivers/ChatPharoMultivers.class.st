"
A **Multiverse chain** configuration.
* Holds an ordered collection of `ChatPharoMultiversStep` objects representing the agent chain.
* When enabled, prompts flow through each step sequentially: the output of step N becomes part of the input for step N+1.
* Provides methods to add, remove, and reorder steps in the chain.
* **Why** – enables users to chain multiple LLM agents together for complex multi-model workflows.
Example:
```smalltalk
multivers := ChatPharoMultivers new.
multivers addStep: (ChatPharoMultiversStep new
    agentClass: ChatPharoOllamaAgent;
    model: 'llama3';
    yourself).
multivers addStep: (ChatPharoMultiversStep new
    agentClass: ChatPharoGeminiAgent;
    model: 'models/gemini-2.0-flash';
    yourself).
```
"
Class {
	#name : 'ChatPharoMultivers',
	#superclass : 'Object',
	#instVars : [
		'steps',
		'enabled',
		'name',
		'chainPromptTemplate'
	],
	#category : 'AI-ChatPharo-Multivers',
	#package : 'AI-ChatPharo-Multivers'
}

{ #category : 'accessing' }
ChatPharoMultivers class >> default [
	"Return a default multiverse with two steps"

	| multivers |
	multivers := self new.
	multivers name: 'Default Chain'.
	^ multivers
]

{ #category : 'accessing' }
ChatPharoMultivers >> addStep [
	"Add a new empty step to the chain"

	| step |
	step := ChatPharoMultiversStep new.
	step order: steps size + 1.
	steps add: step.
	^ step
]

{ #category : 'accessing' }
ChatPharoMultivers >> addStep: aStep [
	"Add a step to the chain"

	aStep order: steps size + 1.
	steps add: aStep.
	^ aStep
]

{ #category : 'accessing' }
ChatPharoMultivers >> canExecute [
	"Return true if the multiverse has at least 2 valid steps"

	^ self enabled and: [
		steps size >= 2 and: [
			steps allSatisfy: [ :step | step isConfigured ] ] ]
]

{ #category : 'accessing' }
ChatPharoMultivers >> chainPromptTemplate [
	"Template for how the previous agent's output is included in the next prompt.
	 Use {previousOutput} as placeholder for the previous response and {userPrompt} for original prompt."

	^ chainPromptTemplate ifNil: [
		chainPromptTemplate := 'Previous agent response:
---
{previousOutput}
---
Based on the above analysis, please continue with the following request:
{userPrompt}' ]
]

{ #category : 'accessing' }
ChatPharoMultivers >> chainPromptTemplate: aString [

	chainPromptTemplate := aString
]

{ #category : 'accessing' }
ChatPharoMultivers >> enabled [

	^ enabled ifNil: [ enabled := false ]
]

{ #category : 'accessing' }
ChatPharoMultivers >> enabled: aBoolean [

	enabled := aBoolean.
	ChatPharoLogger logFrontend: 'Multivers enabled toggled'
		details: (Dictionary new
			at: 'enabled' put: aBoolean;
			at: 'steps' put: steps size;
			yourself)
]

{ #category : 'accessing' }
ChatPharoMultivers >> executeForPrompt: userPrompt [
	"Execute the multiverse chain for the given prompt.
	 Returns the final output after passing through all agents."

	| currentOutput currentPrompt |
	self canExecute ifFalse: [
		^ self error: 'Multiverse is not properly configured or enabled' ].

	currentOutput := ''.
	currentPrompt := userPrompt.

	steps doWithIndex: [ :step :index |
		| agent response |
		agent := step buildAgent.

		"For first step, use original prompt. For subsequent steps, combine previous output with original."
		index > 1 ifTrue: [
			currentPrompt := self chainPromptTemplate
				copyReplaceAll: '{previousOutput}' with: currentOutput;
				copyReplaceAll: '{userPrompt}' with: userPrompt ].

		ChatPharoLogger logBackend: 'Multivers step executing'
			details: (Dictionary new
				at: 'step' put: index;
				at: 'totalSteps' put: steps size;
				at: 'agentClass' put: step agentClass name;
				at: 'model' put: step model;
				yourself).

		response := agent getResponseForPrompt: currentPrompt.
		currentOutput := response.

		ChatPharoLogger logBackend: 'Multivers step completed'
			details: (Dictionary new
				at: 'step' put: index;
				at: 'responseLength' put: currentOutput size;
				yourself) ].

	^ currentOutput
]

{ #category : 'accessing' }
ChatPharoMultivers >> executeForPrompt: userPrompt onStepComplete: aBlock [
	"Execute the multiverse chain, calling aBlock after each step with (stepIndex, response)"

	| currentOutput currentPrompt |
	self canExecute ifFalse: [
		^ self error: 'Multiverse is not properly configured or enabled' ].

	currentOutput := ''.
	currentPrompt := userPrompt.

	steps doWithIndex: [ :step :index |
		| agent response |
		agent := step buildAgent.

		index > 1 ifTrue: [
			currentPrompt := self chainPromptTemplate
				copyReplaceAll: '{previousOutput}' with: currentOutput;
				copyReplaceAll: '{userPrompt}' with: userPrompt ].

		response := agent getResponseForPrompt: currentPrompt.
		currentOutput := response.

		aBlock value: index value: currentOutput ].

	^ currentOutput
]

{ #category : 'accessing' }
ChatPharoMultivers >> initialize [

	super initialize.
	steps := OrderedCollection new.
	enabled := false.
	name := 'Multiverse Chain'
]

{ #category : 'accessing' }
ChatPharoMultivers >> moveStepDown: aStep [
	"Move a step down in the chain (later in execution order)"

	| index |
	index := steps indexOf: aStep ifAbsent: [ ^ self ].
	index = steps size ifTrue: [ ^ self ].
	steps swap: index with: index + 1.
	self reorderSteps
]

{ #category : 'accessing' }
ChatPharoMultivers >> moveStepUp: aStep [
	"Move a step up in the chain (earlier in execution order)"

	| index |
	index := steps indexOf: aStep ifAbsent: [ ^ self ].
	index = 1 ifTrue: [ ^ self ].
	steps swap: index with: index - 1.
	self reorderSteps
]

{ #category : 'accessing' }
ChatPharoMultivers >> name [

	^ name
]

{ #category : 'accessing' }
ChatPharoMultivers >> name: aString [

	name := aString
]

{ #category : 'accessing' }
ChatPharoMultivers >> removeStep: aStep [
	"Remove a step from the chain"

	steps remove: aStep ifAbsent: [ ].
	self reorderSteps
]

{ #category : 'accessing' }
ChatPharoMultivers >> removeStepAt: anIndex [
	"Remove step at given index"

	steps removeAt: anIndex ifAbsent: [ ].
	self reorderSteps
]

{ #category : 'accessing' }
ChatPharoMultivers >> reorderSteps [
	"Update order numbers for all steps"

	steps doWithIndex: [ :step :index |
		step order: index ]
]

{ #category : 'accessing' }
ChatPharoMultivers >> stepAt: anIndex [
	"Return step at given index"

	^ steps at: anIndex ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ChatPharoMultivers >> steps [

	^ steps
]

{ #category : 'accessing' }
ChatPharoMultivers >> stepsCount [

	^ steps size
]

{ #category : 'accessing' }
ChatPharoMultivers >> teps: aCollection [

	steps := aCollection asOrderedCollection.
	self reorderSteps
]
