"
Settings presenter for managing custom tools.
Displays all user-defined custom tools in a table with:
- Enable/disable checkbox
- Tool name
- Description
- Parameter count
Provides buttons to:
- Add new tools
- Edit existing tools
- Delete tools
- Duplicate tools
"
Class {
	#name : 'ChatPharoCustomToolsSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'toolsTable',
		'addButton',
		'editButton',
		'deleteButton',
		'duplicateButton',
		'toolDescriptionText',
		'toolCodePreview'
	],
	#category : 'AI-ChatPharo-Spec-Tools',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Tools'
}

{ #category : 'adding' }
ChatPharoCustomToolsSettingsPresenter >> addTool [
	"Open the tool creation dialog"

	| creator |
	creator := ChatPharoToolCreationPresenter new.
	creator onSave: [ :newTool |
		model addCustomTool: newTool.
		self refreshTable.
		ChatPharoLogger logFrontend: 'Custom tool created'
			details: (Dictionary new at: 'tool' put: newTool name; yourself) ].
	creator open
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> clearPreview [

	toolDescriptionText text: 'Select a tool to see its description.'.
	toolCodePreview text: '| result |
result := ''Select a tool to preview its code.''.
result'
]

{ #category : 'adding' }
ChatPharoCustomToolsSettingsPresenter >> connectPresenters [

	addButton action: [ self addTool ].
	editButton action: [ self editSelectedTool ].
	deleteButton action: [ self deleteSelectedTool ].
	duplicateButton action: [ self duplicateSelectedTool ].

	toolsTable whenSelectedItemChangedDo: [ :item |
		| hasSelection |
		hasSelection := item notNil.
		editButton enabled: hasSelection.
		deleteButton enabled: hasSelection.
		duplicateButton enabled: hasSelection.
		item ifNotNil: [ self updatePreviewFor: item ] ifNil: [ self clearPreview ] ]
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 10;
		add: (SpBoxLayout newLeftToRight
			add: (self newLabel label: 'Custom Tools:') expand: false;
			addLast: duplicateButton expand: false;
			addLast: deleteButton expand: false;
			addLast: editButton expand: false;
			addLast: addButton expand: false;
			yourself) expand: false;
		add: (SpPanedLayout newTopToBottom
			positionOfSlider: 50 percent;
			add: toolsTable;
			add: (SpBoxLayout newTopToBottom
				add: (self newLabel label: 'Description:') expand: false;
				add: toolDescriptionText height: 50;
				add: (self newLabel label: 'Code Preview:') expand: false;
				add: toolCodePreview;
				yourself);
			yourself);
		yourself
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> deleteSelectedTool [

	| selected |
	selected := toolsTable selectedItem.
	selected ifNil: [ ^ self ].

	(self confirm: 'Delete tool "' , selected name , '"?') ifFalse: [ ^ self ].
	model removeCustomTool: selected.
	self refreshTable.
	self clearPreview.
	ChatPharoLogger logFrontend: 'Custom tool deleted' details: (Dictionary new
			 at: 'tool' put: selected name;
			 yourself)
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> duplicateSelectedTool [
	"Create a copy of the selected tool"

	| selected newTool |
	selected := toolsTable selectedItem.
	selected ifNil: [ ^ self ].

	newTool := ChatPharoCustomTool new
		name: selected name, '_copy';
		description: selected description;
		codeString: selected codeString;
		parameterDefinitions: selected parameterDefinitions deepCopy;
		yourself.

	model addCustomTool: newTool.
	self refreshTable.
	toolsTable selectItem: newTool.
	ChatPharoLogger logFrontend: 'Custom tool duplicated'
		details: (Dictionary new at: 'original' put: selected name; at: 'copy' put: newTool name; yourself)
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> editSelectedTool [
	"Open the tool creation dialog for editing"

	| selected editor |
	selected := toolsTable selectedItem.
	selected ifNil: [ ^ self ].

	editor := ChatPharoToolCreationPresenter newForEditing: selected.
	editor onSave: [ :updatedTool |
		"Remove old and add updated"
		model removeCustomTool: selected.
		model addCustomTool: updatedTool.
		self refreshTable.
		toolsTable selectItem: updatedTool.
		ChatPharoLogger logFrontend: 'Custom tool updated'
			details: (Dictionary new at: 'tool' put: updatedTool name; yourself) ].
	editor open
]

{ #category : 'initialization' }
ChatPharoCustomToolsSettingsPresenter >> initializePresenters [

	super initializePresenters.

	toolsTable := self newTable
		addColumn: (SpCheckBoxTableColumn new
			title: 'Enabled';
			width: 60;
			evaluated: [ :tool | tool enabled ];
			onActivation: [ :tool |
				tool enabled: true.
				ChatPharoSettings saveDefault ];
			onDeactivation: [ :tool |
				tool enabled: false.
				ChatPharoSettings saveDefault ];
			yourself);
		addColumn: (SpStringTableColumn
			title: 'Name'
			evaluated: [ :tool | tool name ]);
		addColumn: (SpStringTableColumn
			title: 'Parameters'
			evaluated: [ :tool | tool parameterDefinitions size asString ]);
		addColumn: (SpStringTableColumn
			title: 'Description'
			evaluated: [ :tool | (tool description first: (50 min: tool description size)) , (tool description size > 50 ifTrue: [ '...' ] ifFalse: [ '' ]) ]);
		items: model customTools;
		yourself.

	addButton := self newButton
		label: 'Add Tool';
		icon: (self iconNamed: #smallAdd);
		help: 'Create a new custom tool';
		yourself.

	editButton := self newButton
		label: 'Edit';
		icon: (self iconNamed: #smallConfiguration);
		help: 'Edit selected tool';
		enabled: false;
		yourself.

	deleteButton := self newButton
		label: 'Delete';
		icon: (self iconNamed: #smallDelete);
		help: 'Delete selected tool';
		enabled: false;
		yourself.

	duplicateButton := self newButton
		label: 'Duplicate';
		icon: (self iconNamed: #smallCopy);
		help: 'Create a copy of selected tool';
		enabled: false;
		yourself.

	toolDescriptionText := self newText
		beNotEditable;
		text: 'Select a tool to see its description.';
		yourself.

	toolCodePreview := self newCode
		beNotEditable;
		beForScripting;
		text: '| result |
result := ''Select a tool to preview its code.''.
result';
		yourself
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> refreshTable [

	toolsTable items: model customTools
]

{ #category : 'accessing - model' }
ChatPharoCustomToolsSettingsPresenter >> setModelBeforeInitialization: aSettings [

	model := aSettings
]

{ #category : 'layout' }
ChatPharoCustomToolsSettingsPresenter >> updatePreviewFor: aTool [
	"Update the preview panels with tool info"

	| descText |
	descText := String streamContents: [ :stream |
		stream nextPutAll: aTool description.
		aTool parameterDefinitions ifNotEmpty: [ :params |
			stream cr; cr; nextPutAll: 'Parameters:'.
			params do: [ :p |
				stream cr; nextPutAll: '  - ';
					nextPutAll: (p at: 'name');
					nextPutAll: ' (';
					nextPutAll: (p at: 'type');
					nextPutAll: ')';
					nextPutAll: ((p at: 'required') ifTrue: [ ' [required]' ] ifFalse: [ '' ]);
					nextPutAll: ': ';
					nextPutAll: (p at: 'description') ] ] ].

	toolDescriptionText text: descText.
	toolCodePreview text: aTool codeString
]
