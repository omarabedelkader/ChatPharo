Class {
	#name : 'ChatPharoSettingsTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings',
		'mockApi'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoSettingsTest >> setUp [

	super setUp.
	
	settings := ChatPharoSettings new.
	mockApi := MockApi new.
	settings instVarNamed: #agent put: mockApi
]

{ #category : 'tests' }
ChatPharoSettingsTest >> testAvailableApiChoicesReturnsAssociations [
	| choices |
	choices := settings availableApiChoices.
	self assert: (choices allSatisfy: [ :assoc | assoc key isString and: [ assoc value isClass ] ]).
]

{ #category : 'tests' }
ChatPharoSettingsTest >> testModelsDelegation [
	self
		assert: settings models
		equals: (MockApi modelNames).

]

{ #category : 'tests' }
ChatPharoSettingsTest >> testUseApiReplacesAgentSubclass [ 

    settings useApi: ChatPharoNullAgent.
    self assert: settings agent class equals: ChatPharoNullAgent.
]

{ #category : 'tests' }
ChatPharoSettingsTest >> testUseModel [
	settings useModel: 'mock-advanced'.
	self assert: (mockApi instVarNamed: #currentModel) equals: 'mock-advanced'.
]
