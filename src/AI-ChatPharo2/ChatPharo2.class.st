"
```samlltalk
ChatPharo2 new presenter open.

ChatPharoSettings2 new presenter open
```
"
Class {
	#name : 'ChatPharo2',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'chats'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'initialization' }
ChatPharo2 >> chats [

	^ chats
]

{ #category : 'initialization' }
ChatPharo2 >> initialize [

	super initialize.
	settings := ChatPharoSettings2 new.
	chats := OrderedCollection new
]

{ #category : 'initialization' }
ChatPharo2 >> newChat [

	chats add: (ChatPharoChat2 new
		ollamaApi: self settings ollamaApi;
		yourself)
]

{ #category : 'initialization' }
ChatPharo2 >> presenter [

	^ ChatPharoPresenter2 on: self 
]

{ #category : 'accessing' }
ChatPharo2 >> settings [

	^ settings
]

{ #category : 'accessing' }
ChatPharo2 >> agent [
	
    ^ self chats isEmpty
        ifTrue: [ nil ]
        ifFalse: [ self chats last ollamaApi ]
]