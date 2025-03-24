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
ChatPharoSpecChatTest >> fakeLocalModelResponse [

	| userContent |
	userContent := chat inputField text.
	chat history addMessage: (
		LLMAPIChatObjectMessage
			role: 'user'
			content: userContent).
	chat history addMessage: (
		LLMAPIChatObjectMessage
			role: 'ChatPharo'
			content: 'Fake local model response').
	chat inputField text: ''
]

{ #category : 'running' }
ChatPharoSpecChatTest >> setUp [

    super setUp.
    chat := ChatPharoSpecChat new.
    chat initializePresenters. 
]

{ #category : 'running' }
ChatPharoSpecChatTest >> tearDown [

    chat := nil.
    super tearDown.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testAddMessage [

    | message |

    message := LLMAPIChatObjectMessage 
        role: 'user' 
        content: 'Test message'.
    
    chat history addMessage: message.
    
    self assert: chat history model size equals: 1.
    self assert: chat history model first equals: message.

]

{ #category : 'running' }
ChatPharoSpecChatTest >> testAskLocalModel [

" This test won't work in the CI because we are the not the admin of the env. BUT it must pass if you downlaod the Ollama correctly "

"
	| userMessage responseMessage |

	chat 
		when: #askLocalModel
		send: #fakeLocalModelResponse
		to: self.

	chat inputField text: 'Hello LLM'.
	chat askLocalModel. 
	
	self assert: chat history model size equals: 2.
	
	userMessage := chat history model first.
	responseMessage := chat history model second.

	self assert: userMessage role equals: 'user'.
	self assert: responseMessage role equals: 'ChatPharo'.
	self assert: chat inputField text isEmpty
"
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
    
    self assert: chat history model size = 1.

    chat history model removeAll.
    chat history update.  

    self assert: chat history model isEmpty 
        description: ('Expected empty but found: ', chat history model size asString).
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInitialState [

    self assert: chat inputField text isEmpty.
    self assert: chat history model isEmpty.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInputFieldExists [

    self assert: chat inputField notNil.
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testSubmitButtonExists [

    self assert: chat submitButton notNil.
]
