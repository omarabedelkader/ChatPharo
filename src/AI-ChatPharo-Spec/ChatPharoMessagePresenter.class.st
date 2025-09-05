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
    | layout answerWithCopy |

    answerWithCopy := SpOverlayLayout new.
    answerWithCopy
        child: answerPresenter;
        addOverlay: copyButton withConstraints: [ :c |
            c vAlignStart;    
            hAlignEnd ].      

    layout := SpBoxLayout newVertical
        add: 'User' expand: false;
        add: contentPresenter expand: true;
        add: model assistantLabel expand: false;
        add: answerWithCopy expand: true.

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
ChatPharoMessagePresenter >> height [
	"64 is User: and Model: labels, then height of content and answer."
	^ 64 + ((model content lines size) * 42 ) + ((model answer lines size) * 42)
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
    answerPresenter widget whenMouseEnter: [ copyButton visible: true ].
    answerPresenter widget whenMouseLeave: [ copyButton visible: false ].
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
