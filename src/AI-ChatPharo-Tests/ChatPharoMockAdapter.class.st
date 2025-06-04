"
a mock class
"
Class {
	#name : 'ChatPharoMockAdapter',
	#superclass : 'Object',
	#instVars : [
		'nextReplyString',
		'lastPrompt',
		'lastSystem'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'initialization' }
ChatPharoMockAdapter >> getResponse [ 

    ^ nextReplyString
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> initialize [ 

    super initialize.
    nextReplyString := 'MOCK'.
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> lastPrompt [ 

    ^ lastPrompt
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> lastSystem [ 

    ^ lastSystem
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> nextReply: aString [ 

    nextReplyString := aString.
    ^ self
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> prompt: aString [ 

    lastPrompt := aString
]

{ #category : 'initialization' }
ChatPharoMockAdapter >> systemPrompt: aString [ 

    lastSystem := aString
]
