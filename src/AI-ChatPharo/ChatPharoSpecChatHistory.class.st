"
### `ChatPharoSpecChatHistory` Class
Maintains and displays the history of chat messages.

- **`from:`**: Factory method to create a history panel from a collection of messages.
- **`addMessage:`**: Adds a message to the history and updates the display.
- **`defaultLayout`**: Defines the scrolling layout for the history.
- **`initializePresenters`**: Initializes the panel that will hold the chat bubbles.
"
Class {
	#name : 'ChatPharoSpecChatHistory',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'panel'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatHistory class >> from: messages [

	^ self basicNew
		setModelBeforeInitialization: messages;
		initialize;
		yourself
]

{ #category : 'initialization' }
ChatPharoSpecChatHistory >> addMessage: aMessage [

	self model add: aMessage.
	panel add: (ChatPharoSpecChatBubble from: aMessage)
]

{ #category : 'layout' }
ChatPharoSpecChatHistory >> defaultLayout [

	^ SpScrollableLayout with: panel
]

{ #category : 'initialization' }
ChatPharoSpecChatHistory >> initializePresenters [

	panel := SpBoxLayout newTopToBottom.

	self model do: [ :message |
		panel add: (ChatPharoSpecChatBubble from: message) expand: true]
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel [

	^ panel
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel: anObject [

	panel := anObject
]
