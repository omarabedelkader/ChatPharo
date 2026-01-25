Class {
	#name : 'ChatPharoDeveloperConfigZnClientStub',
	#superclass : 'Object',
	#instVars : [
		'url',
		'timeout'
	],
	#classInstVars : [
		'ShouldFail',
		'ResponseString'
	],
	#category : 'AI-ChatPharo-Tests-Config',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Config'
}

{ #category : 'as yet unclassified' }
ChatPharoDeveloperConfigZnClientStub class >> responseString [

	^ ResponseString ifNil: [ '' ]
]

{ #category : 'as yet unclassified' }
ChatPharoDeveloperConfigZnClientStub class >> responseString: aString [

	ResponseString := aString
]

{ #category : 'as yet unclassified' }
ChatPharoDeveloperConfigZnClientStub class >> shouldFail [

	^ ShouldFail ifNil: [ false ]
]

{ #category : 'as yet unclassified' }
ChatPharoDeveloperConfigZnClientStub class >> shouldFail: aBoolean [

	ShouldFail := aBoolean
]

{ #category : 'actions api' }
ChatPharoDeveloperConfigZnClientStub >> get [

	self class shouldFail ifTrue: [ Error signal: 'Simulated network failure' ].
	^ self class responseString
]

{ #category : 'actions api' }
ChatPharoDeveloperConfigZnClientStub >> timeout: anInteger [

	timeout := anInteger.
	^ self
]

{ #category : 'actions api' }
ChatPharoDeveloperConfigZnClientStub >> url: aUrl [

	url := aUrl.
	^ self
]
