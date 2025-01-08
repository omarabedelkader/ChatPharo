Class {
	#name : 'LLMAPISpec',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar',
		'notebook'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'examples' }
LLMAPISpec class >> open [
	<example>
	
	^ self new open
]

{ #category : 'layout' }
LLMAPISpec >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: toolbar expand: false;
		  add: notebook;
		  yourself
]

{ #category : 'specs' }
LLMAPISpec >> initialExtent [

	| fontWidth rowHeight |
	fontWidth := (StandardFonts defaultFont widthOfString: 'M').
	rowHeight := self class inputTextHeight.

	^ (40@25) * (fontWidth @ rowHeight)
	
]

{ #category : 'initialization' }
LLMAPISpec >> initializePresenters [

	notebook := self newNotebook.
	toolbar := self newMenuBar.
	notebook addPage: (SpNotebookPage
			 title: 'Chat'
			 icon: (self iconNamed: #announcement)
			 provider: [ LLMAPISpecChat new ])
]

{ #category : 'specs' }
LLMAPISpec >> title [
	
	^ 'LLM Chat'
]
