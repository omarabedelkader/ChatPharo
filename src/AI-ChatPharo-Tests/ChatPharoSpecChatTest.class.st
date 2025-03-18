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
    chat initializePresenters. "Ensure UI elements are properly initialized"
]

{ #category : 'running' }
ChatPharoSpecChatTest >> tearDown [

    chat := nil.
    super tearDown.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testAddMessage [
    | message |

    "Create a test message"
    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'Test message'.
    
    chat history addMessage: message.
    
    self assert: chat history model size equals: 1.
    self assert: chat history model first equals: message.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInitialState [

    self assert: chat inputField text isEmpty.
    self assert: chat history model isEmpty.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInputFieldExists [

    self assert: chat inputField notNil.
    self assert: chat inputField multiLine.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testSubmitButtonExists [

    self assert: chat submitButton notNil.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testClearButtonExists [

    self assert: chat clearButton notNil.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testClearChat [
    | message |

    "Create a test message"
    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'This is a test message'.
    
    chat history addMessage: message.
    
    self assert: chat history model size equals: 1.

    chat clearChat.
    self assert: chat history model isEmpty.
]