Class {
	#name : 'ChatPharoStressTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'mockAgent',
		'history'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoStressTest >> setUp [
        super setUp.
        ChatPharoSettings default welcomeMessageEnabled: false.
        mockAgent := ChatPharoMockAgent new.
        chat := ChatPharoChat new agent: mockAgent.
        history := ChatPharoHistory new
]

{ #category : 'running' }
ChatPharoStressTest >> tearDown [

        ChatPharoLogger deleteLogFile.
        ChatPharoLogger loggingEnabled: true.
        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoStressTest >> testCacheHandlesTenDistinctEntries [

        1 to: 10 do: [ :index |
                chat sendMessage: 'msg' , index asString.
                self waitForChatProcess ].

        self assert: (chat instVarNamed: #cache) size equals: 10
]

{ #category : 'running' }
ChatPharoStressTest >> testChatExportAsJsonWithManyEntries [ 

        | data |
1 to: 20 do: [ :index |
                chat addUserMessage: 'U' , index asString.
                chat addAssistantMessage: 'A' , index asString ].

        data := STONJSON fromString: chat exportAsJson.

        self assert: data size equals: 40.
        self assert: (data last at: 'role') equals: 'assistant'
]

{ #category : 'running' }
ChatPharoStressTest >> testChatHandlesManyManualMessages [
        1 to: 50 do: [ :index |
                chat addUserMessage: 'User ' , index asString.
                chat addAssistantMessage: 'Assistant ' , index asString ].

        self assert: chat messages size equals: 50
]

{ #category : 'running' }
ChatPharoStressTest >> testHistoryAsPromptPrefixWithManyMessagesContainsLastEntry [
        1 to: 50 do: [ :index |
                history addUser: 'User ' , index asString.
                history addAssistant: 'Reply ' , index asString ].

        self assert: (history asPromptPrefix includesSubstring: 'assistant: Reply 50')
]

{ #category : 'running' }
ChatPharoStressTest >> testHistoryHandlesHundredMessages [
        1 to: 100 do: [ :index |
                history addUser: 'Line ' , index asString ].

        self assert: history messages size equals: 100
]

{ #category : 'tests' }
ChatPharoStressTest >> testLoggerHandlesMultipleRapidEntries [

        ChatPharoLogger loggingEnabled: true.
        1 to: 10 do: [ :index |
                ChatPharoLogger logSystem: 'Entry' , index asString ].

        self assert: ChatPharoLogger logFile exists
]

{ #category : 'running' }
ChatPharoStressTest >> waitForChatProcess [ 
        [
                | process |
                process := chat instVarNamed: #promptProcess.
                process isNil or: [ process isTerminated ]
        ] whileFalse: [ (Delay forMilliseconds: 10) wait ]
]
