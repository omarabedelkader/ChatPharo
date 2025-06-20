"
TO have ChatPharo more stable this Null agent is implemented to return Null, when there is no agent running in the backend
"
Class {
	#name : 'ChatPharoNullSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'infoLabel'
	],
	#category : 'AI-ChatPharo-Spec-Agent',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Agent'
}

{ #category : 'layout' }
ChatPharoNullSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: infoLabel expand: false;
		  yourself
]

{ #category : 'initialization' }
ChatPharoNullSettingsPresenter >> infoLabel [ 

    ^ infoLabel
]

{ #category : 'initialization' }
ChatPharoNullSettingsPresenter >> infoLabel: anObject [ 

    infoLabel := anObject
]

{ #category : 'initialization' }
ChatPharoNullSettingsPresenter >> initializePresenters [ 

    super initializePresenters.
    infoLabel := self newLabel label: 'Please configure an Agent, by selecting an Agent'.
]
