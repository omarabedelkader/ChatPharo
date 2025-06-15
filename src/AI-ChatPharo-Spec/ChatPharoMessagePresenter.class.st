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
		'answerPresenter'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoMessagePresenter >> connectPresenters [

	contentPresenter document: (Microdown parse: model content).
	answerPresenter document: (Microdown parse: model answer)
]

{ #category : 'layout' }
ChatPharoMessagePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: 'User' expand: false;
		add: contentPresenter expand: true;
		add: 'Assistant' expand: false;
		add: answerPresenter expand: true;
		yourself
]

{ #category : 'layout' }
ChatPharoMessagePresenter >> initializePresenters [ 

	contentPresenter := MicrodownPresenter new.
	answerPresenter := MicrodownPresenter new.
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
