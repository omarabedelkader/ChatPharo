Class {
	#name : 'ChatPharoHistorySaver',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
	#tag : 'Spec'
}

{ #category : 'as yet unclassified' }
ChatPharoHistorySaver class >> role: aRole content: aContent [

	^ self new
		  role: aRole;
		  content: aContent;
		  yourself
]

{ #category : 'converting' }
ChatPharoHistorySaver >> asJsonableObject [

	^ Dictionary new
		  at: #content put: self content;
		  at: #role put: self role;
		  yourself
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content [

	^ content
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content: anObject [

	content := anObject
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role [

	^ role
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role: anObject [

	role := anObject
]
