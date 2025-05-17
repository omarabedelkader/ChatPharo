Class {
	#name : 'ChatPharoChatPresenter2',
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
ChatPharoChatPresenter2 >> connectPresenters [

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

{ #category : 'layout' }
ChatPharoChatPresenter2 >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (SpScrollableLayout with: messagesLayout);
		  add: (SpBoxLayout newHorizontal
				   spacing: 5;
				   add: messageTextField;
				   add: submitButton expand: false;
				   add: cancelButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'initialization' }
ChatPharoChatPresenter2 >> initializePresenters [

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

	messagesLayout := SpBoxLayout newVertical
]

{ #category : 'initialization' }
ChatPharoChatPresenter2 >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Pharo chat';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoChatPresenter2 >> sendMessage [
    | originalText |

    originalText := messageTextField text.

    messageTextField
        text: 'Sending...';
        enabled: false.

    [ 
        model sendMessage: originalText.
        UIManager default defer: [
		messageTextField
			text: '';
			enabled: true;
			takeKeyboardFocus.
	    ]
    ] forkAt: Processor userBackgroundPriority.
]

{ #category : 'accessing - model' }
ChatPharoChatPresenter2 >> setModelBeforeInitialization: anObject [

	model := anObject
]
