Class {
	#name : 'ChatPharoAskCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'originalAskFeatureEnabled'
	],
	#category : 'AI-ChatPharo-Tests-Env',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Env'
}

{ #category : 'running' }
ChatPharoAskCommandTest >> setUp [

	super setUp.
	originalAskFeatureEnabled := ChatPharoSettings default askFeatureEnabled
]

{ #category : 'running' }
ChatPharoAskCommandTest >> tearDown [

	ChatPharoSettings default askFeatureEnabled: originalAskFeatureEnabled.
	super tearDown
]

{ #category : 'running' }
ChatPharoAskCommandTest >> testCanBeExecutedInContextFalseWhenDisabled [

	| context |
	ChatPharoSettings default askFeatureEnabled: false.
	context := ChatPharoCommandContextStub withSelectedMethodItems: {
		ChatPharoCommandElementStub withBrowserItem:
			(ChatPharoCommandBrowserItemStub withActualObject: Object new) }.
	self deny: (ChatPharoAskCommand canBeExecutedInContext: context)
]

{ #category : 'running' }
ChatPharoAskCommandTest >> testCanBeExecutedInContextFalseWhenEmptySelection [

	| context |
	ChatPharoSettings default askFeatureEnabled: true.
	context := ChatPharoCommandContextStub withSelectedMethodItems: #().
	self deny: (ChatPharoAskCommand canBeExecutedInContext: context)
]

{ #category : 'running' }
ChatPharoAskCommandTest >> testCanBeExecutedInContextTrueWhenEnabledAndSelected [

	| context |
	ChatPharoSettings default askFeatureEnabled: true.
	context := ChatPharoCommandContextStub withSelectedMethodItems: {
		ChatPharoCommandElementStub withBrowserItem:
			(ChatPharoCommandBrowserItemStub withActualObject: Object new) }.
	self assert: (ChatPharoAskCommand canBeExecutedInContext: context)
]
