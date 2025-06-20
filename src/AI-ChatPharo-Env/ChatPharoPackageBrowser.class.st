"
An extension that support the ChatPharo tool calling form the System browser
"
Class {
	#name : 'ChatPharoPackageBrowser',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'packageName',
		'chat'
	],
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'activation' }
ChatPharoPackageBrowser class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'testing' }
ChatPharoPackageBrowser class >> shouldBeActivatedInContext: aBrowserContext [

	^ ChatPharoSettings default browserExtensionEnabled
]

{ #category : 'accessing' }
ChatPharoPackageBrowser class >> tabOrder [

	^ -20
]

{ #category : 'building' }
ChatPharoPackageBrowser >> build [
        | agentCopy |
        agentCopy := ChatPharoSettings default agent.
        agentCopy := (agentCopy isKindOf: ChatPharoAgent)
                        ifTrue: [ agentCopy copyForChat ]
                        ifFalse: [ agentCopy ].
        chat := ChatPharoChat new
                agent: agentCopy;
                yourself.
        self addMorph: chat presenter build fullFrame: LayoutFrame identity.
        self updateAgent
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> defaultIconName [

	^ #announcement
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> defaultTitle [

	^ packageName
]

{ #category : 'accessing' }
ChatPharoPackageBrowser >> packageName [

	^ packageName
]

{ #category : 'accessing' }
ChatPharoPackageBrowser >> packageName: anObject [

	packageName := anObject
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> setUpModelFromContext [

	packageName := context lastSelectedClassGroup name.
	self updateAgentPackageName

]

{ #category : 'as yet unclassified' }
ChatPharoPackageBrowser >> updateAgent [

	self updateAgentPackageName 
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> updateAgentPackageName [

	(chat notNil and: [ chat agent respondsTo: #packageName: ]) ifTrue: [
		chat agent packageName: packageName ].
]
