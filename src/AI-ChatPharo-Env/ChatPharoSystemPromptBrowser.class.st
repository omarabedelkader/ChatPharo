Class {
	#name : 'ChatPharoSystemPromptBrowser',
	#superclass : 'ChatPharoBrowser',
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'activation' }
ChatPharoSystemPromptBrowser class >> packageActivation [ 

    <classAnnotation>
    ^ ChatPharoSettings default browserExtensionEnabled
        ifTrue: [ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext ]
        ifFalse: [ ClyTabActivationStrategyAnnotation never ]
]

{ #category : 'building' }
ChatPharoSystemPromptBrowser >> build [

    | agentCopy |
    agentCopy := ChatPharoSettings default agent.
    agentCopy := (agentCopy isKindOf: ChatPharoAgent)
                        ifTrue: [ agentCopy copyForChat ]
                        ifFalse: [ agentCopy ].
    chat := ChatPharoChat new
                agent: agentCopy;
                yourself.
    self addMorph: chat presenter build fullFrame: LayoutFrame identity.
    self updateAgentPackageName.
]
