Class {
	#name : 'ChatPharoMemorySettingsTest',
	#superclass : 'TestCase',
	#instVars : [
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-Settings',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
ChatPharoMemorySettingsTest >> setUp [

	super setUp.
	ChatPharoSettings resetDefault.
	settings := ChatPharoSettings new
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> tearDown [

	ChatPharoSettings resetDefault.
	super tearDown
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryAutoSummarizeDefault [ 

	self assert: settings memoryAutoSummarize
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryAutoSummarizePersistence [

	| loaded |
	settings memoryAutoSummarize: false.
	loaded := ChatPharoSettings loadOrNew.
	self deny: loaded memoryAutoSummarize
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryEnabledDefault [

	self assert: settings memoryEnabled
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryEnabledPersistence [

	| loaded |
	settings memoryEnabled: false.
	loaded := ChatPharoSettings loadOrNew.
	self deny: loaded memoryEnabled
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryMaxItemsDefault [

	self assert: settings memoryMaxItems equals: 1000
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryMaxItemsPersistence [

	| loaded |
	settings memoryMaxItems: 500.
	loaded := ChatPharoSettings loadOrNew.
	self assert: loaded memoryMaxItems equals: 500
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryRetentionDaysDefault [

	self assert: settings memoryRetentionDays equals: 30
]

{ #category : 'running' }
ChatPharoMemorySettingsTest >> testMemoryRetentionDaysPersistence [

	| loaded |
	settings memoryRetentionDays: 60.
	loaded := ChatPharoSettings loadOrNew.
	self assert: loaded memoryRetentionDays equals: 60
]
