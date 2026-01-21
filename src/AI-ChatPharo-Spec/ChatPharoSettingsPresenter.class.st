"
Multi-tab dialog (Chat, History, API, Configuration, Personal). Hosts per-agent sub-presenters (see below) and general actions such as “Delete all chats”.
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
		'browserAutoTabCheckBox',
		'chatPharo',
		'cacheCheckBox',
		'loggingCheckBox',
		'feedbackCheckBox',
		'askFeatureCheckBox',
		'codeFeatureCheckBox',
		'welcomeMessageCheckBox',
		'userNameInput',
		'userOrganizationInput',
		'developerIdInput',
		'developerStatusLabel',
		'verifyDeveloperButton'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'helpers' }
ChatPharoSettingsPresenter >> addCheckboxLabeled: aLabel value: aValueBlock changeAction: aChangeBlock [
	| checkbox |
	checkbox := self newCheckBox
		label: aLabel;
		state: aValueBlock value;
		yourself.

	checkbox whenChangedDo: aChangeBlock.

	^ checkbox
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> chatPharo [

        ^ chatPharo
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> chatPharo: anObject [

        chatPharo := anObject
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> connectPresenters [
	"Refresh models on button action"

	modelsRefreshButton action: [
			ollamaModelDropList items: model models.
			ollamaModelDropList items ifNotEmpty: [
					| selected |
					selected := ollamaModelDropList items detect: [ :each | each = model agent model ] ifNone: [ nil ].
					selected ifNotNil: [ ollamaModelDropList selectItem: selected ] ifNil: [ ollamaModelDropList selectFirst ] ] ]. "Handle API dropdown selection"
	apiDropList whenSelectedItemChangedDo: [ :assoc |
			| apiClass newPresenter |
			apiClass := assoc value.
			model useApi: apiClass. "Clear old settings and install new presenter"
			apiSettingsContainer removeAll.
			newPresenter := apiClass settingsPresenterFor: model agent.
			newPresenter ifNotNil: [ apiSettingsContainer add: newPresenter ]. "Update system prompt inputs"
			systemPromptInput text: model agent systemPrompt ]. "Bind text inputs to model"
	systemPromptInput whenTextChangedDo: [ :text |
			text ~= ChatPharoAgent defaultSystemPrompt ifTrue: [
					(ChatPharoSafetyAdvisor confirmPromptModificationOn: self)
						ifTrue: [
								model agent systemPrompt: text.
								ChatPharoSettings setDefault: model.
								ChatPharoSettings saveDefault ]
						ifFalse: [ systemPromptInput text: model agent systemPrompt ] ] ].

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
									ifFalse: [ maxIterationsInput text: model maximumIterations asString ] ]
						ifFalse: [ model maximumIterations: num ] ] ]. "Bind checkbox state to model"
	browserExtensionCheckBox whenChangedDo: [ :presenter |
			model browserExtensionEnabled: presenter.
			self updateBrowserExtensionTab ].

	browserAutoTabCheckBox whenChangedDo: [ :presenter | model browserAutoTabEnabled: presenter ].

	cacheCheckBox whenChangedDo: [ :enabled |
			model cacheEnabled: enabled.
			ChatPharoSettings saveDefault ].

	loggingCheckBox whenChangedDo: [ :enabled | model loggingEnabled: enabled ].
	
	
	        askFeatureCheckBox := self
                                    addCheckboxLabeled: 'Enable Ask button in editors'
                                    value: [ model askFeatureEnabled ]
                                    changeAction: [ :val | model askFeatureEnabled: val ].

        codeFeatureCheckBox := self
                                        addCheckboxLabeled: 'Enable Code button in editors'
                                        value: [ model codeFeatureEnabled ]
                                        changeAction: [ :val | model codeFeatureEnabled: val ].

	feedbackCheckBox := self
		                    addCheckboxLabeled: 'Enable Feedback Buttons'
		                    value: [ ChatPharoSettings default feedbackButtonsEnabled ]
		                    changeAction: [ :val | ChatPharoSettings default feedbackButtonsEnabled: val ].

	welcomeMessageCheckBox := self
		                          addCheckboxLabeled: 'Show Welcome Message'
		                          value: [ ChatPharoSettings default welcomeMessageEnabled ]
		                          changeAction: [ :val | ChatPharoSettings default welcomeMessageEnabled: val ].


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
ChatPharoSettingsPresenter >> developerStatusText [
	"Return the developer status text."

	| settings |
	settings := ChatPharoSettings default.
	settings isDeveloper
		ifTrue: [ ^ 'Verified Developer' ]
		ifFalse: [
			settings developerId isEmpty
				ifTrue: [ ^ 'Not a developer' ]
				ifFalse: [ ^ 'Developer ID not verified' ] ]
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

	notebook addPage: (SpNotebookPage title: 'Chat' icon: (self iconNamed: #announcement) provider: [ self newChatTab ]).

	notebook addPage: (SpNotebookPage title: 'History' icon: (self iconNamed: #history) provider: [ self newHistoryTab ]).

	notebook addPage:
		(SpNotebookPage title: 'Configuration' icon: (self iconNamed: #smallConfiguration) provider: [ self newConfigurationTab ]).

	notebook addPage:
		(SpNotebookPage title: 'Extensions' icon: (self iconNamed: #smallCogInitialState) provider: [ self newExtensionsTab ]).

	notebook addPage:
		(SpNotebookPage title: 'Security' icon: (self iconNamed: #lock) provider: [ ChatPharoSecuritySettingsPresenter on: model ]).

	notebook addPage: (SpNotebookPage title: 'Personal' icon: (self iconNamed: #user) provider: [ self newPersonalTab ]).

	notebook addPage: (SpNotebookPage title: 'Skills' icon: (self iconNamed: #smallObjects) provider: [ self newSkillsTab ]).
	
	notebook addPage: (SpNotebookPage title: 'Multivers' icon: (self iconNamed: #branch) provider: [ self newMultiversTab ]).

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
		                          state: (model browserToolsEnabled includes: 'open_playground');
		                          yourself.

	cacheCheckBox := self newCheckBox
		                 label: 'Enable cache';
		                 state: model cacheEnabled;
		                 yourself.

	loggingCheckBox := self newCheckBox
		                   label: 'Enable logging';
		                   state: model loggingEnabled;
		                   yourself.

	apiDropList selectItem:
		(model availableApiChoices detect: [ :assoc | assoc value = model agent class ] ifNone: [ model availableApiChoices first ]).

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
				   spacing: 12;
				   "Add some vertical spacing between rows for better separation"add: (SpBoxLayout newHorizontal
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
				   add: cacheCheckBox expand: false;
				   add: loggingCheckBox expand: false;
				add: askFeatureCheckBox expand: false;
                                   add: codeFeatureCheckBox expand: false;
				   add: feedbackCheckBox expand: false;
				   add: welcomeMessageCheckBox expand: false;
				   yourself);
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
					"add: browserAutoTabCheckBox expand: false;"
				   yourself);
		  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newHistoryTab [

        | history historyText historyView |
        history := chatPharo
                               ifNotNil: [
                                               chatPharo activeAgent
                                                       ifNotNil: [ chatPharo activeAgent history ]
                                                       ifNil: [ nil ] ]
                               ifNil: [ nil ].

history := history ifNil: [ model agent history ].
        historyText := history
                               ifNotNil: [ history asPromptPrefix ]
                               ifNil: [ 'No history available.' ].

        historyView := self newText.
        historyView text: historyText asText.

        ^ SpPresenter new
                  layout: (SpBoxLayout newTopToBottom
                                   add: historyView;
                                   yourself);
                  yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newMultiversTab [
	"Creates the Multivers configuration tab"

	^ ChatPharoMultiversPresenter on: model
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newPersonalTab [
	"Create the personal configuration tab."

	| settings nameRow orgRow devIdRow statusRow buttonRow |
	settings := ChatPharoSettings default.

	userNameInput := self newTextInput
		placeholder: 'Your name...';
		text: settings userName;
		yourself.

	userOrganizationInput := self newTextInput
		placeholder: 'Organization/Company...';
		text: settings userOrganization;
		yourself.

	developerIdInput := self newTextInput
		placeholder: 'Developer ID (optional)...';
		text: settings developerId;
		yourself.

	developerStatusLabel := self newLabel
		label: (self developerStatusText);
		yourself.

	verifyDeveloperButton := self newButton
		label: 'Verify Developer ID';
		icon: (self iconNamed: #glamorousGo);
		action: [ self verifyDeveloperId ];
		yourself.

	userNameInput whenTextChangedDo: [ :text |
		settings userName: text trimBoth ].

	userOrganizationInput whenTextChangedDo: [ :text |
		settings userOrganization: text trimBoth ].

	nameRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Name:') expand: false;
		add: userNameInput expand: true;
		yourself.

	orgRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Organization:') expand: false;
		add: userOrganizationInput expand: true;
		yourself.

	devIdRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Developer ID:') expand: false;
		add: developerIdInput expand: true;
		yourself.

	statusRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Status:') expand: false;
		add: developerStatusLabel expand: true;
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: verifyDeveloperButton expand: false;
		yourself.

	^ SpPresenter new
		layout: (SpBoxLayout newTopToBottom
			spacing: 12;
			borderWidth: 8;
			add: nameRow expand: false;
			add: orgRow expand: false;
			add: devIdRow expand: false;
			add: buttonRow expand: false;
			add: statusRow expand: false;
			yourself);
		yourself
]

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> newSkillsTab [
	"Creates the Skills configuration tab"

	^ ChatPharoSkillsSettingsPresenter on: model
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

{ #category : 'initialization' }
ChatPharoSettingsPresenter >> verifyDeveloperId [
	"Verify the developer ID entered in the personal tab."

	| enteredId settings |
	enteredId := developerIdInput text trimBoth.
	settings := ChatPharoSettings default.

	enteredId isEmpty ifTrue: [
		settings isDeveloper: false.
		settings developerId: ''.
		developerStatusLabel label: 'Not a developer'.
		self inform: 'Developer ID cleared.'.
		^ self ].

	developerStatusLabel label: 'Verifying...'.
	verifyDeveloperButton enabled: false.

	[
		| isValid |
		isValid := ChatPharoDeveloperConfig verifyDeveloperId: enteredId.

		self defer: [
			verifyDeveloperButton enabled: true.
			isValid
				ifTrue: [
					settings developerId: enteredId.
					settings isDeveloper: true.
					developerStatusLabel label: 'Verified Developer'.
					self inform: 'Developer ID verified successfully!' ]
				ifFalse: [
					settings developerId: enteredId.
					settings isDeveloper: false.
					developerStatusLabel label: 'Developer ID not verified'.
					self inform: 'Invalid Developer ID.' ]
		]
	] fork
]
