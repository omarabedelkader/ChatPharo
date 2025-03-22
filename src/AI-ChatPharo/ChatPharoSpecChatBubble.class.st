"### `ChatPharoSpecChatBubble` Class
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
		'contentArea',
		'timestampLabel'
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
		  add: roleText expand: false;
		  add: contentArea
		  withConstraints: [ :constraints | 
			constraints height: (self class inputTextHeight) * 4 ];
		  add: timestampLabel expand: false align: #right;
		  yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatBubble >> initializePresenters [

	contentArea := MicrodownPresenter new.
	contentArea document: (Microdown parse: self model content).

	roleText := SpTextPresenter new.
	roleText text: self model role.

	timestampLabel := SpTextPresenter new.
	timestampLabel text: self model timestamp asString.
	timestampLabel fontStyle: (SpFontStyle size: 10 color: Color gray).
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText [

	^ roleText
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> roleText: anObject [

	roleText := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> timestampLabel [

	^ timestampLabel
]

{ #category : 'accessing' }
ChatPharoSpecChatBubble >> timestampLabel: anObject [

	timestampLabel := anObject
]
