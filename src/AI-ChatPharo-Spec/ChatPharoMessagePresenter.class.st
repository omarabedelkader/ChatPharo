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
	answerPresenter document: (Microdown parse: model answer).
	goodFeedbackButton action: [ model feedback: true ].
	badFeedbackButton action: [ model feedback: false ]
]

{ #category : 'layout' }
ChatPharoMessagePresenter >> defaultLayout [
    | layout answerContainer |

    answerContainer := SpOverlayLayout new.
    answerContainer
        child: answerPresenter;
        addOverlay: copyButton withConstraints: [ :c |
            c vAlignStart;
              hAlignEnd ].

    answerPresenter eventHandler
		whenMouseEnterDo: [ :evt | copyButton visible: true ];
		whenMouseLeaveDo: [ :evt | copyButton visible: false ].

    layout := SpBoxLayout newVertical
        add: 'User' expand: false;
        add: contentPresenter expand: true;
        add: model assistantLabel expand: false;
        add: answerContainer expand: true.

    ChatPharoSettings default feedbackButtonsEnabled ifTrue: [
        layout add: (SpBoxLayout newHorizontal
            spacing: 5;
            add: goodFeedbackButton;
            add: badFeedbackButton;
            yourself) expand: false
    ].

    ^ layout yourself
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
	| baseHeight lineHeight contentLines answerLines |
	baseHeight := 64.
	lineHeight := 24.
	contentLines := self estimatedLineCountFor: model content.
	answerLines := self estimatedLineCountFor: model answer.
	^ baseHeight + ((contentLines + answerLines) * lineHeight)
]

{ #category : 'initialization' }
ChatPharoMessagePresenter >> initializePresenters [

	contentPresenter := MicrodownPresenter new.
	answerPresenter := MicrodownPresenter new.
	goodFeedbackButton := self newButton
		                      label: 'Good';
		                      help: 'Mark code as valid';
		                      yourself.
	badFeedbackButton := self newButton
		                     label: 'Bad';
		                     help: 'Mark code as invalid';
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

	copyButton visible: false.
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
