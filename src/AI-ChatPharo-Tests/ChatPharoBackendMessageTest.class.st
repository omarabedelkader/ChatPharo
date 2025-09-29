Class {
	#name : 'ChatPharoBackendMessageTest',
	#superclass : 'TestCase',
	#instVars : [
		'message'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoBackendMessageTest >> setUp [

    super setUp.
    message := ChatPharoMessage new
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testAnswerAccessorUpdatesValue [

    message answer: 'Response'.
    self assert: message answer equals: 'Response'
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testAssistantLabelAccessorUpdatesValue [

    message assistantLabel: 'Helper'.
    self assert: message assistantLabel equals: 'Helper'
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testContentAccessorUpdatesValue [

    message content: 'Prompt'.
    self assert: message content equals: 'Prompt'
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testFeedbackAccessorStoresBoolean [

    message feedback: true.
    self assert: message feedback equals: true.
    message feedback: false.
    self assert: message feedback equals: false
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testInitializeSetsDefaultValues [

    self assert: message content equals: ''.
    self assert: message answer equals: ''.
    self assert: message assistantLabel equals: 'Assistant'.
    self assert: message feedback isNil
]

{ #category : 'running' }
ChatPharoBackendMessageTest >> testPresenterIsMemoized [

    self assert: message presenter identicalTo: message presenter
]
