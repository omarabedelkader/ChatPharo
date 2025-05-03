Class {
	#name : 'NullAgentTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'tests' }
NullAgentTest >> testGetResponseAlwaysEmptyAndReachable [
	| a |
	a := NullAgent new.
	self assert: (a getResponseForPrompt: 'anything') isEmpty.
	self assert: NullAgent isReachable.
]
