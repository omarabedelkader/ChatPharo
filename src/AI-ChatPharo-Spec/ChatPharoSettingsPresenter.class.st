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
		'browserExtensionCheckBox'
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
            ollamaModelDropList selectFirst
        ].
    ].

    "Handle API dropdown selection"
    apiDropList whenSelectedItemChangedDo: [ :assoc |
        | apiClass newPresenter |
        apiClass := assoc value.
        model useApi: apiClass.

        "Clear old settings and install new presenter"
        apiSettingsContainer removeAll.
        newPresenter := apiClass settingsPresenterFor: model agent.
        newPresenter ifNotNil: [
            apiSettingsContainer add: newPresenter
        ].

        "Update system prompt inputs"
        systemPromptInput text: model agent systemPrompt.
        browserSystemPromptInput text: model agent browserSystemPrompt.
    ].

    "Bind text inputs to model"
    systemPromptInput whenTextChangedDo: [ :text |
        model agent systemPrompt: text
    ].

    browserSystemPromptInput whenTextChangedDo: [ :text |
        model agent browserSystemPrompt: text
    ].

    "Bind checkbox state to model"
browserExtensionCheckBox whenChangedDo: [ :presenter |
    model browserExtensionEnabled: presenter
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
			 title: 'Configuration'
			 icon: (self iconNamed: #smallConfiguration)
			 provider: [ self newConfigurationTab ]).
			
	notebook addPage: (SpNotebookPage
                         title: 'Extensions'
                         icon: (self iconNamed: #smallBrowser)
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
        browserSystemPromptInput := self newTextInput
                                     placeholder: 'Browser system prompt...';
                                     text: model agent browserSystemPrompt;
                                     yourself.
        browserExtensionCheckBox := self newCheckBox
                                     label: 'Enable browser tab';
                                     state: model browserExtensionEnabled;
                                     yourself.
	apiDropList selectItem: (model availableApiChoices
			 detect: [ :assoc | assoc value = model agent class ]
			 ifNone: [ model availableApiChoices first ]).

	self refreshApiSettings
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
						    add: 'API:' expand: false;
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
                                   add: (SpBoxLayout newHorizontal
                                                    add: 'Browser Prompt:' expand: false;
                                                    add: browserSystemPromptInput;
                                                    yourself)
                                   expand: false;
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

{ #category : 'accessing - model' }
ChatPharoSettingsPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
