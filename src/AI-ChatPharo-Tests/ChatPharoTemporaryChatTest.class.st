Class {
	#name : 'ChatPharoTemporaryChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'tmp'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
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

{ #category : 'running' }
ChatPharoTemporaryChatTest >> testSubmitWithoutBlockIsSafe [ 

        tmp text: 'bar'.
        tmp submit.
        self assert: tmp text equals: 'bar'.
]

{ #category : 'running' }
ChatPharoTemporaryChatTest >> testTextAccessor [ 

        tmp text: 'foo'.
        self assert: tmp text equals: 'foo'.
]
