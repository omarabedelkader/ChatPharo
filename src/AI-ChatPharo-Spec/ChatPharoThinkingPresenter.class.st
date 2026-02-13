Class {
	#name : 'ChatPharoThinkingPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'statusLabel',
		'dotsLabel',
		'animationProcess',
		'currentPhase',
		'showDetailsButton',
		'thinkingContent',
		'thinkingStartedAt',
		'thinkingElapsedSeconds',
		'metricsLabel',
		'stopReasoningButton',
		'modelName',
		'inputTokens',
		'outputTokens',
		'tokensPerSecond',
		'onStopReasoning'
	],
	#category : 'AI-ChatPharo-Spec-Ethics',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Ethics'
}

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> agent [
	"Get the agent from the owner chat presenter's model"
	| chatPresenter chatModel |
	
	chatPresenter := self owner.
	
	"Navigate up the presenter hierarchy to find ChatPharoChatPresenter"
	[ chatPresenter isNotNil and: [ chatPresenter class name ~= #ChatPharoChatPresenter ] ] 
		whileTrue: [ chatPresenter := chatPresenter owner ].
	
	chatPresenter ifNil: [ ^ nil ].
	
	"Access the model slot directly since there's no public getter"
	chatModel := chatPresenter instVarNamed: 'model'.
	
	^ chatModel ifNotNil: [ chatModel agent ]
]

{ #category : 'layout' }
ChatPharoThinkingPresenter >> defaultLayout [

	| layout |
	layout := SpBoxLayout newHorizontal
		          spacing: 5;
		          vAlignCenter;
		          add: statusLabel expand: false;
		          add: dotsLabel expand: false;
		add: metricsLabel;
		add: stopReasoningButton expand: false;
		          yourself. 
	self shouldShowThinkingUI ifTrue: [ layout add: showDetailsButton expand: false ].

	^ layout
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> formattedElapsedThinkingTime [
	"Format elapsed thinking time in minutes and seconds"

	| minutes secondsLabel totalSeconds |
	totalSeconds := thinkingElapsedSeconds.
	minutes := totalSeconds // 60.
	secondsLabel := totalSeconds \\ 60.

	^ String streamContents: [ :stream |
		stream
			nextPutAll: minutes asString;
			nextPutAll: ' min ';
			nextPutAll: secondsLabel asString;
			nextPutAll: ' sec (';
			nextPutAll: totalSeconds asString;
			nextPutAll: 's total)' ]
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> initialize [

	super initialize.
	currentPhase := #thinking.
	thinkingStartedAt := nil.
	thinkingElapsedSeconds := 0.
	modelName := ''.
	inputTokens := 0.
	outputTokens := 0.
	tokensPerSecond := 0.
	onStopReasoning := [ ]
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> initializePresenters [

	statusLabel := self newLabel
		               label: 'Thinking';
		               yourself.
	dotsLabel := self newLabel
		             label: '';
		             yourself.
		metricsLabel := self newLabel
		               label: '';
		               yourself.
	stopReasoningButton := self newButton
		                     label: 'Stop reasoning';
		                     action: [ self stopReasoningRequested ];
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

{ #category : 'accessing' }
ChatPharoThinkingPresenter >> onStopReasoning: aBlock [

	onStopReasoning := aBlock ifNil: [ [ ] ]
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> openThinkingDetails [
	"Open a new window to display the detailed thinking content"
	| detailPresenter |
	
	"Don't open if agent doesn't support thinking"
	self shouldShowThinkingUI ifFalse: [ ^ self ].
	
	detailPresenter := ChatPharoThinkingDetailPresenter new.
	detailPresenter thinkingContent: self thinkingContent.
	detailPresenter open
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> phase: aSymbol [
	"Set the current phase and update display.
	Valid phases: #thinking, #executing, #analyzing, #searching, #finished"

	currentPhase := aSymbol.
	aSymbol = #finished ifTrue: [ self updateElapsedThinkingTime ].
	self updateStatusLabel
]

{ #category : 'accessing' }
ChatPharoThinkingPresenter >> responseMessage: aMessage [

	modelName := (aMessage respondsTo: #modelName)
		ifTrue: [ aMessage modelName ]
		ifFalse: [ '' ].
	inputTokens := (aMessage respondsTo: #inputTokens)
		ifTrue: [ aMessage inputTokens ]
		ifFalse: [ 0 ].
	outputTokens := (aMessage respondsTo: #outputTokens)
		ifTrue: [ aMessage outputTokens ]
		ifFalse: [ 0 ].
	tokensPerSecond := (aMessage respondsTo: #tokensPerSecond)
		ifTrue: [ aMessage tokensPerSecond ]
		ifFalse: [ 0 ].
	self updateStatusLabel
]

{ #category : 'asserting' }
ChatPharoThinkingPresenter >> shouldShowThinkingUI [
	"Only show thinking UI if we have an agent that supports it"
	
	^ self agent isNotNil and: [ self agent supportsThinkingContent ]
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> startAnimation [
	"Start the animated dots"

	animationProcess ifNotNil: [ animationProcess terminate ].
	thinkingStartedAt := DateAndTime now.
	thinkingElapsedSeconds := 0.
	animationProcess := [
		                    | dots |
		                    dots := 0.
		                    [ true ] whileTrue: [
				                    dots := dots + 1 \\ 4.
				                    dotsLabel label: ('.' repeat: dots).
				self updateElapsedThinkingTime.
				                    self updateStatusLabel.
				                    (Delay forMilliseconds: 400) wait ] ] fork
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> stopAnimation [
	"Stop the animated dots"

	animationProcess ifNotNil: [
			animationProcess terminate.
			animationProcess := nil ].
	dotsLabel label: ''.
	metricsLabel label: ''
]

{ #category : 'accessing' }
ChatPharoThinkingPresenter >> stopReasoningRequested [

	onStopReasoning value
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
ChatPharoThinkingPresenter >> updateElapsedThinkingTime [
	"Capture how long thinking took so we can show it when finished"

	thinkingStartedAt ifNil: [
		thinkingElapsedSeconds := 0.
		^ self ].

	thinkingElapsedSeconds := (((DateAndTime now - thinkingStartedAt) asSeconds rounded) max: 0)
]

{ #category : 'initialization' }
ChatPharoThinkingPresenter >> updateStatusLabel [
	"Update the status label based on current phase"

	| text elapsedText |
	elapsedText := thinkingElapsedSeconds asString , ' sec'.
	text := currentPhase
		        caseOf: {
				        ([ #thinking ] -> [ 'Thinking (' , elapsedText , ')' ]).
				        ([ #executing ] -> [ 'Executing tools (' , elapsedText , ')' ]).
				        ([ #analyzing ] -> [ 'Analyzing (' , elapsedText , ')' ]).
				        ([ #searching ] -> [ 'Searching code (' , elapsedText , ')' ]).
				        ([ #finished ] -> [ 'End of thinking (' , self formattedElapsedThinkingTime , ')' ]) }
		        otherwise: [ 'Thinking' ].
	statusLabel label: text.
	metricsLabel label: self usageSummary
]

{ #category : 'accessing' }
ChatPharoThinkingPresenter >> usageSummary [

	^ String streamContents: [ :stream |
		modelName ifNotNil: [
			modelName asString trimBoth ifNotEmpty: [
				stream
					nextPutAll: 'Model: ';
					nextPutAll: modelName asString;
					nextPutAll: ' | ' ] ].
		stream
			nextPutAll: 'Sent: ';
			nextPutAll: inputTokens asString;
			nextPutAll: ' tok | Received: ';
			nextPutAll: outputTokens asString;
			nextPutAll: ' tok | ';
			nextPutAll: 'Speed: ';
			nextPutAll: ((tokensPerSecond ifNil: [ 0 ]) asFloat printShowingDecimalPlaces: 1);
			nextPutAll: ' tok/s' ]
]
