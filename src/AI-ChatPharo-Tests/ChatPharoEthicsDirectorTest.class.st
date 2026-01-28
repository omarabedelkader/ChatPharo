Class {
	#name : 'ChatPharoEthicsDirectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'ethics'
	],
	#category : 'AI-ChatPharo-Tests-Ethics',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ethics'
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

{ #category : 'tests - cognitive load' }
ChatPharoEthicsDirectorTest >> testCognitiveLoadBudgetDefaultValue [

	self assert: ethics cognitiveLoadBudget equals: 120
]

{ #category : 'tests - cognitive load' }
ChatPharoEthicsDirectorTest >> testCognitiveLoadBudgetSetAndGet [

	ethics cognitiveLoadBudget: 150.
	self assert: ethics cognitiveLoadBudget equals: 150
]

{ #category : 'tests - cognitive load' }
ChatPharoEthicsDirectorTest >> testCognitiveLoadBudgetSetToZero [

	ethics cognitiveLoadBudget: 0.
	self assert: ethics cognitiveLoadBudget equals: 0
]

{ #category : 'tests - enable/disable' }
ChatPharoEthicsDirectorTest >> testEnabledDefaultsToTrue [

	self assert: ethics enabled
]

{ #category : 'tests - enable/disable' }
ChatPharoEthicsDirectorTest >> testEnabledSetAndGet [

	ethics enabled: false.
	self deny: ethics enabled.
	ethics enabled: true.
	self assert: ethics enabled
]

{ #category : 'tests - initialization' }
ChatPharoEthicsDirectorTest >> testInitializeDefaults [

	self assert: ethics enabled.
	self assert: ethics mandate isEmpty.
	self assert: ethics cognitiveLoadBudget equals: 120.
	self assert: ethics tokenBudget equals: 4096.
	self assert: ethics timeBudgetMinutes equals: 30.
	self assert: ethics messageLimit equals: 50
]

{ #category : 'tests - mandate' }
ChatPharoEthicsDirectorTest >> testMandateDefaultsToEmpty [

	self assert: ethics mandate isEmpty
]

{ #category : 'tests - mandate' }
ChatPharoEthicsDirectorTest >> testMandateLongText [

	| longMandate |
	longMandate := String new: 1000 withAll: $a.
	ethics mandate: longMandate.
	self assert: ethics mandate equals: longMandate
]

{ #category : 'tests - mandate' }
ChatPharoEthicsDirectorTest >> testMandateSetAndGet [

	ethics mandate: 'Be helpful and safe'.
	self assert: ethics mandate equals: 'Be helpful and safe'
]

{ #category : 'tests - message limit' }
ChatPharoEthicsDirectorTest >> testMessageLimitDefaultValue [

	self assert: ethics messageLimit equals: 50
]

{ #category : 'tests - message limit' }
ChatPharoEthicsDirectorTest >> testMessageLimitLargeValue [

	ethics messageLimit: 10000.
	self assert: ethics messageLimit equals: 10000
]

{ #category : 'tests - message limit' }
ChatPharoEthicsDirectorTest >> testMessageLimitSetAndGet [

	ethics messageLimit: 100.
	self assert: ethics messageLimit equals: 100
]

{ #category : 'tests - message limit' }
ChatPharoEthicsDirectorTest >> testMessageLimitSmallValue [

	ethics messageLimit: 1.
	self assert: ethics messageLimit equals: 1
]

{ #category : 'tests - time budget' }
ChatPharoEthicsDirectorTest >> testTimeBudgetDefaultValue [

	self assert: ethics timeBudgetMinutes equals: 30
]

{ #category : 'tests - time budget' }
ChatPharoEthicsDirectorTest >> testTimeBudgetLongDuration [

	ethics timeBudgetMinutes: 480.
	self assert: ethics timeBudgetMinutes equals: 480
]

{ #category : 'tests - time budget' }
ChatPharoEthicsDirectorTest >> testTimeBudgetSetAndGet [

	ethics timeBudgetMinutes: 60.
	self assert: ethics timeBudgetMinutes equals: 60
]

{ #category : 'tests - time budget' }
ChatPharoEthicsDirectorTest >> testTimeBudgetShortDuration [

	ethics timeBudgetMinutes: 5.
	self assert: ethics timeBudgetMinutes equals: 5
]

{ #category : 'tests - token budget' }
ChatPharoEthicsDirectorTest >> testTokenBudgetDefaultValue [

	self assert: ethics tokenBudget equals: 4096
]

{ #category : 'tests - token budget' }
ChatPharoEthicsDirectorTest >> testTokenBudgetLargeValue [

	ethics tokenBudget: 100000.
	self assert: ethics tokenBudget equals: 100000
]

{ #category : 'tests - token budget' }
ChatPharoEthicsDirectorTest >> testTokenBudgetSetAndGet [

	ethics tokenBudget: 8192.
	self assert: ethics tokenBudget equals: 8192
]

{ #category : 'tests - token budget' }
ChatPharoEthicsDirectorTest >> testTokenBudgetSmallValue [

	ethics tokenBudget: 100.
	self assert: ethics tokenBudget equals: 100
]
