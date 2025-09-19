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
ChatPharoUsabilityTest >> testChatInitializationAddsWelcomeMessageToHistory [
        | chat history |
        ChatPharoSettings default welcomeMessageEnabled: true.
        chat := ChatPharoChat new agent: ChatPharoMockAgent new.
        history := chat instVarNamed: #history.

        self assert: history messages size equals: 1.
        self assert: (history messages first role) equals: 'assistant'.
        self assert: ((history messages first content)
                includesSubstring: 'Welcome to ChatPharo')
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
ChatPharoUsabilityTest >> testChatWithNullAgentUsesAssistantBotLabel [
        | chat |
        ChatPharoSettings default welcomeMessageEnabled: false.
        chat := ChatPharoChat new agent: ChatPharoNullAgent new.
        chat sendMessage: 'hello'.
        self waitForChatProcess: chat.

        self assert: chat messages size equals: 1.
        self assert: chat messages last assistantLabel equals: 'Assistant bot'.
        self assert: (chat messages last answer includesSubstring: 'No backend is configured')
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsAskFeatureEnabledByDefault [
        self assert: settings askFeatureEnabled
]

{ #category : 'running' }
ChatPharoUsabilityTest >> testSettingsAvailableApiChoicesExposeDisplayNames [
        | choices nullChoice |
        choices := settings availableApiChoices.
        self deny: choices isEmpty.
        nullChoice := choices detect: [ :assoc | assoc key = 'None (offline)' ].

        self assert: nullChoice value equals: ChatPharoNullAgent.
        self assert: (choices collect: [ :assoc | assoc key ]) asSet size equals: choices size
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

{ #category : 'running' }
ChatPharoUsabilityTest >> waitForChatProcess: aChat [
        [
                | process |
                process := aChat instVarNamed: #promptProcess.
                process isNil or: [ process isTerminated ]
        ] whileFalse: [ (Delay forMilliseconds: 10) wait ]
]
