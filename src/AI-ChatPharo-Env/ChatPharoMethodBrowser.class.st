Class {
	#name : 'ChatPharoMethodBrowser',
	#superclass : 'ChatPharoPackageBrowser',
	#instVars : [
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

{ #category : 'initialization' }
ChatPharoMethodBrowser >> defaultTitle [

	^ methodName ifNil: [ 'No method selected' ]
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

	methodName := context lastSelectedMethod selector.
	self updateAgentMethodName

]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgent [ 

	self updateAgentMethodName 
]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgentMethodName [

	(chat notNil and: [ chat agent respondsTo: #methodName: ]) ifTrue: [
        methodName ifNotNil: [
            chat agent methodName: methodName ]
    ].
]
