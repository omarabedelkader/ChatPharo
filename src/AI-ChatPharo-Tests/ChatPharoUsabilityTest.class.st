Class {
	#name : 'ChatPharoUsabilityTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoUsabilityTest >> setUp [
        super setUp.
        settings := ChatPharoSettings new
]

{ #category : 'running' }
ChatPharoUsabilityTest >> tearDown [
        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testChatAddWelcomeMessageSetsFriendlyLabel [

        | chat |
        ChatPharoSettings default welcomeMessageEnabled: false.
        chat := ChatPharoChat new agent: ChatPharoMockAgent new.
        chat addUserMessage: 'start'.
        chat addAssistantMessage: 'reply'.
        chat addWelcomeMessage.

        self assert: chat messages last assistantLabel equals: 'ChatPharo'.
        self assert: (chat messages last answer includesSubstring: 'Welcome to ChatPharo')
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testChatMessagePresenterIsReused [

        | message presenter |
        message := ChatPharoMessage new.
        presenter := message presenter.

        self assert: presenter == message presenter
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testChatMessageStartsWithEmptyStrings [
        | message |
        message := ChatPharoMessage new.

        self assert: message content isEmpty.
        self assert: message answer isEmpty
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsAskFeatureEnabledByDefault [
        self assert: settings askFeatureEnabled
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsBrowserAutoTabEnabledByDefault [

        self assert: settings browserAutoTabEnabled
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsBrowserToolsEnabledProvideNames [
        self assert: (settings browserToolsEnabled allSatisfy: [ :each |
                each isString and: [ each notEmpty ] ])
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsCodeFeatureEnabledByDefault [

        self assert: settings codeFeatureEnabled
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsDefaultMaximumIterationsIsThree [
        self assert: settings maximumIterations equals: 3
]
