"
Multi-tab dialog (Chat, History, API, Configuration). Hosts per-agent sub-presenters (see below) and general actions such as “Delete all chats”.
"
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
		'applicationE',
		'systemPromptInput',
		'browserSystemPromptInput',
		'browserExtensionCheckBox',
		'browserExtensionPage',
		'environmentDropList'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> connectPresenters [
	"Refresh models on button action"

	modelsRefreshButton action: [
			ollamaModelDropList items: model models.
			ollamaModelDropList items ifNotEmpty: [
				ollamaModelDropList selectFirst ] ].

	"Handle API dropdown selection"
	apiDropList whenSelectedItemChangedDo: [ :assoc |
			| apiClass newPresenter |
			apiClass := assoc value.
			model useApi: apiClass.

			"Clear old settings and install new presenter"
			apiSettingsContainer removeAll.
			newPresenter := apiClass settingsPresenterFor: model agent.
			newPresenter ifNotNil: [ apiSettingsContainer add: newPresenter ].

			"Update system prompt inputs"
			systemPromptInput text: model agent systemPrompt. ].

	"Bind text inputs to model"
        systemPromptInput whenTextChangedDo: [ :text |
                model agent systemPrompt: text ].

	"Bind checkbox state to model"
	browserExtensionCheckBox whenChangedDo: [ :presenter |
			model browserExtensionEnabled: presenter.
			self updateBrowserExtensionTab ]
]

{ #category : 'layout' }
ChatPharoSettingsPresenter >> defaultLayout [

    ^ SpBoxLayout newTopToBottom
        add: notebook;
        yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> ensureBrowserExtensionTab [

	browserExtensionPage ifNil: [
			browserExtensionPage := SpNotebookPage
				                        title: 'System Browser'
				                        icon: (self iconNamed: #nautilus)
				                        provider: [
				                       ChatPharoBrowserExtensionSettingsPresenter on: model  ].
			notebook addPage: browserExtensionPage ]
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
			 title: 'Configuration'
			 icon: (self iconNamed: #smallConfiguration)
			 provider: [ self newConfigurationTab ]).

	notebook addPage: (SpNotebookPage
			 title: 'Extensions'
			 icon: (self iconNamed: #smallCogInitialState)
			 provider: [ self newExtensionsTab ]).

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
		                       yourself.
	systemPromptInput := self newTextInput
		                     placeholder: 'System prompt...';
		                     text: model agent systemPrompt;
		                     yourself.

	environmentDropList := SpDropListPresenter new
		help: 'Select environment';
		items: #( 'development' 'testing' 'production' );
		display: [ :each | each capitalized ];
		selectedItem: ChatPharoState currentEnvironment;
		whenSelectedItemChangedDo: [ :env |
			ChatPharoState setEnvironment: env.
			model agent systemPrompt: (ChatPharoState systemPromptFor: model agent class agentSymbol).
			systemPromptInput text: model agent systemPrompt.
		];
		yourself.
		
	browserExtensionCheckBox := self newCheckBox
		                            label: 'Enable browser tab';
		                            state: model browserExtensionEnabled;
		                            yourself.

	apiDropList selectItem: (model availableApiChoices
			 detect: [ :assoc | assoc value = model agent class ]
			 ifNone: [ model availableApiChoices first ]).

	self refreshApiSettings.
	self updateBrowserExtensionTab
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'ChatPharo settings';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newChatTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newHorizontal
						    spacing: 8;
						    add: 'System:' expand: false;
						    add: systemPromptInput;
						    yourself)
				   expand: false;
				   yourself);
		  yourself;
		  yourself
	"
				   add: (SpButtonPresenter new
						    label: 'Delete All Chats';
						    icon: (self iconNamed: #delete);
						    help: 'Delete all chats';
						    action: [ self deleteAllChats ];
						    yourself)
				   expand: false;"
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newConfigurationTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newHorizontal
							add: 'Environment:' expand: false;
							add: environmentDropList;
							yourself)
				   expand: false;
				   add: (SpBoxLayout newHorizontal
						    add: 'Agent:' expand: false;
						    add: apiDropList;
						    yourself)
				   expand: false;
				   add: apiSettingsContainer;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newExtensionsTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: browserExtensionCheckBox expand: false;
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

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> refreshApiSettings [

	| newPresenter |
	apiSettingsContainer removeAll.
	newPresenter := model agent class settingsPresenterFor: model agent.
	newPresenter ifNotNil: [ apiSettingsContainer add: newPresenter ].
	apiSettingsContainer changed 
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> removeBrowserExtensionTab [ 
    browserExtensionPage ifNotNil: [
        notebook removePage: browserExtensionPage.
        browserExtensionPage := nil ]
]

{ #category : 'accessing - model' }
ChatPharoSettingsPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> updateBrowserExtensionTab [ 
    browserExtensionCheckBox state
        ifTrue: [ self ensureBrowserExtensionTab ]
        ifFalse: [ self removeBrowserExtensionTab ]
]
