"
I'm a class that activates when the user wants chatpharo to be implemented inside the System Browser
"
Class {
	#name : 'ChatPharoBrowserExtensionSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'promptInput',
		'toolsLayout',
		'selectAllCheckbox',
		'toolCheckboxes',
		'isUpdatingCheckboxes',
		'scrollableToolsPane'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'private' }
ChatPharoBrowserExtensionSettingsPresenter >> categoryForToolName: toolName [
	"Return the category for a given tool name."

	| packageTools classTools searchTools refactoringTools executionTools |
	packageTools := #( 'get_packages' 'get_classes_in_packages' 'describe_package' ).
	classTools := #( 'get_class_definitions' 'get_class_comments' 'get_class_methods' 'get_class_subclasses' ).
	searchTools := #( 'find_methods_with_substring' ).
	refactoringTools := #( 'rename_class' 'rename_classes_in_package' 'check_syntax' ).
	executionTools := #( 'open_playground' 'get_sandbox_status' 'sandbox_evaluate' ).

	(packageTools includes: toolName) ifTrue: [ ^ #packageBrowsing ].
	(classTools includes: toolName) ifTrue: [ ^ #classIntrospection ].
	(searchTools includes: toolName) ifTrue: [ ^ #codeSearch ].
	(refactoringTools includes: toolName) ifTrue: [ ^ #refactoring ].
	(executionTools includes: toolName) ifTrue: [ ^ #codeExecution ].
	^ #other
]

{ #category : 'private' }
ChatPharoBrowserExtensionSettingsPresenter >> categoryLabel: categorySymbol [
	"Return a human-readable label for a category."

	categorySymbol = #packageBrowsing ifTrue: [ ^ 'Package Browsing' ].
	categorySymbol = #classIntrospection ifTrue: [ ^ 'Class Introspection' ].
	categorySymbol = #codeSearch ifTrue: [ ^ 'Code Search' ].
	categorySymbol = #refactoring ifTrue: [ ^ 'Refactoring' ].
	categorySymbol = #codeExecution ifTrue: [ ^ 'Code Execution' ].
	^ 'Other Tools'
]

{ #category : 'private' }
ChatPharoBrowserExtensionSettingsPresenter >> categoryOrder [
	"Return the order in which categories should be displayed."

	^ #( #packageBrowsing #classIntrospection #codeSearch #refactoring #codeExecution #other )
]

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 10;
		borderWidth: 8;
		add: (SpBoxLayout newHorizontal
			spacing: 8;
			add: (self newLabel label: 'Browser Prompt:') expand: false;
			add: promptInput expand: true;
			yourself) expand: false;
		add: (SpBoxLayout newTopToBottom
			spacing: 8;
			add: (self newLabel label: '— Available Tools —') expand: false;
			add: selectAllCheckbox expand: false;
			yourself) expand: false;
		add: scrollableToolsPane;
		yourself
]

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> deselectAllTools [
	"Disable all tools after confirmation and update all checkboxes."

	(ChatPharoSafetyAdvisor confirmToolDisableOn: self)
		ifTrue: [
				model disableAllBrowserTools.
				isUpdatingCheckboxes := true.
				toolCheckboxes do: [ :cb | cb state ifTrue: [ cb state: false ] ] ]
		ifFalse: [
				isUpdatingCheckboxes := true.
				selectAllCheckbox state: true ].
	isUpdatingCheckboxes := false
]

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> friendlyToolName: toolName [
	"Convert tool_name to a more friendly display name."

	| words |
	words := toolName substrings: '_'.
	words := words collect: [ :word | word capitalized ].
	^ String streamContents: [ :stream |
		words
			do: [ :word | stream nextPutAll: word ]
			separatedBy: [ stream nextPut: Character space ] ]
]

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> initializePresenters [

	| tools seenToolNames toolsByCategory |
	promptInput := ChatPharoBrowserSystemPromptInputPresenter on: model.
 toolsLayout := SpBoxLayout newTopToBottom.
	toolCheckboxes := OrderedCollection new.
	isUpdatingCheckboxes := false.
	tools := ChatPharoBrowserEnvironment new tools.
	seenToolNames := Set new.

	"Create the 'Select All' checkbox"
	selectAllCheckbox := self newCheckBox
		label: 'Select All Tools';
		state: model allBrowserToolsEnabled;
		yourself.

	selectAllCheckbox whenChangedDo: [ :isChecked |
		isUpdatingCheckboxes ifFalse: [
			isChecked
				ifTrue: [ self selectAllTools ]
				ifFalse: [ self deselectAllTools ] ] ].

	"Group tools by category"
	toolsByCategory := Dictionary new.
	tools do: [ :tool |
		| category |
		"Skip duplicate tools"
		(seenToolNames includes: tool name) ifFalse: [
			seenToolNames add: tool name.
			category := self categoryForToolName: tool name.
			(toolsByCategory at: category ifAbsentPut: [ OrderedCollection new ])
				add: tool ] ].

	"Create tool checkboxes organized by category"
	self categoryOrder do: [ :category |
		(toolsByCategory at: category ifAbsent: [ #() ]) ifNotEmpty: [ :categoryTools |
			"Add category header"
			toolsLayout add: (SpBoxLayout newTopToBottom
				add: (self newLabel label: ('  ', (self categoryLabel: category))) expand: false;
				yourself) expand: false.
				
					"Add tools in this category"
			categoryTools do: [ :tool |
				| cb toolRow |
				cb := self newCheckBox
					label: (self friendlyToolName: tool name);
					state: (model browserToolsEnabled includes: tool name);
					yourself.

				cb whenChangedDo: [ :isChecked |
					isUpdatingCheckboxes ifFalse: [
						isChecked
							ifTrue: [
								model enableBrowserTool: tool name.
								self updateSelectAllCheckboxState ]
							ifFalse: [
								(ChatPharoSafetyAdvisor confirmToolDisableOn: self)
									ifTrue: [
										model disableBrowserTool: tool name.
										self updateSelectAllCheckboxState ]
									ifFalse: [
										isUpdatingCheckboxes := true.
										cb state: true.
										isUpdatingCheckboxes := false ] ] ] ].

				toolCheckboxes add: cb.
				toolRow := SpBoxLayout newHorizontal
					add: '      ' expand: false;
					add: cb expand: false;
					yourself.
				toolsLayout add: toolRow expand: false ] ] ].

	"Wrap tools in a scrollable pane"
	scrollableToolsPane := self newPresenter.
	scrollableToolsPane layout: toolsLayout
]

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> selectAllTools [
	"Enable all tools and update all checkboxes."

	model enableAllBrowserTools.
	isUpdatingCheckboxes := true.
	toolCheckboxes do: [ :cb |
		cb state ifFalse: [ cb state: true ] ].
	isUpdatingCheckboxes := false
]

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> setModelBeforeInitialization: anObject [ 

    model := anObject
]

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> updateSelectAllCheckboxState [

	| allSelected |
	allSelected := toolCheckboxes allSatisfy: [ :cb | cb state ].
	selectAllCheckbox state = allSelected ifTrue: [ ^ self ].
	isUpdatingCheckboxes := true.
	selectAllCheckbox state: allSelected.
	isUpdatingCheckboxes := false
]
