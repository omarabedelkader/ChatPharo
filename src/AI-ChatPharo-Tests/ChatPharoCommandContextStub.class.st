Class {
	#name : 'ChatPharoCommandContextStub',
	#superclass : 'Object',
	#instVars : [
		'selectedMethodItems'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'as yet unclassified' }
ChatPharoCommandContextStub class >> withSelectedMethodItems: aCollection [

	^ self new
		selectedMethodItems: aCollection;
		yourself
]

{ #category : 'accessing' }
ChatPharoCommandContextStub >> selectedMethodItems [

	^ selectedMethodItems ifNil: [ #() ]
]

{ #category : 'accessing' }
ChatPharoCommandContextStub >> selectedMethodItems: aCollection [

	selectedMethodItems := aCollection
]
