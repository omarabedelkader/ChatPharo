"
Renders one ChatPharoMessage using Microdown for rich text.

```smalltalk
(ChatPharoMessage new
	content: 'Bonjour';
	answer: 'Salut';
	yourself) presenter open
```
"
Class {
	#name : 'ChatPharoMessagePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'contentPresenter',
		'thinkingPresenter',
		'answerPresenter',
		'goodFeedbackButton',
		'badFeedbackButton',
		'copyButton'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoMessagePresenter >> connectPresenters [

	contentPresenter document: (Microdown parse: model content).
	thinkingPresenter document: (Microdown parse: model thinking).
	answerPresenter document: (Microdown parse: model answer).
	goodFeedbackButton action: [ model feedback: true ].
	badFeedbackButton action: [ model feedback: false ]
]

{ #category : 'layout' }
ChatPharoMessagePresenter >> defaultLayout [
	| layout answerContainer thinkingContainer contentHeight answerHeight |
	
	"Calculate heights based on content"
	contentHeight := self estimatedHeightFor: model content.
	answerHeight := self estimatedHeightFor: model answer.
	
	answerContainer := SpOverlayLayout new.
	answerContainer
		child: answerPresenter;
		addOverlay: copyButton withConstraints: [ :c |
				c
					vAlignStart;
					hAlignEnd ].
	answerPresenter eventHandler
		whenMouseEnterDo: [ :evt | copyButton visible: true ];
		whenMouseLeaveDo: [ :evt | copyButton visible: false ].
	thinkingContainer := SpBoxLayout newVertical
		                     add: 'Thinking' expand: false;
		                     add: thinkingPresenter expand: true.
	layout := SpBoxLayout newVertical
		          add: 'User' expand: false;
		          add: contentPresenter 
		          	withConstraints: [ :c | c height: contentHeight ];
		          add: model assistantLabel expand: false.
	layout add: answerContainer 
		withConstraints: [ :c | c height: answerHeight ].
	ChatPharoSettings default feedbackButtonsEnabled ifTrue: [
			layout
				add: (SpBoxLayout newHorizontal
						 spacing: 5;
						 add: goodFeedbackButton;
						 add: badFeedbackButton;
						 yourself)
				expand: false ].
	^ layout yourself
]

{ #category : 'accessing' }
ChatPharoMessagePresenter >> estimatedHeightFor: aString [
	"Calculate height needed for text content"

	| text lineCount lineHeight minHeight maxHeight |
	text := aString ifNil: [ '' ].
	lineHeight := 20.
	minHeight := 30.
	maxHeight := 500.

	lineCount := self estimatedLineCountFor: text.
	^ (minHeight max: lineCount * lineHeight) min: maxHeight
]

{ #category : 'accessing' }
ChatPharoMessagePresenter >> estimatedLineCountFor: aString [
	| text wrapWidth |
	text := aString ifNil: [ '' ].
	wrapWidth := 80.
	^ (text lines ifEmpty: [ #('') ]) inject: 0 into: [ :sum :line |
		  sum + (((line size / wrapWidth) ceiling) max: 1) ]
]

{ #category : 'accessing' }
ChatPharoMessagePresenter >> height [
	"Base height for labels plus adaptive line heights for content/answer."

	| baseHeight lineHeight contentLines answerLines thinkingLines |
	baseHeight := 64.
	lineHeight := 24.
	contentLines := self estimatedLineCountFor: model content.
	thinkingLines := model thinking isEmpty
		                 ifTrue: [ 0 ]
		                 ifFalse: [ self estimatedLineCountFor: model thinking ].
	answerLines := self estimatedLineCountFor: model answer.
	^ baseHeight + ((contentLines + thinkingLines + answerLines) * lineHeight)
]

{ #category : 'initialization' }
ChatPharoMessagePresenter >> initializePresenters [

	contentPresenter := MicrodownPresenter new.
	thinkingPresenter := MicrodownPresenter new.
	answerPresenter := MicrodownPresenter new.

	goodFeedbackButton := self newButton
		label: 'Good';
		help: 'Mark code as valid';
		action: [
			model feedback: true.
			self updateFeedbackButtons
		];
		yourself.

	badFeedbackButton := self newButton
		label: 'Bad';
		help: 'Mark code as invalid';
		action: [
			model feedback: false.
			self updateFeedbackButtons
		];
		yourself.

	copyButton := self newButton
		icon: (self iconNamed: #smallCopy);
		label: '';
		help: 'Copy answer to clipboard';
		action: [
			Clipboard clipboardText: (model answer ifNil: [ '' ]).
			UIManager default inform: 'Copied to clipboard'
		];
		yourself.

	copyButton visible: true.
	self updateFeedbackButtons.

]

{ #category : 'layout' }
ChatPharoMessagePresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Message presenter';
		initialExtent: 400@200
]

{ #category : 'accessing - model' }
ChatPharoMessagePresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'updating' }
ChatPharoMessagePresenter >> updateFeedbackButtons [

	| feedback |
	feedback := model feedback.

	goodFeedbackButton enabled: (feedback isNil or: [ feedback not ]).
	badFeedbackButton enabled: (feedback isNil or: [ feedback ]).
]
