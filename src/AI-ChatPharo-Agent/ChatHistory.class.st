Class {
	#name : 'ChatHistory',
	#superclass : 'Object',
	#instVars : [
		'messages'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'initialization' }
ChatHistory >> addAssistant: text [

    self addMessage: (ChatHistoryMessage role:'assistant' content: text)
]

{ #category : 'initialization' }
ChatHistory >> addMessage: aHistoryMessage [

    messages add: aHistoryMessage
]

{ #category : 'initialization' }
ChatHistory >> addUser: text [ 

    self addMessage: (ChatHistoryMessage role:'user' content: text)
]

{ #category : 'initialization' }
ChatHistory >> asPromptPrefix [ 

    ^ String streamContents:[ :s | messages do:[ :m | m historyStringOn: s ] ]
]

{ #category : 'initialization' }
ChatHistory >> chatMessagesOn: aStream [ 

    messages do:[ :m | m putOpenAIChatMessagesOn: aStream ]
]

{ #category : 'initialization' }
ChatHistory >> clear [

    messages removeAll
]

{ #category : 'initialization' }
ChatHistory >> initialize [

    super initialize.
    messages := OrderedCollection new
]

{ #category : 'initialization' }
ChatHistory >> messages [
 ^ messages 

]
