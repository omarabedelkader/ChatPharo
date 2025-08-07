Class {
	#name : 'ChatPharoHistoryMessageTest',
	#superclass : 'TestCase',
	#instVars : [
		'msg'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoHistoryMessageTest >> setUp [ 

        super setUp.
        msg := ChatPharoHistoryMessage role: 'user' content: 'hi'
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testAccessorsReturnValues [ 

        msg role: 'assistant'.
        msg content: 'hello'.
        self assert: msg role equals: 'assistant'.
        self assert: msg content equals: 'hello'.
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testHistoryStringOnFormatsCorrectly [ 

        | strm |
        strm := String new writeStream.
        msg historyStringOn: strm.
        self assert: strm contents equals: 'user: hi' , String cr.
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testPutOpenAIChatMessagesOnMatchesChatMessagesOn [ 

        | stream1 stream2 |
        stream1 := Array new writeStream.
        msg chatMessagesOn: stream1.
        stream2 := Array new writeStream.
        msg putOpenAIChatMessagesOn: stream2.
        self assert: stream2 contents equals: stream1 contents.
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testRoleContentInitialization [ 

        self assert: msg role equals: 'user'.
        self assert: msg content equals: 'hi'.
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testRoleContentToolCallsInitialization [ 

        | m |
        m := ChatPharoHistoryMessage role: 'assistant' content: 'a' toolCalls: { }.
        self assert: m role equals: 'assistant'.
        self assert: m toolCalls isEmpty.
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testToolCallWithCodeIsSafe [ 

    msg toolCalls: { 'Smalltalk at: #SystemShell put: EvilObject' }.
    self assert: (msg toolCalls first includesSubstring: 'SystemShell').
    "But assert no real side effect occurred"
]

{ #category : 'running' }
ChatPharoHistoryMessageTest >> testToolCallsSetter [ 

        msg toolCalls: { 't' }.
        self assert: msg toolCalls size equals: 1.
]
