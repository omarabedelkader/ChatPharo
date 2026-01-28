"
Settings presenter for managing MCP (Model Context Protocol) servers.
Allows users to:
- Enable/disable MCP support
- View all configured MCP servers
- Add new MCP servers
- Edit server configurations
- View server status and available tools
- Connect/disconnect from servers
- Delete servers
MCP servers provide tools, resources, and prompts that can be used by LLMs.
"
Class {
	#name : 'ChatPharoMCPSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'mcpEnabledCheckBox',
		'serversList',
		'serverDetailText',
		'addServerButton',
		'editServerButton',
		'deleteServerButton',
		'connectButton',
		'disconnectButton',
		'refreshButton',
		'connectAllButton',
		'disconnectAllButton'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> addNewServer [
	"Open a dialog to add a new MCP server"

	| dialog |
	dialog := ChatPharoMCPServerEditorPresenter on: ChatPharoMCPServer new.
	dialog openModal.

	dialog isOk ifTrue: [
		[ model mcpRegistry addServer: dialog server.
		  self refreshServersList.
		  self inform: 'MCP server added successfully.' ]
			on: Error
			do: [ :error | self inform: 'Failed to add server: ' , error messageText ] ]
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> allServers [
	"Return all configured MCP servers"

	^ model mcpRegistry servers
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> connectAllServers [
	"Connect to all enabled servers"

	model mcpRegistry connectAll.
	self refreshServersList.
	self inform: 'Connecting to all enabled servers...'
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> connectPresenters [

	mcpEnabledCheckBox whenChangedDo: [ :state |
		model mcpEnabled: state.
		self refreshServersList ].

	serversList whenSelectedItemChangedDo: [ :item |
		item ifNotNil: [ self updateDetailFor: item ] ].

	addServerButton action: [ self addNewServer ].
	editServerButton action: [ self editSelectedServer ].
	deleteServerButton action: [ self deleteSelectedServer ].
	connectButton action: [ self connectSelectedServer ].
	disconnectButton action: [ self disconnectSelectedServer ].
	refreshButton action: [ self refreshServersList ].
	connectAllButton action: [ self connectAllServers ].
	disconnectAllButton action: [ self disconnectAllServers ]
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> connectSelectedServer [
	"Connect to the selected MCP server"

	| selected |
	selected := serversList selectedItem.
	selected ifNil: [
		self inform: 'Please select a server to connect.'.
		^ self ].

	[ selected connect.
	  self refreshServersList.
	  self updateDetailFor: selected.
	  self inform: 'Connected to ' , selected name ]
		on: Error
		do: [ :error |
			self refreshServersList.
			self inform: 'Failed to connect: ' , error messageText ]
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  borderWidth: 8;
		  add: (SpBoxLayout newLeftToRight
				   add: 'MCP (Model Context Protocol)' expand: false;
				   addLast: refreshButton expand: false;
				   yourself)
		  expand: false;
		  add: mcpEnabledCheckBox expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: 'Configured Servers:' expand: false;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 60 percent;
				   add: serversList;
				   add: serverDetailText;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: addServerButton expand: false;
				   add: editServerButton expand: false;
				   add: deleteServerButton expand: false;
				   add: connectButton expand: false;
				   add: disconnectButton expand: false;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: connectAllButton expand: false;
				   add: disconnectAllButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> deleteSelectedServer [
	"Delete the selected MCP server"

	| selected |
	selected := serversList selectedItem.
	selected ifNil: [
		self inform: 'Please select a server to delete.'.
		^ self ].

	(self confirm:
		 'Delete server "' , selected name , '"? This cannot be undone.')
		ifFalse: [ ^ self ].

	model mcpRegistry removeServer: selected.
	self refreshServersList.
	serverDetailText text: 'Server deleted.'
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> disconnectAllServers [
	"Disconnect from all servers"

	model mcpRegistry disconnectAll.
	self refreshServersList.
	self inform: 'Disconnecting from all servers...'
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> disconnectSelectedServer [
	"Disconnect from the selected MCP server"

	| selected |
	selected := serversList selectedItem.
	selected ifNil: [
		self inform: 'Please select a server to disconnect.'.
		^ self ].

	selected disconnect.
	self refreshServersList.
	self updateDetailFor: selected.
	self inform: 'Disconnected from ' , selected name
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> editSelectedServer [
	"Open a dialog to edit the selected MCP server"

	| selected dialog originalName |
	selected := serversList selectedItem.
	selected ifNil: [
		self inform: 'Please select a server to edit.'.
		^ self ].

	originalName := selected name.
	dialog := ChatPharoMCPServerEditorPresenter on: selected copy.
	dialog openModal.

	dialog isOk ifTrue: [
		selected
			name: dialog server name;
			command: dialog server command;
			arguments: dialog server arguments;
			environment: dialog server environment;
			enabled: dialog server enabled.
		ChatPharoSettings saveDefault.
		self refreshServersList.
		self inform: 'Server "' , originalName , '" updated successfully.' ]
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> iconForStatus: statusSymbol [
	"Return an icon for the given server status"

	statusSymbol = #connected ifTrue: [ ^ self iconNamed: #testGreen ].
	statusSymbol = #connecting ifTrue: [ ^ self iconNamed: #testYellow ].
	statusSymbol = #error ifTrue: [ ^ self iconNamed: #testRed ].
	^ self iconNamed: #testGray
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> initializePresenters [

	super initializePresenters.

	mcpEnabledCheckBox := self newCheckBox
		                      label: 'Enable MCP (Model Context Protocol) support';
		                      state: model mcpEnabled;
		                      help:
			                      'MCP allows ChatPharo to connect to external servers that provide tools, resources, and prompts';
		                      yourself.

	serversList := self newTable
		               addColumn: (SpImageTableColumn
				                title: ''
				                evaluated: [ :server |
					                self iconForStatus: server status ]);
		               addColumn: (SpStringTableColumn
				                title: 'Name'
				                evaluated: [ :server | server name ]);
		               addColumn: (SpStringTableColumn
				                title: 'Command'
				                evaluated: [ :server |
					                server command , ' ' , (' ' join: server arguments first: (server arguments size min: 2)) ]);
		               addColumn: (SpStringTableColumn
				                title: 'Status'
				                evaluated: [ :server | server statusText ]);
		               addColumn: (SpStringTableColumn
				                title: 'Tools'
				                evaluated: [ :server |
					                server tools size asString ]);
		               addColumn: (SpStringTableColumn
				                title: 'Resources'
				                evaluated: [ :server |
					                server resources size asString ]);
		               items: self allServers;
		               yourself.

	serverDetailText := self newText
		                    beNotEditable;
		                    text: 'Select a server to see its details.';
		                    yourself.

	addServerButton := self newButton
		                   label: 'Add Server';
		                   icon: (self iconNamed: #add);
		                   help: 'Add a new MCP server';
		                   yourself.

	editServerButton := self newButton
		                    label: 'Edit';
		                    icon: (self iconNamed: #edit);
		                    help: 'Edit the selected server';
		                    yourself.

	deleteServerButton := self newButton
		                      label: 'Delete';
		                      icon: (self iconNamed: #delete);
		                      help: 'Delete the selected server';
		                      yourself.

	connectButton := self newButton
		                 label: 'Connect';
		                 icon: (self iconNamed: #smallDoIt);
		                 help: 'Connect to the selected server';
		                 yourself.

	disconnectButton := self newButton
		                    label: 'Disconnect';
		                    icon: (self iconNamed: #smallCancel);
		                    help: 'Disconnect from the selected server';
		                    yourself.

	refreshButton := self newButton
		                 label: 'Refresh';
		                 icon: (self iconNamed: #refresh);
		                 help: 'Refresh the server list';
		                 yourself.

	connectAllButton := self newButton
		                    label: 'Connect All';
		                    icon: (self iconNamed: #glamorousGo);
		                    help: 'Connect to all enabled servers';
		                    yourself.

	disconnectAllButton := self newButton
		                       label: 'Disconnect All';
		                       icon: (self iconNamed: #glamorousClose);
		                       help: 'Disconnect from all servers';
		                       yourself
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> refreshServersList [
	"Refresh the servers list"

	serversList items: self allServers
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> setModelBeforeInitialization: aSettings [

	model := aSettings
]

{ #category : 'actions' }
ChatPharoMCPSettingsPresenter >> updateDetailFor: aServer [
	"Update the detail text area with server information"

	| text |
	text := String streamContents: [ :stream |
		        stream
			        nextPutAll: '=== MCP Server Details ===';
			        cr;
			        cr;
			        nextPutAll: 'Name: ';
			        nextPutAll: aServer name;
			        cr;
			        nextPutAll: 'Status: ';
			        nextPutAll: aServer statusText;
			        cr;
			        nextPutAll: 'Enabled: ';
			        nextPutAll: aServer enabled asString;
			        cr;
			        cr;
			        nextPutAll: '--- Command ---';
			        cr;
			        nextPutAll: aServer command;
			        cr;
			        nextPutAll: 'Arguments: ';
			        nextPutAll: (', ' join: aServer arguments);
			        cr;
			        cr.

		        aServer environment ifNotEmpty: [
			        stream
				        nextPutAll: '--- Environment Variables ---';
				        cr.
			        aServer environment keysAndValuesDo: [ :key :value |
				        stream
					        nextPutAll: key asString;
					        nextPutAll: '=';
					        nextPutAll: value asString;
					        cr ].
			        stream cr ].

		        stream
			        nextPutAll: '--- Capabilities ---';
			        cr;
			        nextPutAll: 'Tools: ';
			        nextPutAll: aServer tools size asString;
			        cr;
			        nextPutAll: 'Resources: ';
			        nextPutAll: aServer resources size asString;
			        cr;
			        nextPutAll: 'Prompts: ';
			        nextPutAll: aServer prompts size asString;
			        cr;
			        cr.

		        aServer isConnected ifTrue: [
			        stream
				        nextPutAll: '--- Available Tools ---';
				        cr.
			        aServer tools do: [ :tool |
				        stream
					        nextPutAll: '• ';
					        nextPutAll: tool name;
					        nextPutAll: ' - ';
					        nextPutAll: tool description;
					        cr ].
			        stream cr.

			        stream
				        nextPutAll: '--- Available Resources ---';
				        cr.
			        aServer resources do: [ :resource |
				        stream
					        nextPutAll: '• ';
					        nextPutAll: resource name;
					        nextPutAll: ' (';
					        nextPutAll: resource uri;
					        nextPutAll: ')';
					        cr ] ].

		        aServer isError ifTrue: [
			        stream
				        cr;
				        nextPutAll: '--- Error ---';
				        cr;
				        nextPutAll: aServer lastError;
				        cr ].

		        aServer connectionTime ifNotNil: [ :time |
			        stream
				        cr;
				        nextPutAll: 'Connected at: ';
				        nextPutAll: time asString;
				        cr ] ].

	serverDetailText text: text
]
