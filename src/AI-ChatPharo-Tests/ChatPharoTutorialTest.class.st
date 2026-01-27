Class {
	#name : 'ChatPharoTutorialTest',
	#superclass : 'TestCase',
	#instVars : [
		'tutorial'
	],
	#category : 'AI-ChatPharo-Tests-Tutorial',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tutorial'
}

{ #category : 'running' }
ChatPharoTutorialTest >> setUp [

	super setUp.
	ChatPharoTutorial resetDefault.
	ChatPharoSettings resetDefault.
	tutorial := ChatPharoTutorial new
]

{ #category : 'running' }
ChatPharoTutorialTest >> tearDown [

	ChatPharoTutorial resetDefault.
	ChatPharoSettings resetDefault.
	super tearDown
]

{ #category : 'running' }
ChatPharoTutorialTest >> testAtEndFalseAtBeginning [

	self deny: tutorial atEnd
]

{ #category : 'running' }
ChatPharoTutorialTest >> testAtStartTrueAtBeginning [

	self assert: tutorial atStart
]

{ #category : 'running' }
ChatPharoTutorialTest >> testCurrentLessonFallsBackToFirstWhenOutOfRange [

	tutorial instVarNamed: 'currentIndex' put: 999.
	self assert: tutorial currentLesson equals: tutorial lessons first
]

{ #category : 'running' }
ChatPharoTutorialTest >> testDefaultReturnsSingleton [

	self assert: ChatPharoTutorial default identicalTo: ChatPharoTutorial default
]

{ #category : 'running' }
ChatPharoTutorialTest >> testFirstSetsIndexToOne [

	tutorial goToLesson: 5.
	tutorial first.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialTest >> testGoToLessonClampsHigh [

	tutorial goToLesson: 999.
	self assert: tutorial currentIndex equals: tutorial lessonsCount
]

{ #category : 'running' }
ChatPharoTutorialTest >> testGoToLessonClampsLow [

	tutorial goToLesson: 0.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialTest >> testInitializeStartsAtFirstLesson [

	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialTest >> testLastSetsIndexToEnd [

	tutorial last.
	self assert: tutorial atEnd
]

{ #category : 'running' }
ChatPharoTutorialTest >> testLessonActionExecution [

	| lesson ran |
	ran := false.
	lesson := ChatPharoTutorialLesson new.
	lesson lessonAction: [ ran := true ].
	lesson performAction.
	self assert: ran
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testLessonCodeExamplePresence [

	| lesson |
	lesson := ChatPharoTutorialLesson title: 'Title' content: 'Content' code: '1 + 2'.
	self assert: lesson hasCodeExample
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testLessonDefaults [

	| lesson |
	lesson := ChatPharoTutorialLesson new.
	self assert: lesson title equals: 'Untitled Lesson'.
	self assert: lesson content equals: ''
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testLessonIconDefault [

	| lesson |
	lesson := ChatPharoTutorialLesson new.
	self assert: lesson iconName equals: #smallHelp
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testLessonsCountIsFourteen [

	self assert: tutorial lessonsCount equals: 14
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testLessonsNotEmpty [

	self deny: tutorial lessons isEmpty
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testNextAdvancesIndex [

	tutorial next.
	self assert: tutorial currentIndex equals: 2
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testPreviousDoesNotGoBeforeStart [

	tutorial previous.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialTest >> testProgressPercentAtEnd [

	tutorial last.
	self assert: tutorial progressPercent equals: 100
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testProgressPercentAtStart [

	self assert: tutorial progressPercent equals: 7
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testProgressStringFormat [

	self assert: tutorial progress equals: '1/14'
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testResetDefaultCreatesNewInstance [

	| first second |
	first := ChatPharoTutorial default.
	ChatPharoTutorial resetDefault.
	second := ChatPharoTutorial default.
	self deny: first identicalTo: second
]

{ #category : 'tests' }
ChatPharoTutorialTest >> testTutorialCompletedUpdatesSettings [

	ChatPharoSettings default tutorialCompleted: false.
	tutorial tutorialCompleted.
	self assert: ChatPharoSettings default tutorialCompleted
]
