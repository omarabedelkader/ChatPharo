Extension { #name : 'RubSmalltalkEditor' }

{ #category : '*AI-ChatPharo-Env' }
RubSmalltalkEditor >> openChatCharo [

	 | selected |
    selected := self selection asString.
    ChatPharo ask: selected
]

{ #category : '*AI-ChatPharo-Env' }
RubSmalltalkEditor >> openChatCharoCode [

        | selected |
        selected := self selection asString.
        ChatPharo code: selected
]
