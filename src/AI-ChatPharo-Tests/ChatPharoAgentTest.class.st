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
ChatPharoAgentTest >> testConfigurationErrorMessage [

        self
                assert: agent configurationErrorMessage
                equals: 'Agent is missing required settings.'
]

{ #category : 'running' }
ChatPharoAgentTest >> testCopyForChatResetsState [

        | history clone |
        history := ChatPharoHistory new.
        history addUser: 'hi'.
        agent
                model: 'm';
                promptPrefix: 'prefix';
                response: 'resp';
                history: history.
        clone := agent copyForChat.
        self assert: clone ~~ agent.
        self assert: clone model equals: 'm'.
        self assert: clone history messages isEmpty.
        self assert: clone promptPrefix equals: ''.
        self assert: clone response equals: ''.
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

{ #category : 'running' }
ChatPharoAgentTest >> testUseAdapterSetsModel [


        agent useAdapter: 'adapter'.
        self assert: agent model equals: 'adapter'
]
