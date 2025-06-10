Class {
	#name : 'ChatPharoBrowserIntegrationTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent',
		'browser'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoBrowserIntegrationTest >> setUp [ 

    super setUp.
    ChatPharoSettings resetDefault.
    agent := PackageTrackingAgent new.
    ChatPharoSettings default instVarNamed: #agent put: agent.
    browser := ChatPharoBrowser new.
    browser packageName: 'MyPkg'.
]

{ #category : 'running' }
ChatPharoBrowserIntegrationTest >> tearDown [ 

    ChatPharoSettings resetDefault.
    super tearDown

]

{ #category : 'running' }
ChatPharoBrowserIntegrationTest >> testBuildUpdatesAgentPackageName [ 

    browser build.
    self assert: agent lastPackage equals: 'MyPkg'.
]
