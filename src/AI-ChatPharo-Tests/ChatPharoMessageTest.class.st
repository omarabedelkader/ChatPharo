Class {
	#name : 'ChatPharoMessageTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
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
ChatPharoMessageTest >> testFeedbackAccessors [

        | msg |
        msg := ChatPharoMessage new.
        msg feedback: true.
        self assert: msg feedback equals: true.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testPresenterIsLazyInitialized [ 

	| msg presenter1 presenter |
	msg := ChatPharoMessage new.
	presenter1 := msg presenter.
	presenter := msg presenter.
	self assert: presenter1 == presenter.
]
