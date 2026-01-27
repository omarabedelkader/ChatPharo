"
Keeps System Browser chat histories keyed by package/class/method context so they can be lazily restored.

"
Class {
	#name : 'ChatPharoBrowserChatStore',
	#superclass : 'Object',
	#classInstVars : [
		'chatHistories'
	],
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'accessing' }
ChatPharoBrowserChatStore class >> histories [

	^ chatHistories ifNil: [ chatHistories := Dictionary new ]
]

{ #category : 'accessing' }
ChatPharoBrowserChatStore class >> historyAt: aKey [ 

	^ self histories at: aKey ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ChatPharoBrowserChatStore class >> loadChatForKey: aKey into: aChat [
	| json |
	aKey ifNil: [ ^ false ].
	json := self historyAt: aKey.
	json ifNil: [ ^ false ].
	aChat importFromJson: json.
	^ true
]

{ #category : 'accessing' }
ChatPharoBrowserChatStore class >> removeHistoryForKey: aKey [

	aKey ifNil: [ ^ self ].
	self histories removeKey: aKey ifAbsent: [ ]
]

{ #category : 'accessing' }
ChatPharoBrowserChatStore class >> storeChat: aChat forKey: aKey [

	aKey ifNil: [ ^ self ].
	self histories at: aKey put: aChat exportAsJson
]
