"
Displays the detailed thinking content from Claude AI.
Shows the complete thought process that occurs during AI responses.
"
Class {
	#name : 'ChatPharoThinkingDetailPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleLabel',
		'thinkingText',
		'closeButton',
		'thinkingContent'
	],
	#category : 'AI-ChatPharo-Spec-Ethics',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Ethics'
}

{ #category : 'layout' }
ChatPharoThinkingDetailPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		spacing: 10;
		add: titleLabel expand: false;
		add: thinkingText;
		add: closeButton expand: false;
		yourself
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> initialize [

	super initialize.
	thinkingContent := ''
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> initializePresenters [

	titleLabel := self newLabel
		              label: 'Thinking Details';
		              yourself.
	thinkingText := self newText
		                text: '';
		                editable: false;
		                yourself.
	closeButton := self newButton
		               label: 'Close';
		               action: [ self window close ];
		               yourself
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Thinking Details';
		initialExtent: 800 @ 600
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> thinkingContent [
	"Return the current thinking content"

	^ thinkingContent
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> thinkingContent: aString [
	"Set the thinking content and update the display"

	thinkingContent := aString.
	self updateThinkingText
]

{ #category : 'initialization' }
ChatPharoThinkingDetailPresenter >> updateThinkingText [
	"Update the text area with the current thinking content"

	thinkingText text: (thinkingContent ifNil: [ 'No thinking content available' ])
]
