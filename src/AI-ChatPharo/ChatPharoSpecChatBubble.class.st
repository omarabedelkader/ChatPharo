"
### `ChatPharoSpecChatBubble` Class
Visual presentation for individual chat messages as bubbles.

- **`from:`**: Factory method to create a chat bubble from a message.
- **`defaultLayout`**: Arranges the content within the bubble.
- **`initializePresenters`**: Sets up the text display inside the bubble.
"
Class {
	#name : 'ChatPharoSpecChatBubble',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'roleText',
		'contentArea'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatBubble class >> from: aMessage [

	^ self basicNew
		setModelBeforeInitialization: aMessage;
		initialize;
		yourself
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> contentArea [

	^ contentArea
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> contentArea: anObject [

	contentArea := anObject
]

{ #category : 'layout' }
ChatPharoSpecChatBubble >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: self model role expand: false;
		  add: contentArea
		  withConstraints: [ :constraints | 
			constraints height: (self class inputTextHeight) * 4 ];
		  yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatBubble >> initializePresenters [

	"Initialize the role text presenter with proper styling"
	roleText := SpLabelPresenter new.
	roleText text: self model role.
	self applyRoleStyling.

	"Initialize content area to render message text"
	contentArea := MicrodownPresenter new.
	contentArea document: (Microdown parse: self model content)
]

{ #category : 'private' }
ChatPharoSpecChatBubble >> applyRoleStyling [

	"Apply different styles for user and AI messages"
	(self model role asLowercase = 'user')
		ifTrue: [ roleText fontColor: Color blue ]
		ifFalse: [ roleText fontColor: Color green ].
]


{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText [

	^ roleText
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText: anObject [

	roleText := anObject
]
