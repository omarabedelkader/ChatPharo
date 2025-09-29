Class {
	#name : 'ChatPharoBackendHistoryAwareAgent',
	#superclass : 'Object',
	#instVars : [
		'receivedHistory'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
ChatPharoBackendHistoryAwareAgent >> history [

    ^ receivedHistory
]

{ #category : 'accessing' }
ChatPharoBackendHistoryAwareAgent >> history: aHistory [

    receivedHistory := aHistory
]
