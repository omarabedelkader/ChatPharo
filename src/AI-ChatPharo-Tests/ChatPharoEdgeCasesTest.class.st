Class {
	#name : 'ChatPharoEdgeCasesTest',
	#superclass : 'TestCase',
	#instVars : [
		'agent'
	],
	#category : 'AI-ChatPharo-Tests-Director',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Director'
}

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testChatWithEmptyMessage [

	| chat message |
	chat := ChatPharoChat new agent: ChatPharoNullAgent new.
	message := ChatPharoMessage new content: ''.
	chat addUserMessage: message.
	self assert: chat messages size equals: 1
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithEmptyMandate [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics mandate: ''.
	self assert: ethics mandate isEmpty
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithLargeCognitiveLoad [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics cognitiveLoadBudget: 99999.
	self assert: ethics cognitiveLoadBudget equals: 99999
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithLargeTokenBudgets [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics tokenBudget: 1000000.
	self assert: ethics tokenBudget equals: 1000000
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithZeroBudgets [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics cognitiveLoadBudget: 0.
	ethics tokenBudget: 0.
	ethics timeBudgetMinutes: 0.
	self assert: ethics cognitiveLoadBudget equals: 0.
	self assert: ethics tokenBudget equals: 0.
	self assert: ethics timeBudgetMinutes equals: 0
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testMultiversStepWithEmptyModel [

	| step |
	step := ChatPharoMultiversStep new.
	step model: ''.
	self assert: step model isEmpty
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testMultiversWithLargeNumberOfSteps [

	| multivers |
	multivers := ChatPharoMultivers new.
	50 timesRepeat: [ multivers addStep ].
	self assert: multivers stepsCount equals: 50
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testMultiversWithNilChainTemplate [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers chainPromptTemplate: nil.
	"Should return default template"
	self assert: multivers chainPromptTemplate isNotNil
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testMultiversWithNoSteps [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers enabled: true.
	self deny: multivers canExecute
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testMultiversWithOnlyOneStep [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers addStep.
	multivers enabled: true.
	self deny: multivers canExecute
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testSkillMatchingWithEmptyKeywords [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: (skill matchesKeywords: #())
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testSkillMatchingWithSpecialCharacters [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: (skill matchesKeywords: #('!@#$%^&*()'))
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialGoToNegativeIndex [

	| tutorial |
	tutorial := ChatPharoTutorial new.
	tutorial goToLesson: -10.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialGoToVeryLargeIndex [
	| tutorial |
	tutorial := ChatPharoTutorial new.
	tutorial goToLesson: 999999.
	self assert: tutorial currentIndex <= tutorial lessonsCount
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithEmptyContent [
	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson content: ''.
	self assert: lesson content isEmpty
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithEmptyTitle [
	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson title: ''.
	self assert: lesson title isEmpty
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithUnicodeCharacters [
	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson title: '你好世界 🌍'.
	lesson content: 'Éléphant Ñoño'.
	self assert: (lesson title includesSubstring: '🌍').
	self assert: (lesson content includesSubstring: 'Éléphant')
]

{ #category : 'tests' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithVeryLongContent [
	| lesson longContent |
	lesson := ChatPharoTutorialLesson new.
	longContent := String new: 10000 withAll: $a.
	lesson content: longContent.
	self assert: lesson content size equals: 10000
]
