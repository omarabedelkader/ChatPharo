"
Interactive tutorial presenter for ChatPharo, inspired by ProfStef.
Displays lessons in a clean, focused interface with navigation controls.
Supports code examples that can be copied or executed.
Usage:
```smalltalk
ChatPharoTutorialPresenter on: ChatPharoTutorial default.
```
"
Class {
	#name : 'ChatPharoTutorialPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'tutorial',
		'titleLabel',
		'progressLabel',
		'contentText',
		'codeText',
		'codeContainer',
		'previousButton',
		'nextButton',
		'closeButton',
		'copyCodeButton',
		'executeCodeButton',
		'progressBar',
		'iconImage'
	],
	#classInstVars : [
		'tutorial'
	],
	#category : 'AI-ChatPharo-Spec-Tutorial',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Tutorial'
}

{ #category : 'instance creation' }
ChatPharoTutorialPresenter class >> on: aTutorial [
	"Create a presenter for the given tutorial"

	^ self new
		tutorial: aTutorial;
		yourself
]

{ #category : 'instance creation' }
ChatPharoTutorialPresenter class >> open [
	"Open a new tutorial presenter"

	^ (self on: ChatPharoTutorial default) open
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> close [
	"Close the tutorial"

	tutorial tutorialCompleted.
	self window close
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> defaultLayout [

	| headerLayout navigationLayout mainLayout codeLayout |

	headerLayout := SpBoxLayout newHorizontal
		spacing: 12;
		vAlignCenter;
		add: iconImage expand: false;
		add: (SpBoxLayout newTopToBottom
			spacing: 4;
			add: titleLabel expand: false;
			add: progressLabel expand: false;
			yourself) expand: true;
		yourself.

	codeLayout := SpBoxLayout newTopToBottom
		spacing: 8;
		add: codeText expand: true;
		add: (SpBoxLayout newHorizontal
			spacing: 8;
			add: copyCodeButton expand: false;
			add: executeCodeButton expand: false;
			yourself) expand: false;
		yourself.

	navigationLayout := SpBoxLayout newHorizontal
		spacing: 12;
		hAlignCenter;
		add: previousButton expand: false;
		add: nextButton expand: false;
		add: closeButton expand: false;
		yourself.

	mainLayout := SpBoxLayout newTopToBottom
		spacing: 16;
		borderWidth: 20;
		add: headerLayout expand: false;
		add: progressBar expand: false;
		add: contentText expand: true;
		add: codeContainer expand: false;
		add: navigationLayout expand: false;
		yourself.

	^ mainLayout
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> doCopyCode [
	"Copy the code example to clipboard"

	| code |
	code := codeText text.
	code ifNotEmpty: [
		Clipboard clipboardText: code.
		self inform: 'Code copied to clipboard!' ]
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> doExecuteCode [
	"Execute the code example"

	| code |
	code := codeText text.
	code ifNotEmpty: [
		[ Smalltalk compiler evaluate: code ]
			on: Error
			do: [ :ex | self inform: 'Error: ', ex messageText ] ]
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> goNext [
	"Navigate to the next lesson"

	tutorial atEnd ifTrue: [
		self close.
		^ self ].

	tutorial next.
	self updateDisplay
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> goPrevious [
	"Navigate to the previous lesson"

	tutorial previous.
	self updateDisplay
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> initialize [

	super initialize.
	tutorial := ChatPharoTutorial default
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> initializePresenters [

	super initializePresenters.

	iconImage := self newImage
		             image: (self iconNamed: #announcement);
		             yourself.

	titleLabel := self newLabel
		              label: 'Welcome to ChatPharo!';
		              yourself.

	progressLabel := self newLabel
		                 label: 'Lesson 1/16';
		                 yourself.

	progressBar := self newProgressBar
		               fixedAt: 0;
		               yourself.

	contentText := self newText
		               beNotEditable;
		               yourself.

	codeText := self newCode
		            beForScripting;
		            yourself.

	codeContainer := SpBoxLayout newTopToBottom
		                 spacing: 8;
		                 add: (self newLabel label: 'Try this code:') expand: false;
		                 add: codeText height: 180;
		                 add: (SpBoxLayout newHorizontal
				                  spacing: 8;
				                  add: (copyCodeButton := self newButton
						                                     label: 'Copy';
						                                     icon: (self iconNamed: #smallCopy);
						                                     action: [ self doCopyCode ];
						                                     yourself)
				                  expand: false;
				                  add: (executeCodeButton := self newButton
						                                        label: 'Do it';
						                                        icon: (self iconNamed: #smallDoIt);
						                                        action: [ self doExecuteCode ];
						                                        yourself)
				                  expand: false;
				                  yourself)
		                 expand: false;
		                 yourself.

	previousButton := self newButton
		                  label: 'Previous';
		                  icon: (self iconNamed: #glamorousLeft);
		                  action: [ self goPrevious ];
		                  yourself.

	nextButton := self newButton
		              label: 'Next';
		              icon: (self iconNamed: #glamorousRight);
		              action: [ self goNext ];
		              yourself.

	closeButton := self newButton
		               label: 'Close';
		               icon: (self iconNamed: #glamorousClose);
		               action: [ self close ];
		               yourself
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'ChatPharo Tutorial';
		initialExtent: 600@500;
		centered
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> tutorial [
	"Return the tutorial model"

	^ tutorial
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> tutorial: aTutorial [
	"Set the tutorial model"

	tutorial := aTutorial.
	self updateDisplay
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> updateCodeSection [
	"Update the code section visibility and content"

	| lesson hasCode |
	lesson := tutorial currentLesson.
	hasCode := lesson hasCodeExample.

	hasCode
		ifTrue: [
				codeText text: lesson codeExample.
				codeContainer := SpBoxLayout newTopToBottom
					                 spacing: 8;
					                 add: (self newLabel label: 'Try this code:') expand: false;
					                 add: codeText height: 180;
					                 add: (SpBoxLayout newHorizontal
							                  spacing: 8;
							                  add: copyCodeButton expand: false;
							                  add: executeCodeButton expand: false;
							                  yourself)
					                 expand: false;
					                 yourself ]
		ifFalse: [
				codeText text: ''.
				codeContainer := SpBoxLayout newTopToBottom yourself ]
]

{ #category : 'initialization' }
ChatPharoTutorialPresenter >> updateDisplay [
	"Update all display elements for the current lesson"

	| lesson |
	lesson := tutorial currentLesson.

	"Update header"
	titleLabel label: lesson title.
	progressLabel label: 'Lesson ', tutorial progress.
	iconImage image: (self iconNamed: lesson iconName).

	"Update progress bar"
	progressBar fixedAt: tutorial progressPercent / 100.0.

	"Update content"
	contentText text: lesson content.

	"Update code section"
	self updateCodeSection.

	"Update navigation buttons"
	previousButton enabled: tutorial atStart not.
	nextButton label: (tutorial atEnd ifTrue: [ 'Finish' ] ifFalse: [ 'Next' ]).

	"Perform any lesson action"
	lesson performAction.

	"Refresh layout"
	self layout: self defaultLayout
]
