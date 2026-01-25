"
Progress dialog for applying Advisor default settings.
* Shows a progress bar while configuring defaults
* Displays current step description
* Cannot be closed until configuration is complete
* **Why** - provides visual feedback during configuration process
```smalltalk
ChatPharoDefaultsProgressPresenter openAndApply.
"
Class {
	#name : 'ChatPharoDefaultsProgressPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleLabel',
		'progressBar',
		'statusLabel',
		'isComplete',
		'onComplete'
	],
	#category : 'AI-ChatPharo-Spec-Advisor',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Advisor'
}

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter class >> openAndApply [
	"Open the progress dialog and apply default settings."

	^ self new
		openModal;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter class >> openAndApplyThen: aBlock [
	"Open the progress dialog, apply defaults, then execute the block."

	| presenter |
	presenter := self new.
	presenter onComplete: aBlock.
	presenter openModal.
	^ presenter
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> applyDefaults [
	"Apply the default settings with progress tracking."

	| settings steps totalSteps currentStep |
	settings := ChatPharoSettings default.
	steps := ChatPharoSafetyAdvisor applyDefaultSettingsTo: settings.
	totalSteps := steps size.
	currentStep := 0.

	[
		steps do: [ :stepBlock |
			currentStep := currentStep + 1.
			stepBlock value: [ :message |
				self defer: [
					statusLabel label: message.
					progressBar progress: (currentStep / totalSteps) asFloat ] ].
			50 milliSeconds wait ].

		self defer: [
			isComplete := true.
			statusLabel label: 'Configuration complete!'.
			progressBar progress: 1.0.
			200 milliSeconds wait.
			self window close.
			onComplete ifNotNil: [ onComplete value ] ]
	] fork
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> askOkToClose [
	"Prevent closing while configuration is in progress."

	isComplete ifFalse: [
		self inform: 'Please wait for configuration to complete.'.
		^ false ].
	^ true
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 16;
		borderWidth: 24;
		add: titleLabel expand: false;
		add: progressBar expand: false;
		add: statusLabel expand: false;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> initialize [

	super initialize.
	isComplete := false
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> initializePresenters [

	super initializePresenters.

	titleLabel := self newLabel
		label: 'Applying Advisor Recommended Settings';
		yourself.

	progressBar := self newProgressBar
		progress: 0;
		yourself.

	statusLabel := self newLabel
		label: 'Preparing configuration...';
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'Configuring ChatPharo';
		initialExtent: 400@150;
		centered
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> onComplete: aBlock [
	"Set the block to execute when configuration is complete."

	onComplete := aBlock
]

{ #category : 'as yet unclassified' }
ChatPharoDefaultsProgressPresenter >> openModal [
	"Open as modal dialog and start applying defaults."

	| window |
	window := self open.
	self applyDefaults.
	^ window
]
