"
### `ChatPharoSettings` Class
Manages the settings and layout of the ChatPharo application within the Pharo Smalltalk environment. This class is responsible for configuring and maintaining the chat settings UI elements such as the notebook and various tabs.

- **`chatSettings`**: Accessor for the chat settings object.
- **`chatSettings:`**: Mutator to set the chat settings object.
- **`defaultLayout`**: Establishes the default top-to-bottom layout for the settings, primarily the notebook.
- **`deleteAllChats`**: Provides functionality to delete all chat records with a confirmation dialogue.
- **`initializePresenters`**: Sets up the initial presenters within the notebook, including tabs for Chat, API, and Configuration.
- **`newAPITab`**: Initializes the API tab with its specific settings.
- **`newChatTab`**: Initializes the Chat tab with options like 'Delete All Chats'.
- **`newConfigurationTab`**: Sets up the Configuration tab.
- **`notebook`**: Accessor for the notebook component.
- **`notebook:`**: Mutator to set the notebook component.
- **`title`**: Returns the title of the settings window as 'ChatPharo Settings'.

"
Class {
	#name : 'ChatPharoSettings',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'chatSettings',
		'apiKeyInput',
		'hostInput'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo',
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
			add: 'LLM API Key:' expand: false;
			add: (apiKeyInput := self newTextInput
				placeholder: 'My key';
				yourself) expand: false;
			add: 'LLM Host:' expand: false;
			add: (hostInput := self newTextInput
				placeholder: 'api.mistral.ai';
				yourself) expand: false;
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
