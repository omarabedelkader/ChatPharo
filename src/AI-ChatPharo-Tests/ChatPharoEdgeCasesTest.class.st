Class {
	#name : 'ChatPharoEdgeCasesTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-EdgeCases',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'EdgeCases'
}

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testChatWithEmptyMessage [

	| chat message |
	chat := ChatPharoChat new agent: ChatPharoNullAgent new.
	message := ChatPharoMessage new content: ''.
	chat addUserMessage: message.
	self assert: chat messages size equals: 1
]

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithEmptyMandate [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics mandate: ''.
	self assert: ethics mandate isEmpty
]

{ #category : 'tests - extreme values' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithLargeCognitiveLoad [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics cognitiveLoadBudget: 99999.
	self assert: ethics cognitiveLoadBudget equals: 99999
]

{ #category : 'tests - extreme values' }
ChatPharoEdgeCasesTest >> testEthicsDirectorWithLargeTokenBudget [

	| ethics |
	ethics := ChatPharoEthicsDirector new.
	ethics tokenBudget: 1000000.
	self assert: ethics tokenBudget equals: 1000000
]

{ #category : 'tests - extreme values' }
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

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testMultiversStepWithEmptyModel [

	| step |
	step := ChatPharoMultiversStep new.
	step model: ''.
	self assert: step model isEmpty
]

{ #category : 'tests - extreme values' }
ChatPharoEdgeCasesTest >> testMultiversWithLargeNumberOfSteps [

	| multivers |
	multivers := ChatPharoMultivers new.
	50 timesRepeat: [ multivers addStep ].
	self assert: multivers stepsCount equals: 50
]

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testMultiversWithNoSteps [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers enabled: true.
	self deny: multivers canExecute
]

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testMultiversWithOnlyOneStep [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers addStep.
	multivers enabled: true.
	self deny: multivers canExecute
]

{ #category : 'tests - nil handling' }
ChatPharoEdgeCasesTest >> testMultiversWithNilChainTemplate [

	| multivers |
	multivers := ChatPharoMultivers new.
	multivers chainPromptTemplate: nil.
	"Should return default template"
	self assert: multivers chainPromptTemplate isNotNil
]

{ #category : 'tests - skill matching' }
ChatPharoEdgeCasesTest >> testSkillMatchingWithEmptyKeywords [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: (skill matchesKeywords: #())
]

{ #category : 'tests - skill matching' }
ChatPharoEdgeCasesTest >> testSkillMatchingWithSpecialCharacters [

	| skill |
	skill := ChatPharoTestSkill new.
	self deny: (skill matchesKeywords: #('!@#$%^&*()'))
]

{ #category : 'tests - tutorial navigation' }
ChatPharoEdgeCasesTest >> testTutorialGoToNegativeIndex [

	| tutorial |
	tutorial := ChatPharoTutorial new.
	tutorial goToLesson: -10.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'tests - tutorial navigation' }
ChatPharoEdgeCasesTest >> testTutorialGoToVeryLargeIndex [

	| tutorial |
	tutorial := ChatPharoTutorial new.
	tutorial goToLesson: 999999.
	self assert: tutorial currentIndex <= tutorial lessonsCount
]

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithEmptyContent [

	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson content: ''.
	self assert: lesson content isEmpty
]

{ #category : 'tests - empty inputs' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithEmptyTitle [

	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson title: ''.
	self assert: lesson title isEmpty
]

{ #category : 'tests - extreme values' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithVeryLongContent [

	| lesson longContent |
	lesson := ChatPharoTutorialLesson new.
	longContent := String new: 10000 withAll: $a.
	lesson content: longContent.
	self assert: lesson content size equals: 10000
]

{ #category : 'tests - unicode' }
ChatPharoEdgeCasesTest >> testTutorialLessonWithUnicodeCharacters [

	| lesson |
	lesson := ChatPharoTutorialLesson new.
	lesson title: '你好世界 🌍'.
	lesson content: 'Éléphant Ñoño'.
	self assert: (lesson title includesSubstring: '🌍').
	self assert: (lesson content includesSubstring: 'Éléphant')
]
