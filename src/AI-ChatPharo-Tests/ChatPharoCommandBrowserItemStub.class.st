Class {
	#name : 'ChatPharoCommandBrowserItemStub',
	#superclass : 'Object',
	#instVars : [
		'actualObject'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'as yet unclassified' }
ChatPharoCommandBrowserItemStub class >> withActualObject: anObject [

	^ self new
		actualObject: anObject;
		yourself
]

{ #category : 'accessing' }
ChatPharoCommandBrowserItemStub >> actualObject [

	^ actualObject
]

{ #category : 'accessing' }
ChatPharoCommandBrowserItemStub >> actualObject: anObject [

	actualObject := anObject
]
