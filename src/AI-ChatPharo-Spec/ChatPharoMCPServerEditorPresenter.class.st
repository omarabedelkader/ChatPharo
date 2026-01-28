"
Dialog for adding or editing an MCP server configuration.
Allows users to configure:
- Server name
- Command to execute
- Command arguments
- Environment variables
- Enabled state
This presenter is typically opened as a modal dialog from ChatPharoMCPSettingsPresenter.
"
Class {
	#name : 'ChatPharoMCPServerEditorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'server',
		'nameInput',
		'commandInput',
		'argumentsInput',
		'environmentText',
		'enabledCheckBox',
		'okButton',
		'cancelButton',
		'isOk'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'as yet unclassified' }
ChatPharoMCPServerEditorPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  borderWidth: 15;
		  add: 'MCP Server Configuration' expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Name:' width: 80;
				   add: #nameInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Command:' width: 80;
				   add: #commandInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Arguments:' width: 80;
				   add: #argumentsInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newTopToBottom
				   add: 'Environment Variables (KEY=VALUE, one per line):' expand: false;
				   add: #environmentText;
				   yourself);
		  add: #enabledCheckBox expand: false;
		  add: (SpBoxLayout newLeftToRight
				   addLast: #cancelButton;
				   addLast: #okButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> cancel [
	"Cancel the dialog"

	isOk := false.
	self delete
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> connectPresenters [

	okButton action: [ self saveAndClose ].
	cancelButton action: [ self cancel ]
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  borderWidth: 15;
		  add: 'MCP Server Configuration' expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Name:' width: 80;
				   add: nameInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Command:' width: 80;
				   add: commandInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Arguments:' width: 80;
				   add: argumentsInput;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newTopToBottom
				   add: 'Environment Variables (KEY=VALUE, one per line):' expand: false;
				   add: environmentText;
				   yourself);
		  add: enabledCheckBox expand: false;
		  add: (SpBoxLayout newLeftToRight
				   addLast: cancelButton;
				   addLast: okButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> environmentAsText [
	"Convert the environment dictionary to text"

	^ String streamContents: [ :stream |
		  server environment keysAndValuesDo: [ :key :value |
			  stream
				  nextPutAll: key asString;
				  nextPut: $=;
				  nextPutAll: value asString;
				  cr ] ]
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> initialize [

	super initialize.
	isOk := false
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> initializePresenters [

	super initializePresenters.

	nameInput := self newTextInput
		             placeholder: 'Server Name';
		             text: server name;
		             yourself.

	commandInput := self newTextInput
		                placeholder: 'Command (e.g., npx, node, python)';
		                text: server command;
		                yourself.

	argumentsInput := self newTextInput
		                  placeholder: 'Arguments separated by spaces';
		                  text: (' ' join: server arguments);
		                  yourself.

	environmentText := self newText
		                   placeholder:
			                   'KEY1=value1' , String lf , 'KEY2=value2';
		                   text: self environmentAsText;
		                   yourself.

	enabledCheckBox := self newCheckBox
		                   label: 'Enable this server';
		                   state: server enabled;
		                   yourself.

	okButton := self newButton
		            label: 'OK';
		            icon: (self iconNamed: #smallOk);
		            yourself.

	cancelButton := self newButton
		                label: 'Cancel';
		                icon: (self iconNamed: #smallCancel);
		                yourself
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'MCP Server Configuration';
		initialExtent: 600 @ 500;
		centered
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> isOk [
	"Return true if the user clicked OK"

	^ isOk
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> openModal [
	"Open this presenter as a modal dialog"

	^ self openDialog
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> parseEnvironment [
	"Parse the environment text into a dictionary"

	| dict lines |
	dict := Dictionary new.
	lines := environmentText text lines.

	lines do: [ :line |
		| trimmed parts |
		trimmed := line trimBoth.
		trimmed ifNotEmpty: [
			parts := trimmed substrings: '='.
			parts size >= 2 ifTrue: [
				dict at: parts first trimBoth put: (parts allButFirst joinUsing: '=') trimBoth ] ] ].

	^ dict
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> saveAndClose [
	"Save the server configuration and close the dialog"

	| name command args |
	name := nameInput text trimBoth.
	command := commandInput text trimBoth.
	args := argumentsInput text trimBoth substrings: ' '.

	name isEmpty ifTrue: [
		self inform: 'Please enter a server name.'.
		^ self ].

	command isEmpty ifTrue: [
		self inform: 'Please enter a command.'.
		^ self ].

	server
		name: name;
		command: command;
		arguments: args;
		environment: self parseEnvironment;
		enabled: enabledCheckBox state.

	isOk := true.
	self delete
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> server [

	^ server
]

{ #category : 'actions' }
ChatPharoMCPServerEditorPresenter >> setModelBeforeInitialization: aMCPServer [

	server := aMCPServer
]
