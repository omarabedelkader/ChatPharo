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
ChatPharoHistoryTest >> testClearRemovesAllMessages [ 

        history addUser: 'a'.
        history clear.
        self assert: history messages isEmpty.
]
