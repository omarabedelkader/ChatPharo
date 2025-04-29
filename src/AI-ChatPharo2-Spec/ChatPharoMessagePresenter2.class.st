"
(ChatPharoMessage2 new

	content: 'Bonjour';
	answer: 'Salut';
	yourself) presenter open
"
Class {
	#name : 'ChatPharoMessagePresenter2',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'contentPresenter',
		'answerPresenter'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'initialization' }
ChatPharoMessagePresenter2 >> connectPresenters [

	contentPresenter document: (Microdown parse: model content).
	answerPresenter document: (Microdown parse: model answer)
]

{ #category : 'layout' }
ChatPharoMessagePresenter2 >> defaultLayout [

	^ SpBoxLayout newVertical
		add: 'User' expand: false;
		add: contentPresenter;
		add: 'Assistant' expand: false;
		add: answerPresenter;
		yourself
]

{ #category : 'layout' }
ChatPharoMessagePresenter2 >> initializePresenters [ 

	contentPresenter := MicrodownPresenter new.
	answerPresenter := MicrodownPresenter new.
]

{ #category : 'layout' }
ChatPharoMessagePresenter2 >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Message presenter';
		initialExtent: 400@200
]

{ #category : 'accessing - model' }
ChatPharoMessagePresenter2 >> setModelBeforeInitialization: anObject [

	model := anObject
]
