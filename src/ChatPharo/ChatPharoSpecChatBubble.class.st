Class {
	#name : 'ChatPharoSpecChatBubble',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'roleText',
		'contentArea'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatBubble class >> from: aMessage [

	^ self basicNew
		setModelBeforeInitialization: aMessage;
		initialize;
		yourself
]

{ #category : 'layout' }
ChatPharoSpecChatBubble >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: self model role expand: false;
		  "add: roleText expand: false;"add: contentArea
		  withConstraints: [ :constraints | 
			constraints height: (self class inputTextHeight) * 4 ];
		  yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatBubble >> initializePresenters [
	"roleText := self newText .
	roleText text: self model role.
	roleText editable: false."

	contentArea := MicrodownPresenter new.
	contentArea document: (Microdown parse: self model content)
]
