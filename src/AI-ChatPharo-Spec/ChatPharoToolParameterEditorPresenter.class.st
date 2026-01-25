"
A dialog for adding or editing a tool parameter.
Allows the user to specify:
- Parameter name
- Parameter type (string, number, boolean, array, object)
- Description
- Whether the parameter is required
"
Class {
	#name : 'ChatPharoToolParameterEditorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nameInput',
		'typeDropList',
		'descriptionInput',
		'requiredCheckBox',
		'saveButton',
		'cancelButton',
		'parameterDefinition',
		'onSaveBlock'
	],
	#category : 'AI-ChatPharo-Spec-Tools',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Tools'
}

{ #category : 'instance creation' }
ChatPharoToolParameterEditorPresenter class >> newForEditing: aParameterDefinition [
	"Create a presenter for editing an existing parameter"

	^ self new
		parameterDefinition: aParameterDefinition;
		yourself
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> cancel [

	self window close
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> connectPresenters [

	saveButton action: [ self save ].
	cancelButton action: [ self cancel ]
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  borderWidth: 10;
		  add: (SpGridLayout new
				   beColumnNotHomogeneous;
				   column: 2 expand: true;
				   add: (self newLabel label: 'Name:') atPoint: 1 @ 1;
				   add: nameInput atPoint: 2 @ 1;
				   add: (self newLabel label: 'Type:') at: 1 @ 2;
				   add: typeDropList at: 2 @ 2;
				   add: (self newLabel label: 'Description:') at: 1 @ 3;
				   add: descriptionInput at: 2 @ 3;
				   yourself);
		  add: requiredCheckBox expand: false;
		  add: (SpBoxLayout newLeftToRight
				   addLast: cancelButton expand: false;
				   addLast: saveButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> initializePresenters [

	nameInput := self newTextInput
		placeholder: 'parameter_name';
		yourself.

	typeDropList := self newDropList
		items: #('string' 'number' 'integer' 'boolean' 'array' 'object');
		selectItem: 'string';
		yourself.

	descriptionInput := self newTextInput
		placeholder: 'Description of what this parameter is for...';
		yourself.

	requiredCheckBox := self newCheckBox
		label: 'Required parameter';
		state: true;
		yourself.

	saveButton := self newButton
		label: 'Save';
		icon: (self iconNamed: #smallOk);
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		icon: (self iconNamed: #smallCancel);
		yourself.

	"If editing existing parameter, populate fields"
	parameterDefinition ifNotNil: [ self populateFromDefinition ]
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: (parameterDefinition ifNil: [ 'Add Parameter' ] ifNotNil: [ 'Edit Parameter' ]);
		initialExtent: 450@250
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> onSave: aBlock [
	"Set the block to execute when saving (receives the parameter definition dictionary)"

	onSaveBlock := aBlock
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> parameterDefinition [

	^ parameterDefinition
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> parameterDefinition: aDictionary [

	parameterDefinition := aDictionary
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> populateFromDefinition [
	"Populate fields from existing parameter definition"

	nameInput text: (parameterDefinition at: 'name' ifAbsent: [ '' ]).
	typeDropList selectItem: (parameterDefinition at: 'type' ifAbsent: [ 'string' ]).
	descriptionInput text: (parameterDefinition at: 'description' ifAbsent: [ '' ]).
	requiredCheckBox state: (parameterDefinition at: 'required' ifAbsent: [ true ])
]

{ #category : 'actions' }
ChatPharoToolParameterEditorPresenter >> save [
	"Validate and save the parameter"

	| name |
	name := nameInput text trimBoth.

	name isEmpty ifTrue: [
		self inform: 'Parameter name is required'.
		^ self ].

	(name allSatisfy: [ :c | c isAlphaNumeric or: [ c = $_ ] ]) ifFalse: [
		self inform: 'Parameter name must contain only letters, numbers, and underscores'.
		^ self ].

	parameterDefinition := Dictionary new
		at: 'name' put: name;
		at: 'type' put: typeDropList selectedItem;
		at: 'description' put: descriptionInput text trimBoth;
		at: 'required' put: requiredCheckBox state;
		yourself.

	onSaveBlock ifNotNil: [ onSaveBlock value: parameterDefinition ].
	self window close
]
