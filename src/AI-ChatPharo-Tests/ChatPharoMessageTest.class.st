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
ChatPharoMessageTest >> testAssistantLabelAccessors [ 

        | msg |
        msg := ChatPharoMessage new.
        msg assistantLabel: 'Bot'.
        self assert: msg assistantLabel equals: 'Bot'.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testDefaultInitialization [

        | msg |
        msg := ChatPharoMessage new.
        self assert: msg content equals: String empty.
        self assert: msg answer equals: String empty.
        self assert: msg assistantLabel equals: 'Assistant'.
        self assert: msg feedback isNil.
        self assert: msg height equals: 140.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testFeedbackAccessors [

        | msg |
        msg := ChatPharoMessage new.
        msg feedback: true.
        self assert: msg feedback equals: true.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testPresenterClass [ 

        | msg |
        msg := ChatPharoMessage new.
        self assert: msg presenter class equals: ChatPharoMessagePresenter.
]

{ #category : 'tests' }
ChatPharoMessageTest >> testPresenterIsLazyInitialized [ 

	| msg presenter1 presenter |
	msg := ChatPharoMessage new.
	presenter1 := msg presenter.
	presenter := msg presenter.
	self assert: presenter1 == presenter.
]
