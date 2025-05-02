Class {
	#name : 'ChatPharoSettingsPresenter2',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'apiKeyInput',
		'hostInput',
		'ollamaModelDropList',
		'model',
		'modelsRefreshButton'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> connectPresenters [

	modelsRefreshButton action: [
		ollamaModelDropList items: model models.
		ollamaModelDropList items ifNotEmpty: [ 
			ollamaModelDropList selectFirst	
		]	
	].
	
	ollamaModelDropList whenSelectedItemChangedDo: [ :modelName |
		model useModel: modelName
	]
]

{ #category : 'layout' }
ChatPharoSettingsPresenter2 >> defaultLayout [

    ^ SpBoxLayout newTopToBottom
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> initializePresenters [

	super initializePresenters.

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
			 provider: [ self newConfigurationTab ]).

	modelsRefreshButton := self newButton
		                       label: 'Refresh';
		                       icon: (self iconNamed: #refresh);
		                       help: 'Refresh models';
		                       yourself.

	ollamaModelDropList := SpDropListPresenter new
		                       help: 'Select ollama model';
		                       items: model models;
		                       display: [ :e | e ];
		                       yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'ChatPharo settings';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> newAPITab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: 'API Key:' expand: false;
				   add: (apiKeyInput := self newTextInput
						                   placeholder: 'My key';
						                   yourself)
				   expand: false;
				   add: 'LLM Host:' expand: false;
				   add: (hostInput := self newTextInput
						                 placeholder: 'api.mistral.ai';
						                 yourself)
				   expand: false;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> newChatTab [

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

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> newConfigurationTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: 'Configuration Settings' expand: false;
				   add: (SpBoxLayout newHorizontal
						    add: modelsRefreshButton;
						    add: ollamaModelDropList;
						    yourself)
				   expand: false;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> notebook [

	^ notebook
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter2 >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing - model' }
ChatPharoSettingsPresenter2 >> setModelBeforeInitialization: anObject [

	model := anObject
]
