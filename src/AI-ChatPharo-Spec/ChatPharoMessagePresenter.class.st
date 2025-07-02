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
		'badFeedbackButton'
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

	^ SpBoxLayout newVertical
		  add: 'User' expand: false;
		  add: contentPresenter expand: true;
		  add: model assistantLabel expand: false;
		  add: answerPresenter expand: true;
	                  add: (SpBoxLayout newHorizontal
                               spacing: 5;
                               add: goodFeedbackButton;
                               add: badFeedbackButton;
                               yourself) expand: false;
		  yourself
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
		                     yourself
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
