Class {
	#name : 'ChatPharoSettingsTest',
	#superclass : 'TestCase',
	#instVars : [
		'history',
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoSettingsTest >> setUp [

	super setUp.
	settings := ChatPharoSettings new.
	settings chatSettings: (ChatPharo new).
]

{ #category : 'running' }
ChatPharoSettingsTest >> tearDown [ 

	settings := nil.
	super tearDown.
]

{ #category : 'running' }
ChatPharoSettingsTest >> testInitialSettingsNotebook [

	settings open.
	settings delete.
	
	self assert: settings notebook pages size equals: 3.
	self assert: (settings notebook pages anySatisfy: [:p | p title = 'Chat']).
	self assert: (settings notebook pages anySatisfy: [:p | p title = 'API']).
	self assert: (settings notebook pages anySatisfy: [:p | p title = 'Configuration']).
]
