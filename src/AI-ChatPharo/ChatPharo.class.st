"
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

{ #category : 'initialization' }
ChatPharo >> chats [

	^ chats
]

{ #category : 'initialization' }
ChatPharo >> initialize [

	super initialize.
	settings := ChatPharoSettings new.
	chats := OrderedCollection new
]

{ #category : 'initialization' }
ChatPharo >> newChat [

	chats add: (ChatPharoChat new
		agent: self settings agent;
		yourself)
]

{ #category : 'initialization' }
ChatPharo >> presenter [

	^ ChatPharoPresenter on: self 
]

{ #category : 'accessing' }
ChatPharo >> settings [

	^ settings
]
