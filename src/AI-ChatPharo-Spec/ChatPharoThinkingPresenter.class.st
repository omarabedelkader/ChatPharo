Class {
	#name : 'ChatPharoThinkingPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'statusLabel',
		'dotsLabel',
		'animationProcess',
		'currentPhase'
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
		label: 'Thinking...';
		yourself.
	dotsLabel := self newLabel
		label: '';
		yourself
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> phase: aSymbol [
	"Set the current phase and update display.
	Valid phases: #thinking, #executing, #analyzing, #searching"

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
ChatPharoThinkingPresenter >> updateStatusLabel [
	"Update the status label based on current phase"

	| text |
	text := currentPhase caseOf: {
		[ #thinking ] -> [ 'Thinking...' ].
		[ #executing ] -> [ 'Executing tools...' ].
		[ #analyzing ] -> [ 'Analyzing...' ].
		[ #searching ] -> [ 'Searching code...' ] }
		otherwise: [ '🤔 Thinking' ].
	statusLabel label: text
]
