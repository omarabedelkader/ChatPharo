Class {
	#name : 'ChatPharoThinkingPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'statusLabel',
		'dotsLabel',
		'animationProcess',
		'currentPhase',
		'showDetailsButton',
		'thinkingContent'
	],
	#category : 'AI-ChatPharo-Spec-Ethics',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Ethics'
}

{ #category : 'layout' }
ChatPharoThinkingPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 5;
		vAlignCenter;
		add: statusLabel expand: false;
		add: dotsLabel expand: false;
		add: showDetailsButton expand: false;
		yourself
]

{ #category : 'layout' }
ChatPharoThinkingPresenter >> initialize [

	super initialize.
	currentPhase := #thinking
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> initializePresenters [

	statusLabel := self newLabel
		               label: 'Thinking';
		               yourself.
	dotsLabel := self newLabel
		             label: '';
		             yourself.
		showDetailsButton := self newButton
		                     label: 'Show Details';
		                     action: [ self openThinkingDetails ];
		                     yourself
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> isFinished [

	^ currentPhase = #finished
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> openThinkingDetails [
	"Open a new window to display the detailed thinking content"

	| detailPresenter |
	detailPresenter := ChatPharoThinkingDetailPresenter new.
	detailPresenter thinkingContent: self thinkingContent.
	detailPresenter open
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> phase: aSymbol [
	"Set the current phase and update display.
	Valid phases: #thinking, #executing, #analyzing, #searching, #finished"

	currentPhase := aSymbol.
	self updateStatusLabel
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> startAnimation [
	"Start the animated dots"

	animationProcess ifNotNil: [ animationProcess terminate ].
	animationProcess := [
		| dots |
		dots := 0.
		[ true ] whileTrue: [
			dots := (dots + 1) \\ 4.
			dotsLabel label: ('.' repeat: dots).
			(Delay forMilliseconds: 400) wait ] ] fork
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> stopAnimation [
	"Stop the animated dots"

	animationProcess ifNotNil: [
		animationProcess terminate.
		animationProcess := nil ].
	dotsLabel label: ''
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> thinkingContent [
	"Return the current thinking content"

	^ thinkingContent ifNil: [ '' ]
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> thinkingContent: aString [
	"Set the thinking content"

	thinkingContent := aString
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> updateStatusLabel [
	"Update the status label based on current phase"

	| text |
	text := currentPhase
		        caseOf: {
		[ #thinking ] -> [ 'Thinking' ].
		[ #executing ] -> [ 'Executing tools' ].
		[ #analyzing ] -> [ 'Analyzing' ].
		[ #searching ] -> [ 'Searching code' ].
		[ #finished ] -> [ 'End of thinking' ] }
		        otherwise: [ 'Thinking' ].
	statusLabel label: text
]
