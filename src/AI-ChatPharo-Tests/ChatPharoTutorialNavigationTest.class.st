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

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testAtEndReturnsFalseAtStart [

	tutorial first.
	self deny: tutorial atEnd
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testAtEndReturnsTrueAtLastLesson [

	tutorial last.
	self assert: tutorial atEnd
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testAtStartReturnsFalseAtEnd [

	tutorial last.
	self deny: tutorial atStart
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testAtStartReturnsTrueAtFirst [

	tutorial first.
	self assert: tutorial atStart
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testCurrentIndexStartsAtOne [

	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testCurrentLessonReturnsLesson [

	| current |
	current := tutorial currentLesson.
	self assert: (current isKindOf: ChatPharoTutorialLesson)
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testFirstGoesToFirstLesson [

	tutorial last.
	tutorial first.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testGoToLessonBoundedByLessonCount [

	tutorial goToLesson: 9999.
	self assert: tutorial currentIndex <= tutorial lessonsCount
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testGoToLessonBoundedByOne [

	tutorial goToLesson: -5.
	self assert: tutorial currentIndex equals: 1
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testGoToLessonSetsIndex [ 
	tutorial goToLesson: 3.
	self assert: tutorial currentIndex equals: 3
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testHasLessons [

	self assert: tutorial lessons isNotEmpty
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testLastGoesToLastLesson [

	tutorial last.
	self assert: tutorial currentIndex equals: tutorial lessonsCount
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testLessonsCountIsPositive [


	self assert: tutorial lessonsCount > 0
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testNextIncrementsIndex [

	| initial |
	tutorial first.
	initial := tutorial currentIndex.
	tutorial next.
	self assert: tutorial currentIndex equals: initial + 1
]

{ #category : 'running' }
ChatPharoTutorialNavigationTest >> testPreviousDecrementsIndex [

	tutorial goToLesson: 3.
	tutorial previous.
	self assert: tutorial currentIndex equals: 2
]
