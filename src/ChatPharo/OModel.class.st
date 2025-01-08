Class {
	#name : 'OModel',
	#superclass : 'Object',
	#instVars : [
		'tag'
	],
	#category : 'ChatPharo-API',
	#package : 'ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OModel >> fullName [

	^ String streamContents: [ :stream |
		stream << self name.
		self tag ifNotNil: [ :t |
			stream << ':'.
			stream << t ] ]
]

{ #category : 'accessing' }
OModel >> name [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OModel >> tag [
	^ tag
]

{ #category : 'accessing' }
OModel >> tag: anObject [

	tag := anObject
]
