Class {
	#name : 'TCMessageQueue',
	#superclass : 'Object',
	#instVars : [
		'messages'
	],
	#category : 'ChatPharo',
	#package : 'ChatPharo'
}

{ #category : 'initialization' }
TCMessageQueue >> add: aMessage [
	messages add: aMessage
]

{ #category : 'initialization' }
TCMessageQueue >> formattedMessagesFrom: aMessageNumber [
	^ String streamContents: [ :formattedMessagesStream |
	(self listFrom: aMessageNumber)
	do: [ :m | formattedMessagesStream << m printString ]
	]
]

{ #category : 'initialization' }
TCMessageQueue >> initialize [
	super initialize.
	messages := OrderedCollection new.
]

{ #category : 'initialization' }
TCMessageQueue >> listFrom: aIndex [
	^ (aIndex > 0 and: [ aIndex <= messages size])
	ifTrue: [ messages copyFrom: aIndex to: messages size ]
	ifFalse: [ #() ]
]

{ #category : 'accessing' }
TCMessageQueue >> messages [

	^ messages
]

{ #category : 'accessing' }
TCMessageQueue >> messages: anObject [

	messages := anObject
]

{ #category : 'initialization' }
TCMessageQueue >> reset [
	messages removeAll
]

{ #category : 'initialization' }
TCMessageQueue >> size [
	^ messages size
]
