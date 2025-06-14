"
UI for one chat tab: scrollable message column, a text field, and buttons for submit/cancel/clear. Receives push updates when the model posts a new assistant message.
"
Class {
	#name : 'ChatPharoChatPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messagesLayout',
		'messageTextField',
		'submitButton',
		'cancelButton',
		'clearButton',
		'model',
		'inspectButton'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoChatPresenter >> connectPresenters [

	messageTextField whenSubmitDo: [ :text | self sendMessage ].
	submitButton action: [ self sendMessage. ].
	cancelButton action: [ model cancelMessage ].
	clearButton action: [ 
		model messages do: [ :p | 
			messagesLayout remove: p
		].
		model clearChat.
		
	].
	inspectButton action: [ model inspect ].
	
	model whenAnswerReceivedDo: [ :message | 
		messagesLayout add: message presenter	
	]
]

{ #category : 'layout' }
ChatPharoChatPresenter >> defaultLayout [
    ^ SpBoxLayout newVertical
          spacing: 10;
          add: (SpScrollableLayout with: messagesLayout);
          add: (SpBoxLayout newHorizontal
                   spacing: 5;
                   add: messageTextField;
                   add: submitButton expand: false;
                   add: cancelButton expand: false;
						 add: inspectButton expand: false;
                   yourself)
          expand: false;
          yourself
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializePresenters [

	messageTextField := self newTextInput
		                    placeholder: 'Type your message here...';
		                    yourself.

	submitButton := self newButton
		                label: 'Submit';
		                icon: (self iconNamed: #glamorousGo);
		                help: 'Submit prompt';
		                yourself.

	cancelButton := self newButton
		                label: 'Cancel';
		                icon: (self iconNamed: #delete);
		                help: 'Cancel prompt';
		                yourself.

	clearButton := self newButton
		               label: 'Clear Chat';
		               icon: (self iconNamed: #glamorousTrash);
		               help: 'Clear chat history';
		               yourself.
		
	inspectButton := self newButton
		               label: 'Inspect';
		               icon: (self iconNamed: #inspect);
		               help: 'Inspect the chat object';
		               yourself.

	messagesLayout := SpBoxLayout newVertical.
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Pharo chat';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> sendMessage [

	model sendMessage: messageTextField text.
	messageTextField text:''
]

{ #category : 'accessing - model' }
ChatPharoChatPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
