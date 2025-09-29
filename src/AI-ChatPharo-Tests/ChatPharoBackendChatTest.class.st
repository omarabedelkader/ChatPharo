Class {
	#name : 'ChatPharoBackendChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'settings',
		'originalDefault',
		'originalLogging'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoBackendChatTest >> setUp [

    super setUp.
    originalDefault := ChatPharoSettings default.
    originalLogging := ChatPharoLogger loggingEnabled.
    settings := ChatPharoSettings new.
    settings instVarNamed: #welcomeMessageEnabled put: false.
    settings instVarNamed: #loggingEnabled put: false.
    ChatPharoSettings setDefault: settings.
    ChatPharoLogger loggingEnabled: false.
    chat := ChatPharoChat new.
    chat agent: ChatPharoMockAgent new
]

{ #category : 'running' }
ChatPharoBackendChatTest >> tearDown [
    chat ifNotNil: [
        (chat instVarNamed: #promptProcess) ifNotNil: [ :process | process terminate ] ].
    ChatPharoSettings setDefault: originalDefault.
    ChatPharoLogger loggingEnabled: originalLogging.
    super tearDown

]

{ #category : 'running' }
ChatPharoBackendChatTest >> testAddAssistantMessageAddsToHistoryAndUpdatesLastMessage [

    chat addUserMessage: 'Hi'.
    chat addAssistantMessage: 'There'.
    self assert: chat messages size equals: 1.
    self assert: chat messages last answer equals: 'There'.
    self assert: chat messages last assistantLabel equals: 'Assistant'.
    self assert: (chat instVarNamed: #history) messages last role equals: 'assistant'.
    self assert: (chat instVarNamed: #history) messages last content equals: 'There'
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testAddAssistantMessageUsesNullAgentLabel [

    chat agent: ChatPharoNullAgent new.
    chat addUserMessage: 'Hi'.
    chat addAssistantMessage: 'Welcome'.
    self assert: chat messages last assistantLabel equals: 'Assistant bot'
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testAddUserMessageAddsHistoryAndMessages [

    chat addUserMessage: 'Hello'.
    self assert: chat messages size equals: 1.
    self assert: chat messages first content equals: 'Hello'.
    self assert: (chat instVarNamed: #history) messages size equals: 1.
    self assert: (chat instVarNamed: #history) messages first role equals: 'user'.
    self assert: (chat instVarNamed: #history) messages first content equals: 'Hello'
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testAddWelcomeMessageUsesChatPharoLabel [

    | welcomeChat |
    [
        ChatPharoSettings default instVarNamed: #welcomeMessageEnabled put: true.
        welcomeChat := ChatPharoChat new.
        self assert: welcomeChat messages size equals: 1.
        self assert: welcomeChat messages first assistantLabel equals: 'ChatPharo'.
        self assert: (welcomeChat messages first answer includesSubstring: 'Welcome to ChatPharo')
    ] ensure: [
        ChatPharoSettings default instVarNamed: #welcomeMessageEnabled put: false
    ]
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testAgentAccessorInjectsHistoryIntoAgent [

    | agent |
    agent := ChatPharoBackendHistoryAwareAgent new.
    chat agent: agent.
    self assert: chat agent equals: agent.
    self assert: agent history identicalTo: (chat instVarNamed: #history)
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testClearCacheDoesNotRemoveMessages [

    chat addUserMessage: 'Hi'.
    (chat instVarNamed: #cache) at: 'prompt' put: 'cached'.
    chat clearCache.
    self assert: chat messages size equals: 1.
    self assert: (chat instVarNamed: #cache) isEmpty
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testExportAsJsonContainsUserAndAssistantEntries [

    | json data |
    chat addUserMessage: 'Hi'.
    chat addAssistantMessage: 'There'.
    json := chat exportAsJson.
    data := STONJSON fromString: json.
    self assert: data size equals: 2.
    self assert: ((data first) at: 'role') equals: 'user'.
    self assert: ((data second) at: 'role') equals: 'assistant'.
    self assert: ((data second) at: 'content') equals: 'There'
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testHistoryPromptPrefixMatchesHistory [

    | prefix |
    chat addUserMessage: 'Hi'.
    prefix := chat history.
    self assert: prefix equals: chat historyPromptPrefix.
    self assert: prefix equals: (chat instVarNamed: #history) asPromptPrefix
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testInitializeWithWelcomeMessageAddsGreeting [

    | welcomeChat |
    [
        ChatPharoSettings default instVarNamed: #welcomeMessageEnabled put: true.
        welcomeChat := ChatPharoChat new.
        self assert: welcomeChat messages size equals: 1.
        self assert: (welcomeChat instVarNamed: #history) messages size equals: 1.
        self assert: (welcomeChat instVarNamed: #history) messages first role equals: 'assistant'.
        self assert: ((welcomeChat instVarNamed: #history) messages first content includesSubstring: 'Welcome to ChatPharo')
    ] ensure: [
        ChatPharoSettings default instVarNamed: #welcomeMessageEnabled put: false
    ]
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testInitializeWithoutWelcomeMessageStartsEmpty [

    self assert: chat messages isEmpty.
    self assert: (chat instVarNamed: #history) messages isEmpty
]

{ #category : 'running' }
ChatPharoBackendChatTest >> testTriggerToolExecutionInvokesCallback [

    | triggered |
    triggered := false.
    chat instVarNamed: #onToolExecution put: [ triggered := true ].
    chat triggerToolExecution.
    self assert: triggered
]
