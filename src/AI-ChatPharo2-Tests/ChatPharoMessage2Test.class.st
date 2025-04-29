Class {
	#name : 'ChatPharoMessage2Test',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
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
