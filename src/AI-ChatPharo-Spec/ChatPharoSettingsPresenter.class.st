Class {
	#name : 'ChatPharoSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'apiKeyInput',
		'hostInput',
		'ollamaModelDropList',
		'model',
		'modelsRefreshButton',
		'apiDropList',
		'apiSettingsContainer',
		'applicationE'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> connectPresenters [

	modelsRefreshButton action: [
			ollamaModelDropList items: model models.
			ollamaModelDropList items ifNotEmpty: [
				ollamaModelDropList selectFirst ] ].

apiDropList whenSelectedItemChangedDo: [:assoc |
    | apiClass newPresenter |
    apiClass := assoc value.
    model useApi: apiClass.

    apiSettingsContainer removeAll.

    newPresenter := apiClass settingsPresenterFor: model agent.
    newPresenter ifNotNil: [ apiSettingsContainer add: newPresenter ].

    "uncomment the next line only if the UI fails to refresh automatically"
    "apiSettingsContainer changedWorld"
].
]

{ #category : 'layout' }
ChatPharoSettingsPresenter >> defaultLayout [

    ^ SpBoxLayout newTopToBottom
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> initializePresenters [

	super initializePresenters.

	notebook := self newNotebook.
	apiSettingsContainer := SpBoxLayout newTopToBottom.

	notebook addPage: (SpNotebookPage
			 title: 'Chat'
			 icon: (self iconNamed: #announcement)
			 provider: [ self newChatTab ]).
			
	notebook addPage: (SpNotebookPage
			 title: 'History'
			 icon: (self iconNamed: #history)
			 provider: [ self newHistoryTab ]).

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

	apiDropList := SpDropListPresenter new
		               help: 'Select backend API';
		               items: model availableApiChoices;
		               display: [ :assoc | assoc key ];
		               yourself.

	ollamaModelDropList := SpDropListPresenter new
		                       help: 'Select ollama model';
		                       items: model models;
		                       display: [ :e | e ];
		                       yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'ChatPharo settings';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newAPITab [

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
ChatPharoSettingsPresenter >> newChatTab [

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
ChatPharoSettingsPresenter >> newConfigurationTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newHorizontal
						    add: 'API:' expand: false;
						    add: apiDropList;
						    yourself)
				   expand: false;
				   add: apiSettingsContainer;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newHistoryTab [

	| historyText historyView |
	historyText := model agent
		               ifNotNil: [
				               model agent history
					               ifNotNil: [ model agent history asPromptPrefix ]
					               ifNil: [ 'No history available.' ] ]
		               ifNil: [ 'No agent configured.' ].

	historyView := self newText.
	historyView text: historyText asText.

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: historyView;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> notebook [

	^ notebook
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> notebook: anObject [

	notebook := anObject
]

{ #category : 'accessing - model' }
ChatPharoSettingsPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
