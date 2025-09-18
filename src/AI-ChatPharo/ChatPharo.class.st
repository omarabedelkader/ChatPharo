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
	ChatPharoLogger logFrontend: 'Quick ask invoked'
                details: (Dictionary new
                        at: 'prompt' put: text;
                        yourself).
	agentCopy := ChatPharoSettings default agent.
	agentCopy := (agentCopy isKindOf: ChatPharoAgent)
		             ifTrue: [ agentCopy copyForChat ]
		             ifFalse: [ agentCopy ].
	chat := ChatPharoChat new
		        agent: ChatPharoSettings default agent;
		        agent: agentCopy;
		        yourself.
	chat presenter open.
	text ifNotEmpty: [ chat sendMessage: text ].
ChatPharoLogger logSystem: 'Quick ask completed'
                details: (Dictionary new
                        at: 'prompt' put: text;
                        at: 'activeAgent' put: (ChatPharoLogger agentNameFor: agentCopy);
                        yourself)
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
	settings agent systemPrompt isEmpty ifTrue: [ settings agent systemPrompt: ChatPharoAgent defaultSystemPrompt ].
	chats := OrderedCollection new.
	ChatPharoLogger logSystem: 'ChatPharo initialized' details: (Dictionary new
			 at: 'defaultAgent' put: (ChatPharoLogger agentNameFor: settings agent);
			 yourself)
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
			 yourself).
        ChatPharoLogger logFrontend: 'New chat session created'
                details: (Dictionary new
                        at: 'totalChats' put: chats size;
                        at: 'agent' put: (ChatPharoLogger agentNameFor: agentCopy);
                        yourself)
]

{ #category : 'initialization' }
ChatPharo >> presenter [

	^ ChatPharoPresenter on: self 
]

{ #category : 'accessing' }
ChatPharo >> removeAllChats [

	| removed |
	chats do: [ :each | each clearChat ].
	        removed := chats size.
        chats removeAll.
        ChatPharoLogger logFrontend: 'All chats removed'
                details: (Dictionary new
                        at: 'removedCount' put: removed;
                        yourself)
]

{ #category : 'accessing' }
ChatPharo >> removeChatAt: anIndex [

	        | removedChat agentName |
        removedChat := chats at: anIndex ifAbsent: [ nil ].
        chats removeAt: anIndex.
        agentName := removedChat
                ifNotNil: [ ChatPharoLogger agentNameFor: removedChat agent ]
                ifNil: [ 'None' ].
        ChatPharoLogger logFrontend: 'Chat removed'
                details: (Dictionary new
                        at: 'index' put: anIndex;
                        at: 'remainingChats' put: chats size;
                        at: 'agent' put: agentName;
                        yourself)
]

{ #category : 'accessing' }
ChatPharo >> settings [

	^ settings
]
