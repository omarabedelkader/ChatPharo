Class {
	#name : 'ChatPharoPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messagesLayout',
		'messageTextField',
		'cancelButton',
		'clearButton',
		'model',
		'notebook',
		'toolbar',
		'connectionStatusLabel'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'adding' }
ChatPharoPresenter >> addNewChat [

    | newPage chatName|
	 chatName := 'Chat ', notebook pages size asString.
	 model newChat.
    newPage := SpNotebookPage
        title: chatName
        icon: (self iconNamed: #announcement)
        provider: [ model chats last presenter ].
    notebook addPage: newPage.
    notebook selectPage: newPage
]

{ #category : 'layout' }
ChatPharoPresenter >> defaultLayout [
	"Layout of ChatPharo. Nicer design wanted..."

    ^ SpBoxLayout newTopToBottom
		  add: toolbar expand: false;
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharoPresenter >> deleteChat: aPageTitle [ 

    "Find the page by title and remove it if found."
    | pageToDelete |
    pageToDelete := notebook pages detect: [:page | page title = aPageTitle] ifNone: [^ self].
    
    (self confirm: 'Are you sure you want to delete this chat?')
        ifTrue: [
            notebook removePage: pageToDelete.
        ].

]

{ #category : 'initialization' }
ChatPharoPresenter >> initializePresenters [

	notebook := self newNotebook.
	toolbar := self newToolbar.

	toolbar add: (SpToolbarButtonPresenter new
			 label: 'New Chat';
			 icon: (self iconNamed: #add);
			 help: 'Create a new chat';
			 action: [ self addNewChat ];
			 yourself).

	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Delete Chat';
			 icon: (self iconNamed: #delete);
			 help: 'Delete the selected chat';
			 action: [ self deleteChat: notebook selectedPage title ];
			 yourself).

	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Save Chat';
			 icon: (self iconNamed: #smallSave);
			 help: 'Save current chat';
			 action: [ self saveCurrentChat ];
			 yourself).

	"toolbar add: (SpToolbarButtonPresenter new
        label: 'Load Chat';
        icon: (self iconNamed: #smallOpen);
        help: 'Load saved chat';
        action: [ self loadChat ];
        yourself)."

	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Settings';
			 icon: (self iconNamed: #smallConfiguration);
			 help: 'Open settings';
			 action: [ self openSettings ];
			 yourself)
]

{ #category : 'initialization' }
ChatPharoPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'ChatPharo';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoPresenter >> notebook [

	^ notebook
]

{ #category : 'initialization' }
ChatPharoPresenter >> notebook: anObject [

	notebook := anObject
]

{ #category : 'initialization' }
ChatPharoPresenter >> openSettings [

	| settingsWindow |
	settingsWindow := model settings presenter.
	settingsWindow open
]

{ #category : 'initialization' }
ChatPharoPresenter >> saveCurrentChat [

    | fileReference jsonData currentChat |
    currentChat := notebook selectedPage presenterProvider value.
    jsonData := STON toStringPretty: (currentChat history model collect: [ :msg |
        Dictionary new
            at: 'role' put: msg role;
            at: 'content' put: msg content;
            yourself
    ]).
    
    fileReference := UIManager default 
        chooseForSaveFileReference: 'Save chat'
        extensions: #('json')
        path: FileLocator home.
        
    fileReference ifNotNil: [
        fileReference writeStream
            nextPutAll: jsonData;
            close
    ]
]

{ #category : 'initialization' }
ChatPharoPresenter >> sendMessage [

	model sendMessage: messageTextField text
]

{ #category : 'accessing - model' }
ChatPharoPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
