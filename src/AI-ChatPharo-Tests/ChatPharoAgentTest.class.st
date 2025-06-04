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

        agent system: 's'.
        self assert: agent system equals: 's'.
]
