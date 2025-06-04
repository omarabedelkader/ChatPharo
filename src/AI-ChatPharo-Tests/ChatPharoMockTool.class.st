Class {
	#name : 'ChatPharoMockTool',
	#superclass : 'Object',
	#instVars : [
		'conversationHistory',
		'currentModel'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'initialization' }
ChatPharoMockTool >> modelNames [ 

    ^ #('mock-model')
]
