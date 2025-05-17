Class {
	#name : 'ChatPharoMessageTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
ChatPharoMessageTest >> testAccessors [
	| msg |
	msg := ChatPharoMessage new
		content: 'Hi';
		answer: 'Hello!'.
	self assert: msg content equals: 'Hi'.
	self assert: msg answer equals: 'Hello!'.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testPresenterIsLazyInitialized [ 

	| msg presenter1 presenter2 |
	msg := ChatPharoMessage new.
	presenter1 := msg presenter.
	presenter2 := msg presenter.
	self assert: presenter1 == presenter2.
]
