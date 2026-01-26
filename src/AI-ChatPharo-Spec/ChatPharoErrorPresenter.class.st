"
Displays backend/network errors in the transcript.
Similar to ChatPharoThinkingPresenter but for error messages.
"
Class {
	#name : 'ChatPharoErrorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'iconLabel',
		'errorLabel',
		'dismissButton',
		'errorMessage'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'layout' }
ChatPharoErrorPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		spacing: 8;
		vAlignCenter;
		add: iconLabel expand: false;
		add: errorLabel;
		add: dismissButton expand: false;
		yourself
]

{ #category : 'layout' }
ChatPharoErrorPresenter >> errorMessage [

	^ errorMessage
]

{ #category : 'layout' }
ChatPharoErrorPresenter >> errorMessage: aString [

	errorMessage := aString.
	self updateErrorLabel
]

{ #category : 'initialization' }
ChatPharoErrorPresenter >> initialize [

	super initialize.
	errorMessage := 'An error occurred'
]

{ #category : 'initialization' }
ChatPharoErrorPresenter >> initializePresenters [

	iconLabel := self newLabel
		label: '[Error]';
		yourself.
	errorLabel := self newLabel
		label: 'An error occurred';
		yourself.
	dismissButton := self newButton
		label: 'Dismiss';
		yourself
]

{ #category : 'initialization' }
ChatPharoErrorPresenter >> updateErrorLabel [

	errorLabel label: errorMessage
]

{ #category : 'initialization' }
ChatPharoErrorPresenter >> whenDismissedDo: aBlock [

	dismissButton action: aBlock
]
