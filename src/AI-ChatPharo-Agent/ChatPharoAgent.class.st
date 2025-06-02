"
```smalltalk

ChatPharo new settings agent class name.
```
"
Class {
	#name : 'ChatPharoAgent',
	#superclass : 'Object',
	#instVars : [
		'model',
		'system',
		'promptPrefix',
		'response',
		'history'
	],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'api' }
ChatPharoAgent class >> displayName [

	self subclassResponsibility
]

{ #category : 'api' }
ChatPharoAgent class >> isReachable [          
self subclassResponsibility.
]

{ #category : 'api' }
ChatPharoAgent class >> modelNames [           self subclassResponsibility.
]

{ #category : 'api' }
ChatPharoAgent class >> settingsPresenterFor: anAgent [   "default"
	"Return a presenter (or nil) that lets the user edit the agent’s
	 specific configuration.  Subclasses override."
	^ nil
]

{ #category : 'initialization' }
ChatPharoAgent >> getResponseForPrompt: prompt [

	self subclassResponsibility
]

{ #category : 'accessing' }
ChatPharoAgent >> history [                     ^ history
]

{ #category : 'accessing' }
ChatPharoAgent >> history: aHistory [           history := aHistory
]

{ #category : 'initialization' }
ChatPharoAgent >> initialize [
	super initialize.
	model        := ''.
	system       := ''.
	promptPrefix := ''.
	response     := ''.
]

{ #category : 'accessing' }
ChatPharoAgent >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoAgent >> model: anObject [

	model := anObject
]

{ #category : 'initialization' }
ChatPharoAgent >> modelInformation [ 

	self subclassResponsibility
]

{ #category : 'accessing' }
ChatPharoAgent >> promptPrefix [

	^ promptPrefix
]

{ #category : 'accessing' }
ChatPharoAgent >> promptPrefix: anObject [

	promptPrefix := anObject
]

{ #category : 'accessing' }
ChatPharoAgent >> response [

	^ response
]

{ #category : 'accessing' }
ChatPharoAgent >> response: anObject [

	response := anObject
]

{ #category : 'accessing' }
ChatPharoAgent >> system [

	^ system
]

{ #category : 'accessing' }
ChatPharoAgent >> system: anObject [

	system := anObject
]

{ #category : 'accessing' }
ChatPharoAgent >> useAdapter: anAdapter [
    self model: anAdapter.
]
