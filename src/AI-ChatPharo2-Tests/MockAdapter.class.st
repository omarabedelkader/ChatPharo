Class {
	#name : 'MockAdapter',
	#superclass : 'Object',
	#instVars : [
		'nextReplyString',
		'lastPrompt',
		'lastSystem'
	],
	#category : 'AI-ChatPharo2-Tests-Agent',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Agent'
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
