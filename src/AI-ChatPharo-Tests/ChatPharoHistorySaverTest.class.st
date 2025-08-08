Class {
	#name : 'ChatPharoHistorySaverTest',
	#superclass : 'TestCase',
	#instVars : [
		'saver'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoHistorySaverTest >> setUp [ 

        super setUp.
        saver := ChatPharoHistorySaver role: 'user' content: 'hi'
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testContentSetterGetter [ 

        saver content: 'bye'.
        self assert: saver content equals: 'bye'.

]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testHistoryStringOnHandlesNilContent [ 

        | strm |
        saver content: nil.
        strm := String new writeStream.
        saver historyStringOn: strm.
        self assert: strm contents equals: 'user: ' , String cr.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testHistoryStringOnOutputsCorrectFormat [ 

        | s |
        s := String new writeStream.
        saver historyStringOn: s.
        self assert: (s contents includesSubstring: 'user: hi').
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testOpenAIChatMessagesOnWithNilContentAddsPlaceholder [ 

        | strm |
        saver content: nil.
        strm := Array new writeStream.
        saver putOpenAIChatMessagesOn: strm.
        self assert: (strm contents first at: 'content') equals: '[No assistant response]'.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testOpenAIChatMessagesOnWithToolCalls [ 

        | call strm |
        call := ChatPharoHistorySaverToolCall id: '1' functionName: 'f' arguments: '{}' content: 'c'.
        saver toolCalls: { call }.
        strm := Array new writeStream.
        saver putOpenAIChatMessagesOn: strm.
        self assert: (strm contents first at: 'tool_calls') notNil.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testOpenAIChatMessagesOnWithToolCallsAddsToolResultMessage [

        | call strm |
        call := ChatPharoHistorySaverToolCall id: '1' functionName: 'f' arguments: '{}' content: 'result'.
        saver toolCalls: { call }.
        strm := Array new writeStream.
        saver putOpenAIChatMessagesOn: strm.
        self assert: strm contents size equals: 2.
        self assert: (strm contents second at: 'role') equals: 'tool'.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testOpenAIChatMessagesOnWithoutToolCalls [ 

        | strm |
        strm := Array new writeStream.
        saver putOpenAIChatMessagesOn: strm.
        self assert: (strm contents first at: 'role') equals: 'user'.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testRoleContentCreation [ 

        self assert: saver role equals: 'user'.
        self assert: saver content equals: 'hi'.
]

{ #category : 'running' }
ChatPharoHistorySaverTest >> testRoleSetterGetter [ 

        saver role: 'assistant'.
        self assert: saver role equals: 'assistant'.

]
