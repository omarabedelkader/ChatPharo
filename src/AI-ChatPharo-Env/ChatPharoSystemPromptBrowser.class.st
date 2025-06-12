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

    super build.
    chat agent systemPrompt: chat agent browserSystemPrompt
]
