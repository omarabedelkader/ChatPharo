"
a mock class
"
Class {
	#name : 'MockAdapter',
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
MockAdapter >> getResponse [ 

    ^ nextReplyString
]

{ #category : 'initialization' }
MockAdapter >> initialize [ 

    super initialize.
    nextReplyString := 'MOCK'.
]

{ #category : 'initialization' }
MockAdapter >> lastPrompt [ 

    ^ lastPrompt
]

{ #category : 'initialization' }
MockAdapter >> lastSystem [ 

    ^ lastSystem
]

{ #category : 'initialization' }
MockAdapter >> nextReply: aString [ 

    nextReplyString := aString.
    ^ self
]

{ #category : 'initialization' }
MockAdapter >> prompt: aString [ 

    lastPrompt := aString
]

{ #category : 'initialization' }
MockAdapter >> systemPrompt: aString [ 

    lastSystem := aString
]
