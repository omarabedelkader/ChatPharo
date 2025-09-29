Class {
	#name : 'ChatPharoSafetyAdvisorBackendTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> setUp [

    super setUp.
    presenter := ChatPharoSafetyAdvisorPresenterStub new.
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testConfirmMaxIterationsDelegatesToPresenter [

    ChatPharoSafetyAdvisor confirmMaxIterationsOn: presenter.
    self assert: presenter messages first equals: ChatPharoSafetyAdvisor maxIterationsMessage.
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testConfirmMaxIterationsRespectsPresenterAnswer [

    presenter nextAnswer: false.
    self deny: (ChatPharoSafetyAdvisor confirmMaxIterationsOn: presenter).
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testConfirmPromptModificationDelegatesToPresenter [

    ChatPharoSafetyAdvisor confirmPromptModificationOn: presenter.
    self assert: presenter messages first equals: ChatPharoSafetyAdvisor promptChangeMessage.
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testConfirmToolDisableDelegatesToPresenter [

    ChatPharoSafetyAdvisor confirmToolDisableOn: presenter.
    self assert: presenter messages first equals: ChatPharoSafetyAdvisor toolDisableMessage.
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testMaxIterationsMessageMatchesExpectedText [

    self assert: (ChatPharoSafetyAdvisor maxIterationsMessage includesSubstring: 'Maximum iterations').
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testPromptChangeMessageIncludesRecommendation [

    self assert: (ChatPharoSafetyAdvisor promptChangeMessage includesSubstring: 'optimal performance').
]

{ #category : 'running' }
ChatPharoSafetyAdvisorBackendTest >> testToolDisableMessageIncludesWarning [

    self assert: (ChatPharoSafetyAdvisor toolDisableMessage includesSubstring: 'keeping all tools enabled').
]
