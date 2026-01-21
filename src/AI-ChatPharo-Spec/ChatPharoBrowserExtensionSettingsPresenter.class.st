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
		'isUpdatingCheckboxes'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> defaultLayout [ 

    ^ SpBoxLayout newTopToBottom
        add: (SpBoxLayout newHorizontal
                 add: 'Browser Prompt:' expand: false;
                 add: promptInput;
                 yourself)
        expand: false;
        add: toolsLayout;
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

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> initializePresenters [

	| tools |
	promptInput := ChatPharoBrowserSystemPromptInputPresenter on: model.
 toolsLayout := SpBoxLayout newTopToBottom.
	toolCheckboxes := OrderedCollection new.
	isUpdatingCheckboxes := false.
	tools := ChatPharoBrowserEnvironment new tools.

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

	toolsLayout add: selectAllCheckbox expand: false.
	toolsLayout add: (SpBoxLayout newTopToBottom) expand: false. "Spacer"

	"Create individual tool checkboxes"
	tools do: [ :tool |
		| cb |
		cb := self newCheckBox
			label: tool name;
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
		toolsLayout add: cb expand: false ]
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
