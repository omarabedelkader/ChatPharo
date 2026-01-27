Class {
	#name : 'ChatPharoClassBrowser',
	#superclass : 'ChatPharoPackageBrowser',
	#instVars : [
		'className'
	],
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'testing' }
ChatPharoClassBrowser class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isClassSelected ]
]

{ #category : 'accessing' }
ChatPharoClassBrowser class >> tabOrder [

	^ -15
]

{ #category : 'update' }
ChatPharoClassBrowser >> chatContextKey [

	className ifNil: [ ^ super chatContextKey ].
	^ { #class . packageName . className }
]

{ #category : 'introspection' }
ChatPharoClassBrowser >> className [ 

	^ className
]

{ #category : 'accessing' }
ChatPharoClassBrowser >> className: anObject [

	className := anObject
]

{ #category : 'initialization' }
ChatPharoClassBrowser >> defaultTitle [

	^ className
]

{ #category : 'initialization' }
ChatPharoClassBrowser >> setUpModelFromContext [

self storeChatForCurrentContext.
	packageName := context lastSelectedClassGroup name.
	className := context lastSelectedClass name.
	self updateAgentPackageName.
	self updateAgentClassName.
	self updateChatForContext

]

{ #category : 'update' }
ChatPharoClassBrowser >> updateAgent [ 

super updateAgent.
	self updateAgentClassName 
]

{ #category : 'update' }
ChatPharoClassBrowser >> updateAgentClassName [

	(chat notNil and: [ chat agent respondsTo: #className: ]) ifTrue: [
		chat agent className: className ].
]
