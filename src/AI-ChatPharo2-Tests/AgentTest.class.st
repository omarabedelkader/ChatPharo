Class {
	#name : 'AgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent',
		'mockAdapter',
		'systemPrompt'
	],
	#category : 'AI-ChatPharo2-Tests-Agent',
	#package : 'AI-ChatPharo2-Tests',
	#tag : 'Agent'
}

{ #category : 'accessing' }
AgentTest >> agent [

	^ agent
]

{ #category : 'accessing' }
AgentTest >> agent: anObject [

	agent := anObject
]

{ #category : 'accessing' }
AgentTest >> mockAdapter [

	^ mockAdapter
]

{ #category : 'accessing' }
AgentTest >> mockAdapter: anObject [

	mockAdapter := anObject
]

{ #category : 'running' }
AgentTest >> setUp [

    super setUp.
    mockAdapter := MockAdapter new.
    agent := Agent new.
    agent useAdapter: mockAdapter.
]

{ #category : 'accessing' }
AgentTest >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
AgentTest >> systemPrompt: anObject [

	systemPrompt := anObject
]

{ #category : 'running' }
AgentTest >> testInitializeSetsDefaultStrings [ 

self assert: agent system equals: ''.
self assert: agent promptPrefix equals: ''.
self assert: agent response equals: ''.
]

{ #category : 'running' }
AgentTest >> testSendPromptPropagatesSystemPrompt [ 

    agent setSystemPrompt: 'SYS'.
    agent sendPrompt: 'hi'.
    self assert: mockAdapter lastSystem equals: 'SYS'
]

{ #category : 'running' }
AgentTest >> testSendPromptReturnsAndCachesAdapterReply [ 

    mockAdapter nextReply: 'REPLY'.
    self assert: (agent sendPrompt: 'x') equals: 'REPLY'.
    self assert: agent response equals: 'REPLY'
]

{ #category : 'running' }
AgentTest >> testSendPromptWithPrefixDelegatesToAdapter [ 

    agent
        setPromptPrefix: '>>>'
        ; sendPrompt: 'pong'.
    self assert: mockAdapter lastPrompt equals: '>>> pong'
]

{ #category : 'running' }
AgentTest >> testSendPromptWithoutPrefixDelegatesToAdapter [ 

    agent setPromptPrefix: ''.
    agent sendPrompt: 'ping'.
    self assert: mockAdapter lastPrompt equals: 'ping'
]

{ #category : 'running' }
AgentTest >> testSetPromptPrefixStoresValue [ 

    agent setPromptPrefix: '###'.
    self assert: (agent instVarNamed: #promptPrefix) equals: '###'
]

{ #category : 'running' }
AgentTest >> testSetSystemPromptStoresValue [ 

    agent setSystemPrompt: 'You are a test bot'.
    self assert: (agent instVarNamed: #systemPrompt) equals: 'You are a test bot'
]
