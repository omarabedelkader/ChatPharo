Class {
	#name : 'ChatPharo',
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
ChatPharo class >> open [
	<example>
	
	^ self new open
]

{ #category : 'layout' }
ChatPharo >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: toolbar expand: false;
		  add: notebook;
		  yourself
]

{ #category : 'specs' }
ChatPharo >> initialExtent [

	| fontWidth rowHeight |
	fontWidth := (StandardFonts defaultFont widthOfString: 'M').
	rowHeight := self class inputTextHeight.

	^ (40@25) * (fontWidth @ rowHeight)
	
]

{ #category : 'initialization' }
ChatPharo >> initializePresenters [

	notebook := self newNotebook.
	toolbar := self newMenuBar.
	notebook addPage: (SpNotebookPage
			 title: 'Chat'
			 icon: (self iconNamed: #announcement)
			 provider: [ ChatPharoSpecChat new ])
]

{ #category : 'specs' }
ChatPharo >> title [
	
	^ 'LLM Chat'
]
