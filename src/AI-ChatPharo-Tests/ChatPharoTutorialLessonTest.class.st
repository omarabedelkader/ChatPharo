Class {
	#name : 'ChatPharoTutorialLessonTest',
	#superclass : 'TestCase',
	#instVars : [
		'lesson'
	],
	#category : 'AI-ChatPharo-Tests-Tutorial',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tutorial'
}

{ #category : 'running' }
ChatPharoTutorialLessonTest >> setUp [

	super setUp.
	lesson := ChatPharoTutorialLesson new
]

{ #category : 'running' }
ChatPharoTutorialLessonTest >> tearDown [

	lesson := nil.
	super tearDown
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testCodeExampleSetAndGet [

	lesson codeExample: '1 + 1'.
	self assert: lesson codeExample equals: '1 + 1'
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testContentSetAndGet [

	lesson content: 'Test content'.
	self assert: lesson content equals: 'Test content'
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testCreateWithTitleAndContent [

	| createdLesson |
	createdLesson := ChatPharoTutorialLesson title: 'Test' content: 'Content'.
	self assert: createdLesson title equals: 'Test'.
	self assert: createdLesson content equals: 'Content'
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testCreateWithTitleContentAndCode [

	| createdLesson |
	createdLesson := ChatPharoTutorialLesson title: 'Test' content: 'Content' code: '1 + 1'.
	self assert: createdLesson title equals: 'Test'.
	self assert: createdLesson content equals: 'Content'.
	self assert: createdLesson codeExample equals: '1 + 1'
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testCreateWithTitleContentAndIcon [

	| createdLesson |
	createdLesson := ChatPharoTutorialLesson title: 'Test' content: 'Content' icon: #smallHelp.
	self assert: createdLesson title equals: 'Test'.
	self assert: createdLesson content equals: 'Content'.
	self assert: createdLesson iconName equals: #smallHelp
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testCreateWithTitleContentCodeAndIcon [

	| createdLesson |
	createdLesson := ChatPharoTutorialLesson title: 'Test' content: 'Content' code: '1 + 1' icon: #smallHelp.
	self assert: createdLesson title equals: 'Test'.
	self assert: createdLesson content equals: 'Content'.
	self assert: createdLesson codeExample equals: '1 + 1'.
	self assert: createdLesson iconName equals: #smallHelp
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testHasCodeExampleReturnsFalseWhenEmpty [

	lesson codeExample: ''.
	self deny: lesson hasCodeExample
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testHasCodeExampleReturnsFalseWhenNil [

	self deny: lesson hasCodeExample
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testHasCodeExampleReturnsTrueWhenSet [

	lesson codeExample: '1 + 1'.
	self assert: lesson hasCodeExample
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testHasLessonActionReturnsFalseWhenNil [

	self deny: lesson hasLessonAction
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testHasLessonActionReturnsTrueWhenSet [

	lesson lessonAction: [ 1 + 1 ].
	self assert: lesson hasLessonAction
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testIconNameDefaultsToSmallHelp [

	self assert: lesson iconName equals: #smallHelp
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testIconNameSetAndGet [

	lesson iconName: #announcement.
	self assert: lesson iconName equals: #announcement
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testInitializeDefaults [

	self assert: lesson title equals: 'Untitled Lesson'.
	self assert: lesson content isEmpty
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testLessonActionSetAndGet [

	| block |
	block := [ 1 + 1 ].
	lesson lessonAction: block.
	self assert: lesson lessonAction equals: block
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testPerformActionExecutesBlock [

	| executed |
	executed := false.
	lesson lessonAction: [ executed := true ].
	lesson performAction.
	self assert: executed
]

{ #category : 'tests' }
ChatPharoTutorialLessonTest >> testTitleSetAndGet [

	lesson title: 'New Title'.
	self assert: lesson title equals: 'New Title'
]
