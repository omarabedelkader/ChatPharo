Class {
	#name : 'ChatPharoSpecChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat'
	],
	#category : 'ChatPharo-Tests',
	#package : 'ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatTest >> setUp [

    super setUp.
    chat := ChatPharoSpecChat new
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
