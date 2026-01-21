"
A single lesson in the ChatPharo tutorial.
Each lesson has:
* A title describing the topic
* Content explaining the concept
* Optional code example that can be executed
* Optional action to perform (like highlighting a UI element)
Example:
```smalltalk
ChatPharoTutorialLesson new
	title: 'Welcome to ChatPharo';
	content: 'ChatPharo is your AI-powered assistant for Pharo development.';
	yourself.
```
"
Class {
	#name : 'ChatPharoTutorialLesson',
	#superclass : 'Object',
	#instVars : [
		'title',
		'content',
		'codeExample',
		'lessonAction',
		'iconName'
	],
	#category : 'AI-ChatPharo-Tutorial',
	#package : 'AI-ChatPharo-Tutorial'
}

{ #category : 'as yet unclassified' }
ChatPharoTutorialLesson class >> title: aTitle content: aContent [
	"Create a basic lesson with title and content"

	^ self new
		title: aTitle;
		content: aContent;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoTutorialLesson class >> title: aTitle content: aContent code: aCodeString [
	"Create a lesson with title, content, and code example"

	^ self new
		title: aTitle;
		content: aContent;
		codeExample: aCodeString;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoTutorialLesson class >> title: aTitle content: aContent code: aCodeString icon: anIconName [
	"Create a lesson with title, content, code example, and icon"

	^ self new
		title: aTitle;
		content: aContent;
		codeExample: aCodeString;
		iconName: anIconName;
		yourself
]

{ #category : 'as yet unclassified' }
ChatPharoTutorialLesson class >> title: aTitle content: aContent icon: anIconName [
	"Create a lesson with title, content, and icon"

	^ self new
		title: aTitle;
		content: aContent;
		iconName: anIconName;
		yourself
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> codeExample [
	"Return the optional code example for this lesson"

	^ codeExample
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> codeExample: aString [
	"Set the code example for this lesson"

	codeExample := aString
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> content [
	"Return the lesson content/explanation"

	^ content
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> content: aString [
	"Set the lesson content"

	content := aString
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> hasCodeExample [
	"Return true if this lesson has a code example"

	^ codeExample isNotNil and: [ codeExample isNotEmpty ]
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> hasLessonAction [
	"Return true if this lesson has an action to perform"

	^ lessonAction isNotNil
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> iconName [
	"Return the icon name for this lesson"

	^ iconName ifNil: [ #smallHelp ]
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> iconName: aSymbol [
	"Set the icon name for this lesson"

	iconName := aSymbol
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> initialize [

	super initialize.
	title := 'Untitled Lesson'.
	content := ''.
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> lessonAction [
	"Return the optional action block for this lesson"

	^ lessonAction
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> lessonAction: aBlock [
	"Set an action to perform when this lesson is shown"

	lessonAction := aBlock
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> performAction [
	"Execute the lesson action if one exists"

	self hasLessonAction ifTrue: [ lessonAction value ]
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> title [
	"Return the lesson title"

	^ title
]

{ #category : 'accessing' }
ChatPharoTutorialLesson >> title: aString [
	"Set the lesson title"

	title := aString
]
