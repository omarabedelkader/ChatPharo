Class {
	#name : 'ChatPharoSettings2Test',
	#superclass : 'TestCase',
	#instVars : [
		'settings',
		'mockApi'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'running' }
ChatPharoSettings2Test >> setUp [

	super setUp.
	
	settings := ChatPharoSettings2 new.
	mockApi := MockApi new.
	settings instVarNamed: #agent put: mockApi
]

{ #category : 'tests' }
ChatPharoSettings2Test >> testModelsDelegation [
	self
		assert: settings models
		equals: (MockApi modelNames).

]

{ #category : 'tests' }
ChatPharoSettings2Test >> testUseModel [
	settings useModel: 'mock-advanced'.
	self assert: (mockApi instVarNamed: #currentModel) equals: 'mock-advanced'.
]
