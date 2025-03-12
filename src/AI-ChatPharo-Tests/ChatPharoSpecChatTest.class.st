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
ChatPharoSpecChatTest >> tearDown [

    chat := nil.

    super tearDown.
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
    
    history addMessage: message.
    
    self assert: history model size equals: 1.
    self assert: history model first equals: message.
    
    self assert: history panel children size equals: 1.
    
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

    self assert: chat clearButton notNil.

]

{ #category : 'running' }
ChatPharoSpecChatTest >> testClearChat [

    | message |
    
    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'This is a test message'.
    
    chat history addMessage: message.
    
    self assert: chat history model size equals: 1.

    chat clearChat.

    self assert: chat history model isEmpty.
]