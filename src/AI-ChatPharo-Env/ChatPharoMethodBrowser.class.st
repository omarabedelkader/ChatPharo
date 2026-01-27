Class {
	#name : 'ChatPharoMethodBrowser',
	#superclass : 'ChatPharoPackageBrowser',
	#instVars : [
		'className',
		'methodName'
	],
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'testing' }
ChatPharoMethodBrowser class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isMethodSelected ]
]

{ #category : 'accessing' }
ChatPharoMethodBrowser class >> tabOrder [

	^ -12
]

{ #category : 'update' }
ChatPharoMethodBrowser >> chatContextKey [ 

	methodName ifNil: [ ^ super chatContextKey ].
	^ { #method . packageName . className . methodName }
]

{ #category : 'introspection' }
ChatPharoMethodBrowser >> className [

	^ className
]

{ #category : 'introspection' }
ChatPharoMethodBrowser >> className: anObject [

	className := anObject
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> defaultTitle [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName: anObject [

	methodName := anObject
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> setUpModelFromContext [

		| methodClass |
	self storeChatForCurrentContext.
	methodClass := context lastSelectedMethod methodClass.
	className := methodClass name.
	packageName := (methodClass respondsTo: #package)
		               ifTrue: [ methodClass package name ]
		               ifFalse: [ nil ].
	methodName := context lastSelectedMethod selector.
		self updateAgentPackageName.
	self updateAgentMethodName.
	self updateChatForContext

]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgent [ 

super updateAgent.
	self updateAgentMethodName 
]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgentMethodName [

	(chat notNil and: [ chat agent respondsTo: #methodName: ]) ifTrue: [
		chat agent methodName: methodName ].
]
