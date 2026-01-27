"
An extension that support the ChatPharo tool calling form the System browser
"
Class {
	#name : 'ChatPharoPackageBrowser',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'packageName',
		'chat',
		'chatContextKey'
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
 chat addAnswerReceivedHandler: [ self storeChatForCurrentContext ].
        chat whenNewChatRequestedDo: [ self startNewChatForCurrentContext ].
        self updateAgent
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> chatContextKey [

	packageName ifNil: [ ^ nil ].
	^ { #package . packageName }
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> defaultIconName [

	^ #announcement
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> defaultTitle [

	^ packageName
]

{ #category : 'history' }
ChatPharoPackageBrowser >> loadChatForCurrentContext [

	(chat isNil or: [ chatContextKey isNil ]) ifTrue: [ ^ self ].
	(ChatPharoBrowserChatStore loadChatForKey: chatContextKey into: chat)
		ifFalse: [ chat resetConversation ]
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

self storeChatForCurrentContext.
	packageName := context lastSelectedClassGroup name.
	self updateAgentPackageName.
	self updateChatForContext

]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> startNewChatForCurrentContext [

	chatContextKey ifNotNil: [
		ChatPharoBrowserChatStore removeHistoryForKey: chatContextKey ].
	chat resetConversation.
	self storeChatForCurrentContext
]

{ #category : 'initialization' }
ChatPharoPackageBrowser >> storeChatForCurrentContext [

	(chat isNil or: [ chatContextKey isNil ]) ifTrue: [ ^ self ].
	ChatPharoBrowserChatStore storeChat: chat forKey: chatContextKey
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

{ #category : 'initialization' }
ChatPharoPackageBrowser >> updateChatForContext [

	| newKey |
	newKey := self chatContextKey.
	newKey = chatContextKey ifTrue: [ ^ self ].
	chatContextKey := newKey.
	self loadChatForCurrentContext
]
