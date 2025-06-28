Class {
	#name : 'ChatPharoAgentTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoAgentTest >> setUp [ 

        super setUp.
        agent := ChatPharoNullAgent new
]

{ #category : 'running' }
ChatPharoAgentTest >> testAgentConformsToAPI [ 

	| agent |
	agent := ChatPharoMockAgent new.
	self assert: (agent respondsTo: #getResponseForPrompt:).
	self assert: (agent respondsTo: #model).
	self assert: (agent respondsTo: #history).
	self assert: (agent respondsTo: #promptPrefix).
]

{ #category : 'running' }
ChatPharoAgentTest >> testModelSetterGetter [ 

        agent model: 'm'.
        self assert: agent model equals: 'm'.
]

{ #category : 'running' }
ChatPharoAgentTest >> testPromptPrefixSetterGetter [ 

        agent promptPrefix: 'p'.
        self assert: agent promptPrefix equals: 'p'.
]

{ #category : 'running' }
ChatPharoAgentTest >> testSystemSetterGetter [

	agent systemPrompt: 's'.
	self assert: agent systemPrompt equals: 's'
]
