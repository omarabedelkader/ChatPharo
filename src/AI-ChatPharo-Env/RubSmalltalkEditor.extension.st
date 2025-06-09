Extension { #name : 'RubSmalltalkEditor' }

{ #category : '*AI-ChatPharo-Env' }
RubSmalltalkEditor >> openChatCharo [

	 | selected |
    selected := self selection asString.
    ChatPharo ask: selected
]
