Class {
	#name : 'ChatPharoMockAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoMockAgentTest >> setUp [ 

    super setUp.
    agent := ChatPharoMockAgent new
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testGetResponseAddsToHistory [ 

    agent getResponseForPrompt: 'hi'.
    self assert: (agent history last first value) equals: 'hi'
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testGetResponseReturnsFormattedString [ 

    | reply |
    reply := agent getResponseForPrompt: 'hey'.
    self assert: reply equals: '<<MOCK-DEFAULT-REPLY to: hey>>'
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testHistoryOrder [ 

    agent system: 's1'.
    agent getResponseForPrompt: 'u1'.
    agent system: 's2'.
    agent getResponseForPrompt: 'u2'.
    self assert: (agent history collect: [:e | e first value])
        equals: (OrderedCollection withAll: #('s1' 'u1' 's2' 'u2'))
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testHistoryStartsEmpty [ 

    self assert: agent history isEmpty
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testModelNames [ 

    self
        assert: ChatPharoMockAgent modelNames
        equals: #('mock-default' 'mock-advanced')
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testModelSetterGetter [ 

    agent model: 'advanced'.
    self assert: agent model equals: 'advanced'
]

{ #category : 'running' }
ChatPharoMockAgentTest >> testSystemAddsToHistory [ 

    agent system: 'sys'.
    self assert: (agent history last first value) equals: 'sys'
]
