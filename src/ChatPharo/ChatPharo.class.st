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

{ #category : 'initialization' }
ChatPharo >> addNewChat [

    | newPage |
    newPage := SpNotebookPage
        title: 'New Chat'
        icon: (self iconNamed: #announcement)
        provider: [ ChatPharoSpecChat new ].
    notebook addPage: newPage.
    notebook selectPage: newPage
]

{ #category : 'layout' }
ChatPharo >> defaultLayout [ 

    ^ SpBoxLayout newTopToBottom
        add: toolbar expand: false;
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharo >> deleteAllChats [

    (self confirm: 'Are you sure you want to delete all chats?')
        ifFalse: [ ^ self ].
    
    notebook removeAll.
    notebook addPage: (SpNotebookPage
        title: 'Chat'
        icon: (self iconNamed: #announcement)
        provider: [ ChatPharoSpecChat new ]).
    notebook selectPageIndex: 1.
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
    toolbar := self newToolbar.
    
    toolbar add: (SpToolbarButtonPresenter new
        label: 'New Chat';
        icon: (self iconNamed: #add);
        help: 'Create a new chat';
        action: [ self addNewChat ];
        yourself).
        
    toolbar add: (SpToolbarButtonPresenter new
        label: 'Delete All';
        icon: (self iconNamed: #delete);
        help: 'Delete all chats';
        action: [ self deleteAllChats ];
        yourself).
    
    notebook addPage: (SpNotebookPage
        title: 'Chat'
        icon: (self iconNamed: #announcement)
        provider: [ ChatPharoSpecChat new ])
]

{ #category : 'accessing' }
ChatPharo >> notebook [

	^ notebook
]

{ #category : 'accessing' }
ChatPharo >> notebook: anObject [

	notebook := anObject
]

{ #category : 'specs' }
ChatPharo >> title [
	
	^ 'ChatPharo'
]

{ #category : 'accessing' }
ChatPharo >> toolbar [

	^ toolbar
]

{ #category : 'accessing' }
ChatPharo >> toolbar: anObject [

	toolbar := anObject
]
