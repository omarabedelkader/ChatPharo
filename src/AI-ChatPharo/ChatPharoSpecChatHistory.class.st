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
		'spParent',
		'panel'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ChatPharoSpecChatHistory class >> from: messages parent: par [
	^ self basicNew
		spParent: par;
		setModelBeforeInitialization: messages;
		initialize;
		yourself
]

{ #category : 'actions' }
ChatPharoSpecChatHistory >> addMessage: aMessage [
	| chatter |
	self model add: aMessage.
	chatter := ChatPharoSpecChatBubble from: aMessage parent: self spParent .
	chatter spParent: self spParent.
	panel add: chatter 
]

{ #category : 'actions' }
ChatPharoSpecChatHistory >> asPromptPrefix [
	"Should be changed to prefix to not just using string"
	| prefix |
	prefix := WriteStream on: String new.
	self model do: [ :message | 
		message historyStringOn: prefix ].
	^ prefix contents
]

{ #category : 'layout' }
ChatPharoSpecChatHistory >> defaultLayout [

	^ SpScrollableLayout with: panel
]

{ #category : 'initialization' }
ChatPharoSpecChatHistory >> initializePresenters [

	panel := SpBoxLayout newTopToBottom.

	self model do: [ :message |
		panel add: (ChatPharoSpecChatBubble from: message parent: self spParent ) expand: true]
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel [

	^ panel
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> panel: anObject [

	panel := anObject
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> spParent [

	^ spParent
]

{ #category : 'accessing' }
ChatPharoSpecChatHistory >> spParent: anObject [

	spParent := anObject
]
