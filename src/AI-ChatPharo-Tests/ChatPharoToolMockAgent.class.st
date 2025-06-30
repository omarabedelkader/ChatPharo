Class {
	#name : 'ChatPharoToolMockAgent',
	#superclass : 'ChatPharoMockAgent',
	#instVars : [
		'toolExecution'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'private - uffi' }
ChatPharoToolMockAgent >> getResponseForPrompt: prompt [ 
    toolExecution ifNotNil: [ toolExecution value ].
    ^ super getResponseForPrompt: prompt
]

{ #category : 'private - ffi' }
ChatPharoToolMockAgent >> onToolExecution [
    ^ toolExecution
]

{ #category : 'private - ffi' }
ChatPharoToolMockAgent >> onToolExecution: aBlock [
    toolExecution := aBlock
]
