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
		  add: contentPresenter withConstraints: [ :const | const height: (model content lines size) * 42 ];
		  add: 'Assistant' expand: false;
		  add: answerPresenter withConstraints: [ :const | const height: (model answer lines size) * 42 ];
		  yourself
]

{ #category : 'accessing' }
ChatPharoMessagePresenter >> height [
	"64 is User: and Model: labels, then height of content and answer."
	^ 64 + ((model content lines size) * 42 ) + ((model answer lines size) * 42)
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
