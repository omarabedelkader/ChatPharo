"
An extension that support the ChatPharo tool calling form the System browser
"
Class {
	#name : 'ChatPharoBrowser',
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
ChatPharoBrowser class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'accessing' }
ChatPharoBrowser class >> tabOrder [

	^ -20
]

{ #category : 'building' }
ChatPharoBrowser >> build [
	chat := ChatPharoChat new
		agent: ChatPharoSettings default agent;
		yourself.
	self addMorph: chat presenter build fullFrame: LayoutFrame identity.
	self updateAgentPackageName
]

{ #category : 'accessing' }
ChatPharoBrowser >> packageName [

	^ packageName
]

{ #category : 'accessing' }
ChatPharoBrowser >> packageName: anObject [

	packageName := anObject
]

{ #category : 'initialization' }
ChatPharoBrowser >> setUpModelFromContext [

	packageName := context lastSelectedClassGroup name.
	self updateAgentPackageName

]

{ #category : 'initialization' }
ChatPharoBrowser >> updateAgentPackageName [

	(chat notNil and: [ chat agent respondsTo: #packageName: ]) ifTrue: [
		chat agent packageName: packageName ].
]
