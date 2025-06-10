Class {
	#name : 'PackageTrackingAgent',
	#superclass : 'ChatPharoNullAgent',
	#instVars : [
		'lastPackage'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'accessing' }
PackageTrackingAgent >> lastPackage [ 
^ lastPackage 
]

{ #category : 'accessing' }
PackageTrackingAgent >> packageName: aString [ 
lastPackage := aString 
]
