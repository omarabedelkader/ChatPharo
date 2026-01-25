"
Main dialog for creating or editing a custom tool.
Provides a comprehensive UI for defining tools:
- Basic info (name, description)
- Parameters management (add/edit/remove via table)
- Code editor with syntax highlighting
- Test functionality to verify the tool works
- Save/Cancel actions
Usage:
  ChatPharoToolCreationPresenter new open.
  ChatPharoToolCreationPresenter newForEditing: existingTool.
"
Class {
	#name : 'ChatPharoToolCreationPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nameInput',
		'descriptionInput',
		'parametersTable',
		'addParameterButton',
		'editParameterButton',
		'removeParameterButton',
		'codeEditor',
		'testButton',
		'testResultText',
		'saveButton',
		'cancelButton',
		'customTool',
		'onSaveBlock'
	],
	#category : 'AI-ChatPharo-Spec-Tools',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Tools'
}

{ #category : 'instance creation' }
ChatPharoToolCreationPresenter class >> newForEditing: aCustomTool [
	"Create a presenter for editing an existing tool"

	^ self new
		customTool: aCustomTool copy;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> addParameter [
	"Open dialog to add a new parameter"

	| editor |
	editor := ChatPharoToolParameterEditorPresenter new.
	editor onSave: [ :paramDef |
		customTool addParameterNamed: (paramDef at: 'name')
			type: (paramDef at: 'type')
			description: (paramDef at: 'description')
			required: (paramDef at: 'required').
		self refreshParametersTable ].
	editor open
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> cancel [

	self window close
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> connectPresenters [

	addParameterButton action: [ self addParameter ].
	editParameterButton action: [ self editSelectedParameter ].
	removeParameterButton action: [ self removeSelectedParameter ].
	testButton action: [ self testTool ].
	saveButton action: [ self save ].
	cancelButton action: [ self cancel ].

	nameInput whenTextChangedDo: [ :text | customTool name: text trimBoth ].
	descriptionInput whenTextChangedDo: [ :text | customTool description: text trimBoth ].
	codeEditor whenTextChangedDo: [ :text | customTool codeString: text asString ].

	parametersTable whenSelectedItemChangedDo: [ :item |
		| hasSelection |
		hasSelection := item notNil.
		editParameterButton enabled: hasSelection.
		removeParameterButton enabled: hasSelection ]
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> customTool [

	^ customTool
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> customTool: aCustomTool [

	customTool := aCustomTool
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 8;
		borderWidth: 10;
		add: self newBasicInfoLayout expand: false;
		add: self newParametersLayout;
		add: self newCodeLayout;
		add: self newTestLayout expand: false;
		add: self newButtonsLayout expand: false;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> editSelectedParameter [
	"Open dialog to edit the selected parameter"

	| selectedParam editor |
	selectedParam := parametersTable selectedItem.
	selectedParam ifNil: [ ^ self ].

	editor := ChatPharoToolParameterEditorPresenter newForEditing: selectedParam copy.
	editor onSave: [ :paramDef |
		"Remove old and add updated"
		customTool removeParameterNamed: (selectedParam at: 'name').
		customTool addParameterNamed: (paramDef at: 'name')
			type: (paramDef at: 'type')
			description: (paramDef at: 'description')
			required: (paramDef at: 'required').
		self refreshParametersTable ].
	editor open
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> initializePresenters [

	customTool ifNil: [ customTool := ChatPharoCustomTool new ].

	nameInput := self newTextInput
		placeholder: 'my_custom_tool';
		text: customTool name;
		yourself.

	descriptionInput := self newText
		placeholder: 'Describe what this tool does and when to use it...';
		text: customTool description;
		yourself.

	parametersTable := self newTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :p | p at: 'name' ]);
		addColumn: (SpStringTableColumn title: 'Type' evaluated: [ :p | p at: 'type' ]);
		addColumn: (SpStringTableColumn title: 'Required' evaluated: [ :p | (p at: 'required') ifTrue: [ 'Yes' ] ifFalse: [ 'No' ] ]);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: [ :p | p at: 'description' ]);
		items: customTool parameterDefinitions;
		yourself.

	addParameterButton := self newButton
		label: 'Add';
		icon: (self iconNamed: #smallAdd);
		help: 'Add a new parameter';
		yourself.

	editParameterButton := self newButton
		label: 'Edit';
		icon: (self iconNamed: #smallConfiguration);
		help: 'Edit selected parameter';
		enabled: false;
		yourself.

	removeParameterButton := self newButton
		label: 'Remove';
		icon: (self iconNamed: #smallDelete);
		help: 'Remove selected parameter';
		enabled: false;
		yourself.

	codeEditor := self newCode
		beForScripting;
		text: customTool codeString;
		yourself.

	testButton := self newButton
		label: 'Test Tool';
		icon: (self iconNamed: #smallDoIt);
		help: 'Test the tool with sample arguments';
		yourself.

	testResultText := self newText
		beNotEditable;
		text: 'Click "Test Tool" to verify your tool works correctly.';
		yourself.

	saveButton := self newButton
		label: 'Save Tool';
		icon: (self iconNamed: #smallOk);
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		icon: (self iconNamed: #smallCancel);
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Create Custom Tool';
		initialExtent: 700@650
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> newBasicInfoLayout [
	"Layout for name and description"

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			add: (self newLabel label: 'Tool Name:') expand: false;
			add: nameInput;
			yourself) expand: false;
		add: (self newLabel label: 'Description:') expand: false;
		add: descriptionInput height: 60;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> newButtonsLayout [
	"Layout for save/cancel buttons"

	^ SpBoxLayout newLeftToRight
		addLast: cancelButton expand: false;
		addLast: saveButton expand: false;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> newCodeLayout [
	"Layout for the code editor"

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (self newLabel label: 'Tool Code (Smalltalk - receives ''arguments'' dictionary):') expand: false;
		add: codeEditor;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> newParametersLayout [
	"Layout for parameters table and buttons"

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			add: (self newLabel label: 'Parameters:') expand: false;
			addLast: removeParameterButton expand: false;
			addLast: editParameterButton expand: false;
			addLast: addParameterButton expand: false;
			yourself) expand: false;
		add: parametersTable height: 120;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> newTestLayout [
	"Layout for test button and results"

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			add: testButton expand: false;
			add: (self newLabel label: '  Test Result:') expand: false;
			yourself) expand: false;
		add: testResultText height: 50;
		yourself
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> onSave: aBlock [
	"Set the block to execute when saving (receives the custom tool)"

	onSaveBlock := aBlock
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> refreshParametersTable [

	parametersTable items: customTool parameterDefinitions
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> removeSelectedParameter [
	"Remove the selected parameter"

	| selectedParam |
	selectedParam := parametersTable selectedItem.
	selectedParam ifNil: [ ^ self ].

	(self confirm: 'Remove parameter "', (selectedParam at: 'name'), '"?') ifTrue: [
		customTool removeParameterNamed: (selectedParam at: 'name').
		self refreshParametersTable ]
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> sampleValueForType: aType [
	"Return a sample value for the given parameter type"

	aType = 'string' ifTrue: [ ^ 'sample_text' ].
	aType = 'number' ifTrue: [ ^ 42.0 ].
	aType = 'integer' ifTrue: [ ^ 42 ].
	aType = 'boolean' ifTrue: [ ^ true ].
	aType = 'array' ifTrue: [ ^ #() ].
	aType = 'object' ifTrue: [ ^ Dictionary new ].
	^ nil
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> save [
	"Validate and save the tool"

	| nameError codeError |

	"Update from current inputs"
	customTool name: nameInput text trimBoth.
	customTool description: descriptionInput text asString trimBoth.
	customTool codeString: codeEditor text asString.

	"Validate name"
	nameError := customTool validateName.
	nameError ifNotNil: [
		self inform: nameError.
		^ self ].

	"Validate description"
	customTool description isEmpty ifTrue: [
		self inform: 'Tool description is required'.
		^ self ].

	"Validate code"
	codeError := customTool validateCode.
	codeError ifNotNil: [
		self inform: codeError.
		^ self ].

	"Save"
	onSaveBlock ifNotNil: [ onSaveBlock value: customTool ].
	self window close
]

{ #category : 'adding' }
ChatPharoToolCreationPresenter >> testTool [
	"Test the tool with sample/empty arguments"

	| args result codeError |

	"First validate code"
	customTool codeString: codeEditor text asString.
	codeError := customTool validateCode.
	codeError ifNotNil: [
		testResultText text: ('Syntax Error: ', codeError).
		^ self ].

	"Build sample arguments from parameter definitions"
	args := Dictionary new.
	customTool parameterDefinitions do: [ :paramDef |
		| paramName paramType sampleValue |
		paramName := paramDef at: 'name'.
		paramType := paramDef at: 'type'.
		sampleValue := self sampleValueForType: paramType.
		args at: paramName put: sampleValue ].

	"Execute test"
	testResultText text: 'Testing...'.
	[
		result := customTool testWithArguments: args.
		self defer: [
			testResultText text: ('Result: ', result printString) ]
	] on: Error do: [ :error |
		self defer: [
			testResultText text: ('Error: ', error messageText) ] ]
]
