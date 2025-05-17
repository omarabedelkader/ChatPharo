Class {
	#name : 'Agent',
	#superclass : 'Object',
	#instVars : [
		'model',
		'system',
		'promptPrefix',
		'response'
	],
	#category : 'AI-ChatPharo2-Agent',
	#package : 'AI-ChatPharo2-Agent'
}

{ #category : 'api' }
Agent class >> displayName [

	self subclassResponsibility
]

{ #category : 'api' }
Agent class >> isReachable [          
self subclassResponsibility.
]

{ #category : 'api' }
Agent class >> modelNames [           self subclassResponsibility.
]

{ #category : 'api' }
Agent class >> settingsPresenterFor: anAgent [   "default"
	"Return a presenter (or nil) that lets the user edit the agent’s
	 specific configuration.  Subclasses override."
	^ nil
]

{ #category : 'initialization' }
Agent >> getResponseForPrompt: prompt [

	self subclassResponsibility
]

{ #category : 'initialization' }
Agent >> initialize [
	super initialize.
	model        := ''.
	system       := ''.
	promptPrefix := ''.
	response     := ''.
]

{ #category : 'accessing' }
Agent >> model [

	^ model
]

{ #category : 'accessing' }
Agent >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
Agent >> modelInformation [ 

	self subclassResponsibility
]

{ #category : 'accessing' }
Agent >> promptPrefix [

	^ promptPrefix
]

{ #category : 'accessing' }
Agent >> promptPrefix: anObject [

	promptPrefix := anObject
]

{ #category : 'accessing' }
Agent >> response [

	^ response
]

{ #category : 'accessing' }
Agent >> response: anObject [

	response := anObject
]

{ #category : 'accessing' }
Agent >> system [

	^ system
]

{ #category : 'accessing' }
Agent >> system: anObject [

	system := anObject
]

{ #category : 'accessing' }
Agent >> useAdapter: anAdapter [
    self model: anAdapter.
]
