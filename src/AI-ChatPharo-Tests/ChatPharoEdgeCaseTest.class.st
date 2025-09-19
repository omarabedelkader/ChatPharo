Class {
	#name : 'ChatPharoEdgeCaseTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'mockAgent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoEdgeCaseTest >> setUp [

        super setUp.
        ChatPharoSettings default welcomeMessageEnabled: false.
        mockAgent := ChatPharoMockAgent new.
        chat := ChatPharoChat new agent: mockAgent
]

{ #category : 'running' }
ChatPharoEdgeCaseTest >> tearDown [

        ChatPharoSettings resetDefault.
        super tearDown
]

{ #category : 'running' }
ChatPharoEdgeCaseTest >> testAddAssistantMessageWithNilAnswerExportsPlaceholder [

	| json data |
	chat addUserMessage: 'Hello'.
	chat addAssistantMessage: nil.
	json := chat exportAsJson.
	data := STONJSON fromString: json.

	self assert: (data last at: 'content') equals: ''

]

{ #category : 'running' }
ChatPharoEdgeCaseTest >> testClearCacheWhenEmptyLeavesCacheEmpty [

        chat clearCache.

        self assert: (chat instVarNamed: #cache) isEmpty
]

{ #category : 'tests' }
ChatPharoEdgeCaseTest >> testExportAsJsonWithNilUserMessageExportsEmptyString [
        | json data |
        chat addUserMessage: nil.
        json := chat exportAsJson.
        data := STONJSON fromString: json.

        self assert: data size equals: 1.
        self assert: (data first at: 'role') equals: 'user'.
        self assert: (data first at: 'content') equals: ''
]

{ #category : 'running' }
ChatPharoEdgeCaseTest >> testExportAsJsonWithoutMessagesIsEmptyArray [

        | json |
        json := chat exportAsJson.

        self assert: json equals: '[]'
]

{ #category : 'tests' }
ChatPharoEdgeCaseTest >> testSendMessageWithLongTextPreservesContentLength [

        | longText |
        longText := String new: 500 withAll: $a.
        chat sendMessage: longText.
        self waitForChatProcess.

        self assert: (chat messages last content size) equals: longText size
]

{ #category : 'tests' }
ChatPharoEdgeCaseTest >> testSendMessageWithWhitespaceOnlyPreservesContent [

        chat sendMessage: '   '.
        self waitForChatProcess.

        self assert: (chat messages last content) equals: '   '
]

{ #category : 'tests' }
ChatPharoEdgeCaseTest >> testWhenAnswerReceivedDoNilBlockStillDeliversResponse [

        chat whenAnswerReceivedDo: nil.
        chat sendMessage: 'ping'.
        self waitForChatProcess.

        self assert: chat messages size equals: 1.
        self assert: (chat messages last answer) equals: '<<MOCK-DEFAULT-REPLY to: ping>>'
]

{ #category : 'tests' }
ChatPharoEdgeCaseTest >> testWhenToolExecutionDoNilBlockIsSafe [

        | toolAgent |
        toolAgent := ChatPharoToolMockAgent new.
        chat agent: toolAgent.
        chat whenToolExecutionDo: nil.
        chat sendMessage: 'tool run'.
        self waitForChatProcess.

        self assert: chat messages size equals: 1
]

{ #category : 'running' }
ChatPharoEdgeCaseTest >> waitForChatProcess [

        [
                | process |
                process := chat instVarNamed: #promptProcess.
                process isNil or: [ process isTerminated ]
        ] whileFalse: [ (Delay forMilliseconds: 10) wait ]
]
