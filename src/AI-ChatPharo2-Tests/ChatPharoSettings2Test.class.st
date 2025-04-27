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
	settings := ChatPharoSettings2 new.
	mockApi := MockOllamaApi new.
	settings instVarNamed: #ollamaApi put: mockApi.
]

{ #category : 'tests' }
ChatPharoSettings2Test >> testModelsDelegation [
	self
		assert: settings models
		equals: (MockOllamaApi modelNames).

]

{ #category : 'tests' }
ChatPharoSettings2Test >> testUseModel [
	settings useModel: 'mock-advanced'.
	self assert: (mockApi instVarNamed: #currentModel) equals: 'mock-advanced'.
]
