"
Multi-tab dialog (Chat, History, API, Configuration). Hosts per-agent sub-presenters (see below) and general actions such as “Delete all chats”.
"
Class {
	#name : 'ChatPharoSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'ollamaModelDropList',
		'model',
		'modelsRefreshButton',
		'apiDropList',
		'apiSettingsContainer',
		'systemPromptInput',
		'browserExtensionCheckBox',
		'browserExtensionPage',
		'maxIterationsInput',
		'playgroundToolCheckBox',
		'browserAutoTabCheckBox'
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
					| selected |
					selected := ollamaModelDropList items
						            detect: [ :each | each = model agent model ]
						            ifNone: [ nil ].
					selected
						ifNotNil: [ ollamaModelDropList selectItem: selected ]
						ifNil: [ ollamaModelDropList selectFirst ] ] ].

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
			systemPromptInput text: model agent systemPrompt ].

	"Bind text inputs to model"
	systemPromptInput whenTextChangedDo: [ :text |
			(ChatPharoSafetyAdvisor confirmPromptModificationOn: self)
				ifTrue: [
						model agent systemPrompt: text.
						ChatPharoSettings setDefault: model.
						ChatPharoSettings saveDefault ]
				ifFalse: [ systemPromptInput text: model agent systemPrompt ] ].

	maxIterationsInput whenTextChangedDo: [ :t |
			t ifNotEmpty: [
					| num |
					num := t asNumber.
					num < 1
						ifTrue: [
								(ChatPharoSafetyAdvisor confirmMaxIterationsOn: self)
									ifTrue: [
											model maximumIterations: 1.
											maxIterationsInput text: '1' ]
									ifFalse: [
									maxIterationsInput text: model maximumIterations asString ] ]
						ifFalse: [ model maximumIterations: num ] ] ].

	"Bind checkbox state to model"
	browserExtensionCheckBox whenChangedDo: [ :presenter |
			model browserExtensionEnabled: presenter.
			self updateBrowserExtensionTab ].
		
        browserAutoTabCheckBox whenChangedDo: [ :presenter |
                        model browserAutoTabEnabled: presenter ].

	playgroundToolCheckBox whenChangedDo: [ :checked |
			checked
				ifTrue: [ model enableBrowserTool: 'open_playground' ]
				ifFalse: [
						(ChatPharoSafetyAdvisor confirmToolDisableOn: self)
							ifTrue: [ model disableBrowserTool: 'open_playground' ]
							ifFalse: [ playgroundToolCheckBox state: true ] ] ]
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


	maxIterationsInput := self newNumberInput
		                      placeholder: 'e.g. 5';
		                      text: model maximumIterations asString;
		                      yourself.

	browserExtensionCheckBox := self newCheckBox
		                            label: 'Enable browser tab';
		                            state: model browserExtensionEnabled;
		                            yourself.
		
	browserAutoTabCheckBox := self newCheckBox
		                          label: 'Open tab on selection';
		                          state: model browserAutoTabEnabled;
		                          yourself.
		
	playgroundToolCheckBox := self newCheckBox
		                          label: 'Enable open playground tool';
		                          state:
			                          (model browserToolsEnabled includes:
					                           'open_playground');
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
				   add: (SpBoxLayout newHorizontal
						    spacing: 8;
						    add: 'Max iterations:' expand: false;
						    add: maxIterationsInput;
						    yourself)
				   expand: false;
								add: playgroundToolCheckBox expand: false;
				   yourself);
		  yourself;
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newConfigurationTab [

	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
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
				add: browserAutoTabCheckBox expand: false;
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
