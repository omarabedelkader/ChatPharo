Class {
	#name : 'ChatPharoMessage2Test',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
ChatPharoMessage2Test >> testAccessors [
	| msg |
	msg := ChatPharoMessage2 new
		content: 'Hi';
		answer: 'Hello!'.
	self assert: msg content equals: 'Hi'.
	self assert: msg answer equals: 'Hello!'.
]

{ #category : 'tests' }
ChatPharoMessage2Test >> testPresenterIsLazyInitialized [ 

	| msg presenter1 presenter2 |
	msg := ChatPharoMessage2 new.
	presenter1 := msg presenter.
	presenter2 := msg presenter.
	self assert: presenter1 == presenter2.
]
