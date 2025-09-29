Class {
	#name : 'ChatPharoToolTestResponseStub',
	#superclass : 'Object',
	#instVars : [
		'contents'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
ChatPharoToolTestResponseStub >> contents [

    ^ contents ifNil: [ contents := '{"data":[],"choices":[{"message":{"content":"ok","tool_calls":[]}}]}' ]
]

{ #category : 'accessing' }
ChatPharoToolTestResponseStub >> contents: aString [

    contents := aString
]

{ #category : 'accessing' }
ChatPharoToolTestResponseStub >> isSuccess [

    ^ true
]
