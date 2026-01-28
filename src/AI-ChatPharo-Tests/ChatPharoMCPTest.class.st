Class {
	#name : 'ChatPharoMCPTest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'registry',
		'settings'
	],
	#category : 'AI-ChatPharo-Tests-MCP',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'MCP'
}

{ #category : 'running' }
ChatPharoMCPTest >> setUp [

	super setUp.
	server := ChatPharoMCPServer new.
	registry := ChatPharoMCPRegistry new.
	settings := ChatPharoSettings new
]

{ #category : 'running' }
ChatPharoMCPTest >> tearDown [

	registry ifNotNil: [ registry disconnectAll ].
	super tearDown
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPIntegrationWithSettings [

	| testServer |
	testServer := ChatPharoMCPServer new
		              name: 'Integration Test Server';
		              enabled: false;
		              yourself.

	settings mcpRegistry addServer: testServer.

	self assert: settings mcpRegistry servers size equals: 1.
	self
		assert: (settings mcpRegistry findServerNamed: 'Integration Test Server')
		equals: testServer
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryAddServer [

	| testServer |
	testServer := ChatPharoMCPServer new
		              name: 'Test Server';
		              enabled: false;
		              yourself.

	registry addServer: testServer.

	self assert: registry servers size equals: 1.
	self assert: (registry findServerNamed: 'Test Server') equals: testServer
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryCreation [

	self assert: registry servers isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryDuplicateServerNames [

	| server1 server2 |
	server1 := ChatPharoMCPServer new
		           name: 'Same Name';
		           enabled: false;
		           yourself.
	server2 := ChatPharoMCPServer new
		           name: 'Same Name';
		           enabled: false;
		           yourself.

	registry addServer: server1.

	self
		should: [ registry addServer: server2 ]
		raise: Error
		description: 'Should raise error for duplicate server names'
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryFindServer [

	| testServer |
	testServer := ChatPharoMCPServer new
		              name: 'Findable Server';
		              enabled: false;
		              yourself.

	registry addServer: testServer.

	self
		assert: (registry findServerNamed: 'Findable Server')
		equals: testServer.
	self assert: (registry findServerNamed: 'Nonexistent') isNil
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryRemoveServer [

	| testServer |
	testServer := ChatPharoMCPServer new
		              name: 'Test Server';
		              enabled: false;
		              yourself.

	registry addServer: testServer.
	self assert: registry servers size equals: 1.

	registry removeServer: testServer.
	self assert: registry servers isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPResourceCreation [

	| resource |
	resource := ChatPharoMCPResource new
		            uri: 'file:///test.txt';
		            name: 'Test File';
		            description: 'A test file';
		            mimeType: 'text/plain';
		            yourself.

	self assert: resource uri equals: 'file:///test.txt'.
	self assert: resource name equals: 'Test File'.
	self assert: resource description equals: 'A test file'.
	self assert: resource mimeType equals: 'text/plain'
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerConfiguration [

	server
		name: 'Test Server';
		command: 'node';
		arguments: #( 'server.js' );
		enabled: true.

	self assert: server name equals: 'Test Server'.
	self assert: server command equals: 'node'.
	self assert: server arguments equals: #( 'server.js' ) asOrderedCollection.
	self assert: server enabled
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerCreation [

	self assert: server name equals: 'Unnamed Server'.
	self assert: server enabled.
	self assert: server status equals: #disconnected.
	self assert: server tools isEmpty.
	self assert: server resources isEmpty.
	self assert: server prompts isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerEnvironmentVariables [

	server environment
		at: 'API_KEY' put: 'test-key';
		at: 'PORT' put: '3000'.

	self assert: (server environment at: 'API_KEY') equals: 'test-key'.
	self assert: (server environment at: 'PORT') equals: '3000'
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerStatus [

	self assert: server isDisconnected.
	self deny: server isConnected.
	self deny: server isConnecting.
	self deny: server isError
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPSettingsEnabled [

	self deny: settings mcpEnabled.

	settings mcpEnabled: true.
	self assert: settings mcpEnabled
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPSettingsRegistry [

	self assert: settings mcpRegistry notNil.
	self assert: settings mcpRegistry class equals: ChatPharoMCPRegistry
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPSettingsToolsAsClients [

	| clients |
	settings mcpEnabled: false.
	clients := settings mcpToolsAsClients.
	self assert: clients isEmpty.

	settings mcpEnabled: true.
	clients := settings mcpToolsAsClients.
	self assert: clients isEmpty "Empty because no servers are configured"
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPToolAsClient [

	| tool client |
	tool := ChatPharoMCPTool new
		        name: 'test_tool';
		        description: 'A test tool';
		        server: server;
		        yourself.

	client := tool asChatPharoClient.

	self assert: client name equals: 'test_tool'.
	self assert: client description equals: 'A test tool'
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPToolCreation [

	| tool |
	tool := ChatPharoMCPTool new
		        name: 'test_tool';
		        description: 'A test tool';
		        inputSchema: (Dictionary new
				         at: 'type' put: 'object';
				         yourself);
		        yourself.

	self assert: tool name equals: 'test_tool'.
	self assert: tool description equals: 'A test tool'.
	self assert: (tool inputSchema at: 'type') equals: 'object'
]
