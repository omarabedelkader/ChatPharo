Class {
	#name : 'ChatPharoEthicsDirectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'ethics'
	],
	#category : 'AI-ChatPharo-Tests-Director',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Director'
}

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> setUp [

	super setUp.
	ethics := ChatPharoEthicsDirector new
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> tearDown [

	ethics := nil.
	super tearDown
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testEnabledSetAndGet [

	ethics enabled: false.
	self deny: ethics enabled.
	ethics enabled: true.
	self assert: ethics enabled
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testInitializeDefaults [

	self assert: ethics enabled.
	self assert: ethics mandate isEmpty.
	self assert: ethics cognitiveLoadBudget equals: 120.
	self assert: ethics tokenBudget equals: 4096.
	self assert: ethics timeBudgetMinutes equals: 30.
	self assert: ethics messageLimit equals: 50
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMandateDefaultsToEmpty [

	self assert: ethics mandate isEmpty
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMandateLongText [

	| longMandate |
	longMandate := String new: 1000 withAll: $a.
	ethics mandate: longMandate.
	self assert: ethics mandate equals: longMandate
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMandateSetAndGet [

	ethics mandate: 'Be helpful and safe'.
	self assert: ethics mandate equals: 'Be helpful and safe'
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMessageLimitDefaultValue [

	self assert: ethics messageLimit equals: 50
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMessageLimitLargeValue [

	ethics messageLimit: 10000.
	self assert: ethics messageLimit equals: 10000
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMessageLimitSetAndGet [

	ethics messageLimit: 100.
	self assert: ethics messageLimit equals: 100
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testMessageLimitSmallValue [

	ethics messageLimit: 1.
	self assert: ethics messageLimit equals: 1
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTimeBudgetDefaultValue [


	self assert: ethics timeBudgetMinutes equals: 30
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTimeBudgetLongDuration [

	ethics timeBudgetMinutes: 480.
	self assert: ethics timeBudgetMinutes equals: 480
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTimeBudgetSetAndGet [

	ethics timeBudgetMinutes: 60.
	self assert: ethics timeBudgetMinutes equals: 60
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTimeBudgetShortDuration [

	ethics timeBudgetMinutes: 5.
	self assert: ethics timeBudgetMinutes equals: 5
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTokenBudgetDefaultValue [

	self assert: ethics tokenBudget equals: 4096
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTokenBudgetLargeValue [

	ethics tokenBudget: 100000.
	self assert: ethics tokenBudget equals: 100000
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTokenBudgetSetAndGet [

	ethics tokenBudget: 8192.
	self assert: ethics tokenBudget equals: 8192
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testTokenBudgetSmallValue [

	ethics tokenBudget: 100.
	self assert: ethics tokenBudget equals: 100
]

{ #category : 'running' }
ChatPharoEthicsDirectorTest >> testgeneraltests [

	self assert: ethics cognitiveLoadBudget equals: 120.

	ethics cognitiveLoadBudget: 150.
	self assert: ethics cognitiveLoadBudget equals: 150.

	ethics cognitiveLoadBudget: 0.
	self assert: ethics cognitiveLoadBudget equals: 0.

	self assert: ethics enabled
]
