Class {
	#name : 'ChatPharoSpecChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatTest >> setUp [

    super setUp.
    chat := ChatPharoSpecChat new.
    chat initializePresenters. "Ensure all UI elements are properly initialized"
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testAddMessage [
    | history message |
    
    "Set up the history with empty collection"
    history := ChatPharoSpecChatHistory from: OrderedCollection new.
    
    "Create a test message"
    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'Test message'.
    
    "Add the message"
    history addMessage: message.
    
    "Verify the message was added to the model"
    self assert: history model size equals: 1.
    self assert: history model first equals: message.
    
    "Verify the message was added to the panel"
    self assert: history panel children size equals: 1.
    
    "Verify the panel contains a ChatPharoSpecChatBubble"
    self assert: (history panel children first isKindOf: ChatPharoSpecChatBubble).
    
    "Verify the bubble contains the correct message"
    self assert: (history panel children first model) equals: message.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInitialState [
 
    self assert: chat inputField text isEmpty.
    self assert: chat history model isEmpty

]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInputFieldMultiLine [

    "Ensure inputField is set to multi-line mode"
    self assert: chat inputField multiLine.

]

{ #category : 'running' }
ChatPharoSpecChatTest >> testClearButtonExists [

    "Ensure clearButton is initialized properly"
    self assert: chat clearButton notNil.

]

{ #category : 'running' }
ChatPharoSpecChatTest >> testClearChat [

    | message |
    
    "Add a message to the chat history"
    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'This is a test message'.
    
    chat history addMessage: message.
    
    "Ensure the message was added"
    self assert: chat history model size equals: 1.

    "Call clearChat to remove all messages"
    chat clearChat.

    "Ensure the history is empty after clearing"
    self assert: chat history model isEmpty.
]