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

	className := context lastSelectedClass name.
	self updateAgentClassName

]

{ #category : 'as yet unclassified' }
ChatPharoClassBrowser >> updateAgent [ 

	self updateAgentClassName 
]

{ #category : 'as yet unclassified' }
ChatPharoClassBrowser >> updateAgentClassName [

	(chat notNil and: [ chat agent respondsTo: #className: ]) ifTrue: [
		chat agent className: className ].
]
