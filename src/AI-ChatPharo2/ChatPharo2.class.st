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
	| chat |
	chat := ChatPharoChat2 new
		ollamaApi: self settings ollamaApi;
		yourself.
	chats add: chat.
	^ chat
]

{ #category : 'initialization' }
ChatPharo2 >> presenter [

	^ ChatPharoPresenter2 on: self 
]

{ #category : 'initialization' }
ChatPharo2 >> deleteChatWithTitle: aTitle [
    chats := chats reject: [ :chat |
        chat title = aTitle
    ].
]

{ #category : 'accessing' }
ChatPharo2 >> settings [

	^ settings
]
