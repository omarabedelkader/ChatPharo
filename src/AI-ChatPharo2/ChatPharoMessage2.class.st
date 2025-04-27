Class {
	#name : 'ChatPharoMessage2',
	#superclass : 'Object',
	#instVars : [
		'content',
		'answer',
		'presenter'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'accessing' }
ChatPharoMessage2 >> answer [

	^ answer
]

{ #category : 'accessing' }
ChatPharoMessage2 >> answer: anObject [

	answer := anObject
]

{ #category : 'accessing' }
ChatPharoMessage2 >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoMessage2 >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatPharoMessage2 >> initialize [

	content := String empty.
	answer := String empty
]

{ #category : 'accessing' }
ChatPharoMessage2 >> presenter [

	^ presenter ifNil:[ presenter := ChatPharoMessagePresenter2 on: self ]
]
