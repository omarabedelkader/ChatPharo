"
The **application root-object**.

* Owns global `settings` (which agent to use) and an ordered collection of open `chats`.
* Spawns new chat sessions through `newChat`.
* **Why** – single source of truth for top-level state; presenters bind to it to build windows/toolbars.


```samlltalk
ChatPharo new presenter open.

ChatPharoSettings new presenter open


```
"
Class {
	#name : 'ChatPharo',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'chats'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'context' }
ChatPharo class >> ask: text [

	  | chat agentCopy |
        agentCopy := ChatPharoSettings default agent.
        agentCopy := (agentCopy isKindOf: ChatPharoAgent)
                        ifTrue: [ agentCopy copyForChat ]
                        ifFalse: [ agentCopy ].
	chat := ChatPharoChat new
		        agent: ChatPharoSettings default agent;
			agent: agentCopy;
		        yourself.
	chat presenter open.
	text ifNotEmpty: [ chat sendMessage: text ]
]

{ #category : 'accessing' }
ChatPharo >> activeAgent [
    
    ^ chats isEmpty
        ifTrue: [ nil ]
        ifFalse: [ chats last agent ]
]

{ #category : 'initialization' }
ChatPharo >> chats [

	^ chats
]

{ #category : 'initialization' }
ChatPharo >> initialize [

	super initialize.
	settings := ChatPharoSettings default.
	settings agent systemPrompt isEmpty ifTrue: [
                settings agent systemPrompt: ChatPharoAgent defaultSystemPrompt ].
	chats := OrderedCollection new
]

{ #category : 'initialization' }
ChatPharo >> newChat [

	        | agentCopy |
        agentCopy := self settings agent.
        agentCopy := (agentCopy isKindOf: ChatPharoAgent)
                        ifTrue: [ agentCopy copyForChat ]
                        ifFalse: [ agentCopy ].
        chats add: (ChatPharoChat new
                agent: agentCopy;
                yourself)
]

{ #category : 'initialization' }
ChatPharo >> presenter [

	^ ChatPharoPresenter on: self 
]

{ #category : 'accessing' }
ChatPharo >> removeChatAt: anIndex [

        chats removeAt: anIndex
]

{ #category : 'accessing' }
ChatPharo >> settings [

	^ settings
]
