Class {
	#name : 'ChatPharoSettings',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook'
	],
	#category : 'ChatPharo-Spec',
	#package : 'ChatPharo',
	#tag : 'Spec'
}

{ #category : 'layout' }
ChatPharoSettings >> defaultLayout [

    ^ SpBoxLayout newTopToBottom
        add: notebook;
        yourself
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
            add: 'Chat Settings' expand: false;
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
