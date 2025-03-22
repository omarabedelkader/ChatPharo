Class {
	#name : 'ChatPharoSpecChatHistoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> setUp [  
    super setUp.
    history := ChatPharoSpecChatHistory from: OrderedCollection new.
    history initializePresenters.  
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> tearDown [  
    history := nil.
    super tearDown.
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> testAddMessage [  
    | message |
    message := LLMAPIChatObjectMessage role: 'user' content: 'Testing'.

    history addMessage: message.
    history initializePresenters.  

    self assert: (history model includes: message).
    self assert: history panel children size equals: 1.
    self assert: (history panel children first model) equals: message.
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> testInitializeWithExistingMessages [  
    | messages newHistory |
    messages := OrderedCollection new
        add: (LLMAPIChatObjectMessage role: 'user' content: 'Hi');
        add: (LLMAPIChatObjectMessage role: 'assistant' content: 'Hello!');
        yourself.

    newHistory := ChatPharoSpecChatHistory from: messages.
    newHistory initializePresenters.  " Ensure messages load in UI "

    self assert: newHistory model size equals: 2.
    self assert: newHistory panel children size equals: 2.
    self assert: (newHistory panel children first model) equals: messages first.
    self assert: (newHistory panel children last model) equals: messages last.
]

{ #category : 'running' }
ChatPharoSpecChatHistoryTest >> testScrollToBottom [  
    self shouldnt: [ history scrollToBottom ] raise: Error.
]
