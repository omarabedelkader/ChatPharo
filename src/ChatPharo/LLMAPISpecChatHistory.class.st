Class {
	#name : 'LLMAPISpecChatHistory',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'panel'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
LLMAPISpecChatHistory class >> from: messages [

	^ self basicNew
		setModelBeforeInitialization: messages;
		initialize;
		yourself
]

{ #category : 'initialization' }
LLMAPISpecChatHistory >> addMessage: aMessage [

	self model add: aMessage.
	panel add: (LLMAPISpecChatBubble from: aMessage)
]

{ #category : 'layout' }
LLMAPISpecChatHistory >> defaultLayout [

	^ SpScrollableLayout with: panel
]

{ #category : 'initialization' }
LLMAPISpecChatHistory >> initializePresenters [

	panel := SpBoxLayout newTopToBottom.

	self model do: [ :message |
		panel add: (LLMAPISpecChatBubble from: message) expand: true]
]
