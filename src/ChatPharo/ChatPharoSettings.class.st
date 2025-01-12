Class {
	#name : 'ChatPharoSettings',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'chatSettings'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'accessing' }
ChatPharoSettings >> chatSettings [

	^ chatSettings
]

{ #category : 'accessing' }
ChatPharoSettings >> chatSettings: anObject [

	chatSettings := anObject
]

{ #category : 'layout' }
ChatPharoSettings >> defaultLayout [

    ^ SpBoxLayout newTopToBottom
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharoSettings >> deleteAllChats [

    (self confirm: 'Are you sure you want to delete all chats?')
        ifFalse: [ ^ self ].

    self chatSettings notebook removeAll.
    self chatSettings notebook addPage: (SpNotebookPage
        title: 'Chat'
        icon: (self iconNamed: #announcement)
        provider: [ ChatPharoSpecChat new ]).
    self chatSettings notebook selectPageIndex: 1.
]

{ #category : 'layout' }
ChatPharoSettings >> initializePresenters [

    notebook := self newNotebook.

    notebook addPage: (SpNotebookPage
        title: 'Chat'
        icon: (self iconNamed: #announcement)
        provider: [ self newChatTab ]).

    notebook addPage: (SpNotebookPage
        title: 'API'
        icon: (self iconNamed: #announcement)
        provider: [ self newAPITab ]).

    notebook addPage: (SpNotebookPage
        title: 'Configuration'
        icon: (self iconNamed: #announcement)
        provider: [ self newConfigurationTab ])
]

{ #category : 'layout' }
ChatPharoSettings >> newAPITab [

    ^ SpPresenter new
        layout: (SpBoxLayout newTopToBottom
            add: 'API Settings' expand: false;
            yourself);
        yourself
]

{ #category : 'layout' }
ChatPharoSettings >> newChatTab [

    ^ SpPresenter new
        layout: (SpBoxLayout newTopToBottom
            add: (SpButtonPresenter new
                label: 'Delete All Chats';
                icon: (self iconNamed: #delete);
                help: 'Delete all chats';
                action: [ self deleteAllChats ];
                yourself) expand: false;
            yourself);
        yourself
]

{ #category : 'layout' }
ChatPharoSettings >> newConfigurationTab [ 

    ^ SpPresenter new
        layout: (SpBoxLayout newTopToBottom
            add: 'Configuration Settings' expand: false;
            yourself);
        yourself
]

{ #category : 'accessing' }
ChatPharoSettings >> notebook [

	^ notebook
]

{ #category : 'accessing' }
ChatPharoSettings >> notebook: anObject [

	notebook := anObject
]

{ #category : 'layout' }
ChatPharoSettings >> title [ 

    ^ 'ChatPharo Settings'

]
