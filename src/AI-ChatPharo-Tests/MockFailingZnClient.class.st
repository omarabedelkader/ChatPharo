Class {
	#name : 'MockFailingZnClient',
	#superclass : 'Object',
	#instVars : [
		'tmp'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'instance creation' }
MockFailingZnClient >> get: url [ 
NetworkError signal: 'offline'
]

{ #category : 'instance creation' }
MockFailingZnClient >> head: url [ 
NetworkError signal: 'offline'
]
