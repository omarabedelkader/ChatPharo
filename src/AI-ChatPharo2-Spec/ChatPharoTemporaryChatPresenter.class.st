"
```smalltalk
| tempChat presenter |
tempChat := ChatPharoTemporaryChat2 new.
tempChat
    onSubmit: [ :text | self inform: 'Submitted: ', text ];
    onCancel: [ self inform: 'Cancelled.' ].

presenter := ChatPharoTemporaryChatPresenter2 on: tempChat.
presenter open
```
"
Class {
	#name : 'ChatPharoTemporaryChatPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'textField',
		'submitButton',
		'cancelButton'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'initialization' }
ChatPharoTemporaryChatPresenter >> connectPresenters [ 

    textField whenSubmitDo: [ model text: textField text. model submit ].
]

{ #category : 'layout' }
ChatPharoTemporaryChatPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: textField;
		  add: (SpBoxLayout newHorizontal
		spacing:5;
				   add: submitButton expand: false;
				   add: cancelButton expand: false ;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoTemporaryChatPresenter >> initializePresenters [ 

    textField := self newTextInput placeholder: 'Enter something...' yourself.

    submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        action: [ model text: textField text. model submit ];
        yourself.

    cancelButton := self newButton
        label: 'Cancel';
        icon: (self iconNamed: #delete);
        action: [ model cancel ];
        yourself.
]

{ #category : 'layout' }
ChatPharoTemporaryChatPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Temporary Chat';
		initialExtent: 800 @ 500
]

{ #category : 'accessing - model' }
ChatPharoTemporaryChatPresenter >> setModelBeforeInitialization: anObject [ 

    model := anObject
]
