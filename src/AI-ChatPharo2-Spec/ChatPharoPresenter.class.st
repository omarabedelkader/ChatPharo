Class {
	#name : 'ChatPharoPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messagesLayout',
		'messageTextField',
		'submitButton',
		'cancelButton',
		'clearButton',
		'model'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'initialization' }
ChatPharoPresenter >> connectPresenters [

	messageTextField whenSubmitDo: [ :text | self sendMessage ].
	submitButton action: [ self sendMessage. ].
	cancelButton action: [ model cancelMessage ].
	clearButton action: [ 
		model messages do: [ :p | 
			messagesLayout remove: p
		].
		model clearChat.
		
	].
	
	model whenAnswerReceivedDo: [ :message | 
		messagesLayout add: message presenter	
	]
]

{ #category : 'initialization' }
ChatPharoPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpScrollableLayout with: messagesLayout);
		add: (SpBoxLayout newHorizontal
			add: messageTextField;
			add: submitButton;
			add: cancelButton;
			yourself 
		) expand: false;
		yourself
]

{ #category : 'initialization' }
ChatPharoPresenter >> initializePresenters [

	messageTextField := self newTextInput
			placeholder: 'Type your message here...';
			yourself.
			
	submitButton := self newButton
        label: 'Submit';
        icon: (self iconNamed: #glamorousGo);
        help: 'Submit prompt to Ollama model';
        yourself.

	cancelButton := self newButton
        label: 'Cancel';
        icon: (self iconNamed: #delete);
        help: 'Cancel prompt to Ollama model';
        yourself.

	clearButton := self newButton
        label: 'Clear Chat';
        icon: (self iconNamed: #glamorousTrash);
        help: 'Clear chat history';
        yourself.

	messagesLayout := SpBoxLayout newVertical
]

{ #category : 'initialization' }
ChatPharoPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Pharo chat';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoPresenter >> sendMessage [

	model sendMessage: messageTextField text
]

{ #category : 'initialization' }
ChatPharoPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
