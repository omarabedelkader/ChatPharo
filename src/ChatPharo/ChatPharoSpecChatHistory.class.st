Class {
	#name : 'ChatPharoSpecChatHistory',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'panel'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
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
