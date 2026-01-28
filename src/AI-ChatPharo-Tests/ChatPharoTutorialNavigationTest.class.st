Class {
	#name : 'ChatPharoTutorialNavigationTest',
	#superclass : 'TestCase',
	#instVars : [
		'tutorial'
	],
	#category : 'AI-ChatPharo-Tests-Tutorial',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tutorial'
}

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> setUp [

	super setUp.
	tutorial := ChatPharoTutorial new
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> tearDown [

	tutorial := nil.
	super tearDown
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testAtEndReturnsFalseAtStart [

	tutorial first.
	self deny: tutorial atEnd
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testAtEndReturnsTrueAtLastLesson [

	tutorial last.
	self assert: tutorial atEnd
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testAtStartReturnsFalseAtEnd [

	tutorial last.
	self deny: tutorial atStart
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testAtStartReturnsTrueAtFirst [

	tutorial first.
	self assert: tutorial atStart
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testCurrentIndexStartsAtOne [

	self assert: tutorial currentIndex equals: 1
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testCurrentLessonReturnsLesson [

	| current |
	current := tutorial currentLesson.
	self assert: (current isKindOf: ChatPharoTutorialLesson)
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testFirstGoesToFirstLesson [

	tutorial last.
	tutorial first.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testGoToLessonBoundedByLessonCount [

	tutorial goToLesson: 9999.
	self assert: tutorial currentIndex <= tutorial lessonsCount
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testGoToLessonBoundedByOne [

	tutorial goToLesson: -5.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testGoToLessonSetsIndex [

	tutorial goToLesson: 3.
	self assert: tutorial currentIndex equals: 3
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testHasLessons [

	self assert: tutorial lessons isNotEmpty
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testLastGoesToLastLesson [

	tutorial last.
	self assert: tutorial currentIndex equals: tutorial lessonsCount
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testLessonsCountIsPositive [

	self assert: tutorial lessonsCount > 0
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testNextIncrementsIndex [

	| initial |
	tutorial first.
	initial := tutorial currentIndex.
	tutorial next.
	self assert: tutorial currentIndex equals: initial + 1
]

{ #category : 'tests' }
ChatPharoTutorialNavigationTest >> testPreviousDecrementsIndex [

	tutorial goToLesson: 3.
	tutorial previous.
	self assert: tutorial currentIndex equals: 2
]
