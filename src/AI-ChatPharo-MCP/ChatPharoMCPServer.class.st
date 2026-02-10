"
Represents an MCP (Model Context Protocol) server configuration.
An MCP server provides tools, resources, and prompts that can be used by LLMs.
This class manages the configuration and connection to an MCP server.
Example:
```smalltalk
server := ChatPharoMCPServer new
    name: 'File System';
    command: 'npx';
    arguments: #('-y' '@modelcontextprotocol/server-filesystem' '/path/to/directory');
    enabled: true;
    yourself.
"
Class {
	#name : 'ChatPharoMCPServer',
	#superclass : 'Object',
	#instVars : [
		'name',
		'command',
		'arguments',
		'environment',
		'enabled',
		'status',
		'tools',
		'resources',
		'prompts',
		'process',
		'lastError',
		'connectionTime'
	],
	#category : 'AI-ChatPharo-MCP',
	#package : 'AI-ChatPharo-MCP'
}

{ #category : 'accessing' }
ChatPharoMCPServer >> arguments [

	^ arguments ifNil: [ arguments := OrderedCollection new ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> arguments: aCollection [

	arguments := aCollection asOrderedCollection
]

{ #category : 'accessing' }
ChatPharoMCPServer >> command [

	^ command ifNil: [ command := '' ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> command: aString [

	command := aString
]

{ #category : 'accessing' }
ChatPharoMCPServer >> connect [
	"Connect to the MCP server"

	self isConnected ifTrue: [ ^ self ].

	[
		self status: #connecting.
		self startProcess.
		self initializeConnection.
		self fetchCapabilities.
		self status: #connected.
		connectionTime := DateAndTime now.
		ChatPharoLogger logSystem: 'MCP server connected'
			details: (Dictionary new
				at: 'server' put: self name;
				at: 'toolsCount' put: self tools size;
				at: 'resourcesCount' put: self resources size;
				yourself) ]
			on: Error
			do: [ :error |
				self status: #error.
				lastError := error messageText.
				ChatPharoLogger logSystem: 'MCP server connection failed'
					details: (Dictionary new
						at: 'server' put: self name;
						at: 'error' put: error messageText;
						yourself) ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> connectionTime [

	^ connectionTime
]

{ #category : 'accessing' }
ChatPharoMCPServer >> createProcess [
	"Create and return the OS process for this MCP server"

	| fullCommand |
	fullCommand := self command , ' ' , (' ' join: self arguments).

	^ OSSUnixSubprocess new
		command: self command;
		arguments: self arguments;
		addAllEnvVariablesFromParentWithoutOverride;
		yourself
]

{ #category : 'accessing' }
ChatPharoMCPServer >> disconnect [
	"Disconnect from the MCP server"

	self isConnected ifFalse: [ ^ self ].

	[
		process ifNotNil: [
			process isRunning ifTrue: [ process terminate ].
			process := nil ].
		self status: #disconnected.
		ChatPharoLogger logSystem: 'MCP server disconnected'
			details: (Dictionary new
				at: 'server' put: self name;
				yourself) ]
			on: Error
			do: [ :error |
				lastError := error messageText.
				ChatPharoLogger logSystem: 'MCP server disconnect error'
					details: (Dictionary new
						at: 'server' put: self name;
						at: 'error' put: error messageText;
						yourself) ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> enabled [

	^ enabled ifNil: [ enabled := true ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> enabled: aBoolean [

	| wasEnabled |
	wasEnabled := self enabled.
	enabled := aBoolean.

	"Connect or disconnect based on enabled state"
	(wasEnabled not and: [ aBoolean ]) ifTrue: [ self connect ].
	(wasEnabled and: [ aBoolean not ]) ifTrue: [ self disconnect ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> environment [

	^ environment ifNil: [ environment := Dictionary new ]
]

{ #category : 'accessing' }
ChatPharoMCPServer >> environment: aDictionary [

	environment := aDictionary
]

{ #category : 'private' }
ChatPharoMCPServer >> fetchCapabilities [
	"Fetch available tools, resources, and prompts from the server"

	| request response |

	"Initialize request"
	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'tools/list';
		at: 'id' put: 1;
		yourself.

	"Send request and parse response"
	response := self sendRequest: request.

	"Parse tools"
	(response at: 'result' ifAbsent: [ Dictionary new ])
		at: 'tools'
		ifPresent: [ :toolsList |
			tools := toolsList collect: [ :toolData |
				ChatPharoMCPTool new
					name: (toolData at: 'name');
					description: (toolData at: 'description' ifAbsent: [ '' ]);
					inputSchema: (toolData at: 'inputSchema' ifAbsent: [ Dictionary new ]);
					server: self;
					yourself ] ]
		ifAbsent: [ tools := OrderedCollection new ].

	"Fetch resources"
	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'resources/list';
		at: 'id' put: 2;
		yourself.

	response := self sendRequest: request.

	(response at: 'result' ifAbsent: [ Dictionary new ])
		at: 'resources'
		ifPresent: [ :resourcesList |
			resources := resourcesList collect: [ :resourceData |
				ChatPharoMCPResource new
					uri: (resourceData at: 'uri');
					name: (resourceData at: 'name' ifAbsent: [ '' ]);
					description: (resourceData at: 'description' ifAbsent: [ '' ]);
					mimeType: (resourceData at: 'mimeType' ifAbsent: [ 'text/plain' ]);
					server: self;
					yourself ] ]
		ifAbsent: [ resources := OrderedCollection new ].

	"Fetch prompts"
	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'prompts/list';
		at: 'id' put: 3;
		yourself.

	response := self sendRequest: request.

	(response at: 'result' ifAbsent: [ Dictionary new ])
		at: 'prompts'
		ifPresent: [ :promptsList |
			prompts := promptsList collect: [ :promptData |
				Dictionary new
					at: 'name' put: (promptData at: 'name');
					at: 'description' put: (promptData at: 'description' ifAbsent: [ '' ]);
					at: 'arguments' put: (promptData at: 'arguments' ifAbsent: [ #() ]);
					yourself ] ]
		ifAbsent: [ prompts := OrderedCollection new ]
]

{ #category : 'private' }
ChatPharoMCPServer >> initialize [

	super initialize.
	enabled := true.
	status := #disconnected.
	tools := OrderedCollection new.
	resources := OrderedCollection new.
	prompts := OrderedCollection new.
	arguments := OrderedCollection new.
	environment := Dictionary new.
	lastError := ''
]

{ #category : 'private' }
ChatPharoMCPServer >> initializeConnection [
	"Initialize the connection to the MCP server using stdio protocol"

	| request response |

	"Send initialize request"
	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'initialize';
		at: 'params' put: (Dictionary new
			at: 'protocolVersion' put: '2024-11-05';
			at: 'capabilities' put: Dictionary new;
			at: 'clientInfo' put: (Dictionary new
				at: 'name' put: 'ChatPharo';
				at: 'version' put: '1.0.0';
				yourself);
			yourself);
		at: 'id' put: 0;
		yourself.

	"Send request and verify response"
	response := self sendRequest: request.

	(response at: 'error' ifAbsent: [ nil ]) ifNotNil: [ :error |
		Error signal: 'Failed to initialize MCP server: ' , (error at: 'message') ].

	"Send initialized notification"
	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'notifications/initialized';
		yourself.

	self sendNotification: request
]

{ #category : 'private' }
ChatPharoMCPServer >> isConnected [

	^ status = #connected
]

{ #category : 'private' }
ChatPharoMCPServer >> isConnecting [

	^ status = #connecting
]

{ #category : 'private' }
ChatPharoMCPServer >> isDisconnected [

	^ status = #disconnected
]

{ #category : 'private' }
ChatPharoMCPServer >> isError [

	^ status = #error
]

{ #category : 'private' }
ChatPharoMCPServer >> lastError [

	^ lastError ifNil: [ lastError := '' ]
]

{ #category : 'private' }
ChatPharoMCPServer >> name [

	^ name ifNil: [ name := 'Unnamed Server' ]
]

{ #category : 'private' }
ChatPharoMCPServer >> name: aString [

	name := aString
]

{ #category : 'private' }
ChatPharoMCPServer >> prompts [

	^ prompts ifNil: [ prompts := OrderedCollection new ]
]

{ #category : 'private' }
ChatPharoMCPServer >> resources [

	^ resources ifNil: [ resources := OrderedCollection new ]
]

{ #category : 'private' }
ChatPharoMCPServer >> sendNotification: aDictionary [
	"Send a JSON-RPC notification to the MCP server (no response expected)"

	| jsonString |
	jsonString := STONJSON toString: aDictionary.

	process ifNotNil: [
		process stdinStream
			nextPutAll: jsonString;
			nextPutAll: String lf;
			flush ]
]

{ #category : 'private' }
ChatPharoMCPServer >> sendRequest: aDictionary [
	"Send a JSON-RPC request to the MCP server and return the response"

	| jsonString response |
	jsonString := STONJSON toString: aDictionary.

	process ifNil: [ Error signal: 'MCP server process not started' ].

	"Write request to stdin"
	process stdinStream
		nextPutAll: jsonString;
		nextPutAll: String lf;
		flush.

	"Read response from stdout"
	response := process stdoutStream nextLine.

	^ STONJSON fromString: response
]

{ #category : 'private' }
ChatPharoMCPServer >> startProcess [
	"Start the MCP server process"

	process := self createProcess.
	process
		redirectStdout;
		redirectStdin;
		redirectStderr.

	self environment keysAndValuesDo: [ :key :value |
		process environmentAt: key put: value ].

	process run.

	"Wait a moment for the process to start"
	(Delay forMilliseconds: 500) wait
]

{ #category : 'private' }
ChatPharoMCPServer >> status [

	^ status ifNil: [ status := #disconnected ]
]

{ #category : 'private' }
ChatPharoMCPServer >> status: aSymbol [

	status := aSymbol
]

{ #category : 'private' }
ChatPharoMCPServer >> statusText [
	"Return a human-readable status text"

	self isConnected ifTrue: [ ^ 'Connected' ].
	self isConnecting ifTrue: [ ^ 'Connecting...' ].
	self isDisconnected ifTrue: [ ^ 'Disconnected' ].
	self isError ifTrue: [ ^ 'Error: ' , self lastError ].
	^ 'Unknown'
]

{ #category : 'private' }
ChatPharoMCPServer >> tools [

	^ tools ifNil: [ tools := OrderedCollection new ]
]

{ #category : 'tool execution' }
ChatPharoMCPServer >> toolsAsChatPharoClients [
	"Convert MCP tools to ChatPharoClient instances for use with agents"

	^ self tools collect: [ :tool | tool asChatPharoClient ]
]
