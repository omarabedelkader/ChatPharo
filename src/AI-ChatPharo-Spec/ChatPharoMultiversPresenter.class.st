"
Settings presenter for managing the Multiverse chain configuration.
Allows users to:
- Enable/disable multivers mode
- Add, remove, and reorder agent steps in the chain
- Configure each agent step (agent type, model, system prompt)
- Preview the chain execution flow
The Multiverse allows chaining multiple LLM agents together where the output of each agent
becomes part of the input for the next agent in the chain.
"
Class {
	#name : 'ChatPharoMultiversPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'enabledCheckBox',
		'stepsList',
		'addStepButton',
		'removeStepButton',
		'moveUpButton',
		'moveDownButton',
		'stepConfigPanel',
		'chainPreviewText',
		'templateInput',
		'agentDropList',
		'modelDropList',
		'systemPromptInput',
		'stepLabelInput',
		'refreshModelsButton',
		'selectedStep',
		'isUpdatingUI'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> availableAgentClasses [
	"Return list of available agent classes"

	^ ChatPharoSettings new availableApis
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> buildChainPreview [
	"Build a visual representation of the current chain"

	| text |
	text := String streamContents: [ :stream |
		stream nextPutAll: '=== Multiverse Chain Preview ==='; cr; cr.

		model multivers enabled
			ifTrue: [
				model multivers steps isEmpty
					ifTrue: [ stream nextPutAll: '(No steps configured - add at least 2 agents)' ]
					ifFalse: [
						stream nextPutAll: '[User Prompt]'; cr.
						model multivers steps doWithIndex: [ :step :index |
							stream nextPutAll: '     |'; cr.
							stream nextPutAll: '     v'; cr.
							stream nextPutAll: '[ Step '.
							stream nextPutAll: index asString.
							stream nextPutAll: ': '.
							stream nextPutAll: step agentDisplayName.
							step model ifNotEmpty: [
								stream nextPutAll: ' ('.
								stream nextPutAll: step model.
								stream nextPutAll: ')' ].
							stream nextPutAll: ' ]'; cr ].
						stream nextPutAll: '     |'; cr.
						stream nextPutAll: '     v'; cr.
						stream nextPutAll: '[Final Response]' ] ]
			ifFalse: [ stream nextPutAll: '(Multivers disabled - enable to use chain)' ] ].

	^ text
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> buildStepConfigLayout [
	"Build the configuration panel for a selected step"

	^ SpBoxLayout newTopToBottom
		spacing: 8;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: 'Step Label:' expand: false;
			add: stepLabelInput;
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: 'Agent:' expand: false;
			add: agentDropList;
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: 'Model:' expand: false;
			add: modelDropList;
			addLast: refreshModelsButton expand: false;
			yourself) expand: false;
		add: (SpBoxLayout newTopToBottom
			spacing: 4;
			add: 'Custom System Prompt (optional):' expand: false;
			add: systemPromptInput;
			yourself);
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> connectPresenters [

	enabledCheckBox whenChangedDo: [ :state |
		model multivers enabled: state.
		self saveMultivers.
		self updateChainPreview ].

	stepsList whenSelectedItemChangedDo: [ :item |
		selectedStep := item.
		self updateStepConfigPanel ].

	addStepButton action: [ self onAddStep ].
	removeStepButton action: [ self onRemoveStep ].
	moveUpButton action: [ self onMoveStepUp ].
	moveDownButton action: [ self onMoveStepDown ].

	agentDropList whenSelectedItemChangedDo: [ :assoc |
		self onAgentChanged: assoc ].

	modelDropList whenSelectedItemChangedDo: [ :modelName |
		self onModelChanged: modelName ].

	stepLabelInput whenTextChangedDo: [ :text |
		self onStepLabelChanged: text ].

	systemPromptInput whenTextChangedDo: [ :text |
		self onSystemPromptChanged: text ].

	refreshModelsButton action: [ self refreshModelsForSelectedAgent ].

	templateInput whenTextChangedDo: [ :text |
		model multivers chainPromptTemplate: text.
		self saveMultivers ]
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 10;
		add: enabledCheckBox expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: 'Agent Chain:' expand: false;
			addLast: (SpBoxLayout newLeftToRight
				spacing: 4;
				add: addStepButton expand: false;
				add: removeStepButton expand: false;
				add: moveUpButton expand: false;
				add: moveDownButton expand: false;
				yourself) expand: false;
			yourself) expand: false;
		add: (SpPanedLayout newLeftToRight
			positionOfSlider: 35 percent;
			add: stepsList;
			add: (SpBoxLayout newTopToBottom
				spacing: 8;
				add: 'Step Configuration:' expand: false;
				add: stepConfigPanel;
				yourself);
			yourself);
		add: (SpBoxLayout newTopToBottom
			spacing: 4;
			add: 'Chain Prompt Template ({previousOutput}, {userPrompt}):' expand: false;
			add: templateInput height: 80;
			yourself) expand: false;
		add: (SpBoxLayout newTopToBottom
			spacing: 4;
			add: 'Chain Preview:' expand: false;
			add: chainPreviewText height: 150;
			yourself) expand: false;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> initializePresenters [

	super initializePresenters.

	enabledCheckBox := self newCheckBox
		label: 'Enable Multivers Mode (chain multiple agents together)';
		state: model multivers enabled;
		yourself.

	stepsList := self newTable
		addColumn: (SpStringTableColumn
			title: '#'
			evaluated: [ :step | step order asString ]);
		addColumn: (SpStringTableColumn
			title: 'Agent'
			evaluated: [ :step | step agentDisplayName ]);
		addColumn: (SpStringTableColumn
			title: 'Model'
			evaluated: [ :step | step model ifEmpty: [ '(default)' ] ]);
		items: model multivers steps;
		yourself.

	addStepButton := self newButton
		label: '+';
		icon: (self iconNamed: #add);
		help: 'Add a new agent step to the chain';
		yourself.

	removeStepButton := self newButton
		label: '-';
		icon: (self iconNamed: #remove);
		help: 'Remove the selected step from the chain';
		yourself.

	moveUpButton := self newButton
		label: '';
		icon: (self iconNamed: #up);
		help: 'Move step up in the chain (earlier execution)';
		yourself.

	moveDownButton := self newButton
		label: '';
		icon: (self iconNamed: #down);
		help: 'Move step down in the chain (later execution)';
		yourself.

	stepLabelInput := self newTextInput
		placeholder: 'Optional step label...';
		yourself.

	agentDropList := self newDropList
		help: 'Select the agent type for this step';
		items: (self availableAgentClasses collect: [ :cls | cls displayName -> cls ]);
		display: [ :assoc | assoc key ];
		yourself.

	modelDropList := self newDropList
		help: 'Select the model for this agent';
		items: #();
		display: [ :m | m ];
		yourself.

	refreshModelsButton := self newButton
		label: '';
		icon: (self iconNamed: #refresh);
		help: 'Refresh available models for selected agent';
		yourself.

	systemPromptInput := self newText
		placeholder: 'Custom system prompt (leave empty for default)...';
		yourself.

	stepConfigPanel := SpPresenter new
		layout: self buildStepConfigLayout;
		yourself.

	templateInput := self newText
		text: model multivers chainPromptTemplate;
		yourself.

	chainPreviewText := self newText
		beNotEditable;
		text: self buildChainPreview;
		yourself.

	selectedStep := nil.
	isUpdatingUI := false.
	self updateStepConfigPanel
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onAddStep [
	"Add a new step to the chain"

	| newStep |
	newStep := model multivers addStep.
	newStep agentClass: ChatPharoNullAgent.
	self refreshStepsList.
	self saveMultivers.
	stepsList selectItem: newStep.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onAgentChanged: assoc [
	"Handle agent selection change.
	 Skip updates if we're just restoring UI state (isUpdatingUI flag is set)."

	selectedStep ifNil: [ ^ self ].
	assoc ifNil: [ ^ self ].
	isUpdatingUI ifTrue: [ ^ self ].

	selectedStep agentClass: assoc value.
	self refreshModelsForSelectedAgent.
	self refreshStepsList.
	self saveMultivers.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onModelChanged: modelName [
	"Handle model selection change.
	 Skip updates if we're just restoring UI state (isUpdatingUI flag is set)."

	selectedStep ifNil: [ ^ self ].
	modelName ifNil: [ ^ self ].
	isUpdatingUI ifTrue: [ ^ self ].

	selectedStep model: modelName.
	self refreshStepsList.
	self saveMultivers.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onMoveStepDown [
	"Move selected step down in the chain"

	selectedStep ifNil: [ ^ self ].
	model multivers moveStepDown: selectedStep.
	self refreshStepsList.
	self saveMultivers.
	stepsList selectItem: selectedStep.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onMoveStepUp [
	"Move selected step up in the chain"

	selectedStep ifNil: [ ^ self ].
	model multivers moveStepUp: selectedStep.
	self refreshStepsList.
	self saveMultivers.
	stepsList selectItem: selectedStep.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onRemoveStep [
	"Remove the selected step from the chain"

	selectedStep ifNil: [ ^ self ].
	model multivers removeStep: selectedStep.
	selectedStep := nil.
	self refreshStepsList.
	self saveMultivers.
	self updateStepConfigPanel.
	self updateChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onStepLabelChanged: text [
	"Handle step label change"

	selectedStep ifNil: [ ^ self ].
	selectedStep label: text.
	self saveMultivers
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> onSystemPromptChanged: text [
	"Handle system prompt change"

	selectedStep ifNil: [ ^ self ].
	selectedStep customSystemPrompt: text.
	self saveMultivers
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> refreshModelsForSelectedAgent [
	"Refresh the models dropdown for the selected agent type"

	| agentClass models |
	selectedStep ifNil: [
		modelDropList items: #().
		^ self ].

	agentClass := selectedStep agentClass.
	models := [ agentClass modelNames ] on: Error do: [ #() ].

	modelDropList items: models.

	selectedStep model ifNotEmpty: [
		(models includes: selectedStep model)
			ifTrue: [ modelDropList selectItem: selectedStep model ]
			ifFalse: [ models ifNotEmpty: [ modelDropList selectFirst ] ] ]
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> refreshStepsList [
	"Refresh the steps table"

	stepsList items: model multivers steps
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> saveMultivers [
	"Save the multivers configuration"

	model multivers: model multivers.
	ChatPharoSettings saveDefault
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> setModelBeforeInitialization: aSettings [

	model := aSettings
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> updateChainPreview [
	"Update the chain preview text"

	chainPreviewText text: self buildChainPreview
]

{ #category : 'as yet unclassified' }
ChatPharoMultiversPresenter >> updateStepConfigPanel [
	"Update the step configuration panel based on selected step.
	 Uses isUpdatingUI flag to prevent event handlers from triggering saves."

	selectedStep ifNil: [
		stepLabelInput text: ''.
		systemPromptInput text: ''.
		agentDropList resetSelection.
		modelDropList items: #().
		^ self ].

	"Set guard to prevent event handlers from triggering during UI restore"
	isUpdatingUI := true.
	[
		stepLabelInput text: selectedStep label.
		systemPromptInput text: selectedStep customSystemPrompt.

		"Select the correct agent in dropdown"
		agentDropList items do: [ :assoc |
			assoc value = selectedStep agentClass ifTrue: [
				agentDropList selectItem: assoc ] ].

		self refreshModelsForSelectedAgent.

		"Select the correct model"
		selectedStep model ifNotEmpty: [
			(modelDropList items includes: selectedStep model)
				ifTrue: [ modelDropList selectItem: selectedStep model ] ]
	] ensure: [ isUpdatingUI := false ]
]
