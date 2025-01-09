"
### `ChatPharo` Class
Represents a GUI presenter for a chat application using the Pharo Smalltalk environment.

- **`open`**: Opens a new instance of the chat presenter.
- **`defaultLayout`**: Defines the vertical layout for the chat including toolbar and notebook.
- **`initialExtent`**: Calculates the initial size of the window based on font size and row height.
- **`initializePresenters`**: Initializes the components like the notebook and toolbar.
- **`title`**: Provides the title for the chat window.
"
Class {
	#name : 'ChatPharo',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar',
		'notebook',
		'openStatus'
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
ChatPharo >> close [
    "Close the chat."
    openStatus := false.
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

{ #category : 'layout' }
ChatPharo >> initialize [
    super initialize.
    openStatus := false.
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

{ #category : 'layout' }
ChatPharo >> isOpen [
    "Return whether the chat is open."
    ^ openStatus
]

{ #category : 'layout' }
ChatPharo >> open [
    "Open the chat."
    openStatus := true.
]

{ #category : 'specs' }
ChatPharo >> title [
	
	^ 'ChatPharo'
]
