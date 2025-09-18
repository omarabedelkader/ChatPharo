"
Shell window that shows a toolbar and a notebook of chats. Lets the user create/delete/save chats and open the global settings dialog.
"
Class {
	#name : 'ChatPharoPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messageTextField',
		'model',
		'notebook',
		'toolbar',
		'connectionStatusLabel'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'adding' }
ChatPharoPresenter >> addNewChat [

	| newPage chatName |
	chatName := 'Chat ' , notebook pages size asString.
	model newChat.
	newPage := SpNotebookPage title: chatName icon: (self iconNamed: #announcement) provider: [ model chats last presenter ].
	notebook addPage: newPage.
	notebook selectPage: newPage.
	ChatPharoLogger logFrontend: 'UI added new chat tab'
            details: (Dictionary new
                    at: 'title' put: chatName;
                    at: 'totalTabs' put: notebook pages size;
                    yourself)
]

{ #category : 'layout' }
ChatPharoPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: toolbar expand: false;
		  add: notebook;
		  yourself
]

{ #category : 'adding' }
ChatPharoPresenter >> deleteAllChats [

	| removed |
	(self confirm: 'Are you sure you want to delete all chats?') ifFalse: [ ^ self ].
	removed := notebook pages size.
	notebook pages copy do: [ :page | notebook removePage: page ].
	model removeAllChats.
	ChatPharoLogger logFrontend: 'UI removed all chat tabs'
            details: (Dictionary new
                    at: 'tabsRemoved' put: removed;
                    yourself)
]

{ #category : 'initialization' }
ChatPharoPresenter >> deleteChat: aPageTitle [

	| pageToDelete pageIndex |
	pageToDelete := notebook pages detect: [ :page | page title = aPageTitle ] ifNone: [ ^ self ].

	(self confirm: 'Are you sure you want to delete this chat?') ifFalse: [ ^ self ].
	pageIndex := notebook pages indexOf: pageToDelete ifAbsent: [ ^ self ].
	notebook removePage: pageToDelete.
	model removeChatAt: pageIndex.
	ChatPharoLogger logFrontend: 'UI removed chat tab'
                details: (Dictionary new
                        at: 'title' put: aPageTitle;
                        at: 'index' put: pageIndex;
                        at: 'remainingTabs' put: notebook pages size;
                        yourself)
]

{ #category : 'initialization' }
ChatPharoPresenter >> deleteSelectedChat [

	notebook selectedPage ifNil: [ 
		
		
		ChatPharoLogger logFrontend: 'Delete chat requested without selection'
                    details: (Dictionary new
                            at: 'totalTabs' put: notebook pages size;
                            yourself).
^ self inform: 'No chat selected.' ].

	self deleteChat: notebook selectedPage title
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
			 action: [ self deleteSelectedChat ];
			 yourself).
	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Delete All';
			 icon: (self iconNamed: #delete);
			 help: 'Delete all chats';
			 action: [ self deleteAllChats ];
			 yourself).


	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Save Chat';
			 icon: (self iconNamed: #smallSave);
			 help: 'Save current chat';
			 action: [ self saveCurrentChat ];
			 yourself). "toolbar add: (SpToolbarButtonPresenter new
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
			 yourself).

	connectionStatusLabel := SpToolbarButtonPresenter new
		                         label: 'Checking connection...';
		                         enabled: false;
		                         action: [ ];
		                         yourself.

	toolbar add: connectionStatusLabel.

	toolbar add: (SpToolbarButtonPresenter new
			 label: 'Refresh Connection';
			 icon: (self iconNamed: #refresh);
			 help: 'Manually check LLM connection status';
			 action: [ self updateConnectionStatusOnce ];
			 yourself).

	self updateConnectionStatus.
        ChatPharoLogger logFrontend: 'Main presenter initialized'
                details: (Dictionary new
                        at: 'initialTabs' put: notebook pages size;
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
	settingsWindow chatPharo: model.
	settingsWindow open.
	        ChatPharoLogger logFrontend: 'Settings dialog opened'
                details: (Dictionary new
                        at: 'activeAgent' put: (ChatPharoLogger agentNameFor: model settings agent);
                        yourself)
]

{ #category : 'initialization' }
ChatPharoPresenter >> saveCurrentChat [

	| fileReference jsonData currentChat |
	currentChat := notebook selectedPage presenterProvider value.
	jsonData := currentChat exportAsJson.

	fileReference := UIManager default chooseForSaveFileReference: 'Save chat' extensions: #( 'json' ) path: FileLocator home.

	fileReference ifNotNil: [
			fileReference writeStream
				nextPutAll: jsonData;
				close. 
				ChatPharoLogger logFrontend: 'Chat exported to file'
                                details: (Dictionary new
                                        at: 'path' put: fileReference fullName;
                                        at: 'chatTitle' put: notebook selectedPage title;
                                        yourself) ]
]

{ #category : 'initialization' }
ChatPharoPresenter >> sendMessage [

        ChatPharoLogger logFrontend: 'Send triggered from main presenter'
                details: (Dictionary new
                        at: 'text' put: messageTextField text;
                        at: 'selectedTab' put: (notebook selectedPage ifNotNil: [ :page | page title ] ifNil: [ 'None' ]);
                        yourself).
	model sendMessage: messageTextField text
]

{ #category : 'accessing - model' }
ChatPharoPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'status' }
ChatPharoPresenter >> updateConnectionStatus [

	[
	ChatPharoLogger logFrontend: 'Started connection status monitor'
                details: (Dictionary new
                        at: 'intervalSeconds' put: 10;
                        yourself).
		[
			self updateConnectionStatusOnce.
			(Delay forSeconds: 10) wait ] repeat ] forkAt: Processor userBackgroundPriority
]

{ #category : 'status' }
ChatPharoPresenter >> updateConnectionStatusOnce [

	| agent statusText |
	agent := model activeAgent ifNil: [ model settings agent ].

	statusText := (agent notNil and: [ agent class isReachable ])
		              ifTrue: [ 'Connected' ]
		              ifFalse: [ 'Disconnected' ].

	connectionStatusLabel
		label: statusText;
		help: (statusText = 'Connected'
				 ifTrue: [ 'Connected to backend (e.g., Ollama)' ]
				 ifFalse: [ 'No connection to backend' ]);
		enabled: false.
	ChatPharoLogger logFrontend: 'Connection status updated'
                details: (Dictionary new
                        at: 'status' put: statusText;
                        at: 'agent' put: (ChatPharoLogger agentNameFor: agent);
                        yourself)
]
