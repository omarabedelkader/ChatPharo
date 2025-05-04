Class {
	#name : 'ChatPharoTemporaryChat2Test',
	#superclass : 'TestCase',
	#instVars : [
		'tmp'
	],
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoTemporaryChat2Test >> setUp [
	super setUp.
	tmp := ChatPharoTemporaryChat2 new.

]

{ #category : 'running' }
ChatPharoTemporaryChat2Test >> testCancelInvokesBlock [
	| flag |
	flag := false.
	tmp onCancel: [ flag := true ].
	tmp cancel.
	self assert: flag.
]

{ #category : 'running' }
ChatPharoTemporaryChat2Test >> testSubmitInvokesBlockWithText [
	| captured |
	captured := nil.
	tmp
		onSubmit: [ :t | captured := t ];
		text: 'payload'.
	tmp submit.
	self assert: captured equals: 'payload'.
]
