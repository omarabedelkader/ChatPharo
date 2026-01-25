Class {
	#name : 'ChatPharoCommandElementStub',
	#superclass : 'Object',
	#instVars : [
		'browserItem'
	],
	#category : 'AI-ChatPharo-Tests-Env',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Env'
}

{ #category : 'as yet unclassified' }
ChatPharoCommandElementStub class >> withBrowserItem: aBrowserItem [

	^ self new
		browserItem: aBrowserItem;
		yourself
]

{ #category : 'accessing' }
ChatPharoCommandElementStub >> browserItem [

	^ browserItem
]

{ #category : 'accessing' }
ChatPharoCommandElementStub >> browserItem: aBrowserItem [

	browserItem := aBrowserItem
]
