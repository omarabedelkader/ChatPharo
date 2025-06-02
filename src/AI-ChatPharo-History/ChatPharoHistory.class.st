"
Ordered collection of ChatPharoHistoryMessage objects; can dump itself as a plain “role: content” string (asPromptPrefix) or the full JSON structure OpenAI expects (chatMessagesOn:).
"
Class {
	#name : 'ChatPharoHistory',
	#superclass : 'Object',
	#instVars : [
		'messages'
	],
	#category : 'AI-ChatPharo-History',
	#package : 'AI-ChatPharo-History'
}

{ #category : 'initialization' }
ChatPharoHistory >> addAssistant: text [

    self addMessage: (ChatPharoHistoryMessage role:'assistant' content: text)
]

{ #category : 'initialization' }
ChatPharoHistory >> addMessage: aHistoryMessage [

    messages add: aHistoryMessage
]

{ #category : 'initialization' }
ChatPharoHistory >> addUser: text [ 

    self addMessage: (ChatPharoHistoryMessage role:'user' content: text)
]

{ #category : 'initialization' }
ChatPharoHistory >> asPromptPrefix [ 

    ^ String streamContents:[ :s | messages do:[ :m | m historyStringOn: s ] ]
]

{ #category : 'initialization' }
ChatPharoHistory >> chatMessagesOn: aStream [ 

    messages do:[ :m | m putOpenAIChatMessagesOn: aStream ]
]

{ #category : 'initialization' }
ChatPharoHistory >> clear [

    messages removeAll
]

{ #category : 'initialization' }
ChatPharoHistory >> initialize [

    super initialize.
    messages := OrderedCollection new
]

{ #category : 'initialization' }
ChatPharoHistory >> messages [
 ^ messages 

]
