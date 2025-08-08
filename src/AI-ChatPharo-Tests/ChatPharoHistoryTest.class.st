Class {
	#name : 'ChatPharoHistoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'history'
	],
	#category : 'AI-ChatPharo-Tests-History',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'History'
}

{ #category : 'running' }
ChatPharoHistoryTest >> setUp [ 

        super setUp.
        history := ChatPharoHistory new
]

{ #category : 'running' }
ChatPharoHistoryTest >> testAddAssistantAddsMessage [ 

        history addAssistant: 'hi'.
        self assert: history messages size equals: 1.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testAddManyMessages [ 

    1 to: 1000 do: [:i |
        history addUser: 'user message ', i asString.
        history addAssistant: 'reply ', i asString.
    ].
    self assert: history messages size equals: 2000.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testAddMessageAddsHistoryMessage [

        | message |
        message := ChatPharoHistoryMessage role: 'user' content: 'hey'.
        history addMessage: message.
        self assert: history messages size equals: 1.
        self assert: history messages first equals: message.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testAddUserAddsMessage [ 

        history addUser: 'hello'.
        self assert: history messages size equals: 1.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testAsPromptPrefixIncludesBothMessages [ 

        history addUser: 'hello'.
        history addAssistant: 'hi'.
        self assert: (history asPromptPrefix includesSubstring: 'user: hello').
        self assert: (history asPromptPrefix includesSubstring: 'assistant: hi').
]

{ #category : 'running' }
ChatPharoHistoryTest >> testChatMessagesOnOutputsRoleDictionaries [

        | stream |
        history addUser: 'hello'.
        history addAssistant: 'hi'.
        stream := Array new writeStream.
        history chatMessagesOn: stream.
        self assert: stream contents size equals: 2.
        self assert: (stream contents first at: 'role') equals: 'user'.
        self assert: (stream contents last at: 'role') equals: 'assistant'.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testChatMessagesOnWithEmptyHistoryProducesNoMessages [

        | stream |
        stream := Array new writeStream.
        history chatMessagesOn: stream.
        self assert: stream contents isEmpty.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testClearRemovesAllMessages [ 

        history addUser: 'a'.
        history clear.
        self assert: history messages isEmpty.
]

{ #category : 'tests' }
ChatPharoHistoryTest >> testMessagesPreserveOrder [ 

        | msgs |
        history addUser: 'first'.
        history addAssistant: 'second'.
        msgs := history messages.
        self assert: msgs class equals: OrderedCollection.
        self assert: msgs size equals: 2.
        self assert: (msgs first content) equals: 'first'.
        self assert: (msgs second role) equals: 'assistant'.
]

{ #category : 'running' }
ChatPharoHistoryTest >> testPutOpenAIChatMessagesOnMatchesChatMessagesOn [

        | stream1 stream2 |
        history addUser: 'hello'.
        history addAssistant: 'hi'.
        stream1 := Array new writeStream.
        history chatMessagesOn: stream1.
        stream2 := Array new writeStream.
        history putOpenAIChatMessagesOn: stream2.
        self assert: stream2 contents equals: stream1 contents.
]
