Class {
	#name : 'ChatPharoTemporaryChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'tmp'
	],
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoTemporaryChatTest >> setUp [
	super setUp.
	tmp := ChatPharoTemporaryChat new.

]

{ #category : 'running' }
ChatPharoTemporaryChatTest >> testCancelInvokesBlock [
	| flag |
	flag := false.
	tmp onCancel: [ flag := true ].
	tmp cancel.
	self assert: flag.
]

{ #category : 'running' }
ChatPharoTemporaryChatTest >> testSubmitInvokesBlockWithText [
	| captured |
	captured := nil.
	tmp
		onSubmit: [ :t | captured := t ];
		text: 'payload'.
	tmp submit.
	self assert: captured equals: 'payload'.
]
