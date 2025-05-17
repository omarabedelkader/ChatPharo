Class {
	#name : 'Agent',
	#superclass : 'Object',
	#instVars : [
		'adapter',
		'systemPrompt',
		'promptPrefix',
		'response'
	],
	#category : 'AI-ChatPharo2-Agent',
	#package : 'AI-ChatPharo2-Agent'
}

{ #category : 'initialization' }
Agent >> initialize [ 

    super initialize.
    systemPrompt := ''.
    promptPrefix := ''.
    response := ''.
]

{ #category : 'initialization' }
Agent >> response [ 

    ^ response
]

{ #category : 'initialization' }
Agent >> sendPrompt: aPrompt [ 

    | fullPrompt |
    fullPrompt := String streamContents: [ :stream |
        stream nextPutAll: promptPrefix.
        aPrompt ifNotNil: [ stream nextPutAll: ' '; nextPutAll: aPrompt ].
    ].
    
    adapter systemPrompt: systemPrompt.
    adapter prompt: fullPrompt.
    
    response := adapter getResponse.
    ^ response
]

{ #category : 'initialization' }
Agent >> setPromptPrefix: aText [ 

    promptPrefix := aText
]

{ #category : 'initialization' }
Agent >> setSystemPrompt: aText [ 

    systemPrompt := aText
]

{ #category : 'initialization' }
Agent >> useAdapter: anAdapter [ 

    adapter := anAdapter
]

{ #category : 'status' }
Agent >> isConnected [

    ^ adapter isReachable
]