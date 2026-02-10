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
ChatPharoMCPTest >> testMCPRegistryAllPromptsEmpty [

	self assert: registry allPrompts isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryAllResourcesEmpty [

	self assert: registry allResources isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryAllToolsAsClientsEmpty [

	self assert: registry allToolsAsClients isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryAllToolsEmpty [

	self assert: registry allTools isEmpty
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPRegistryConnectedServersEmpty [

	| s1 |
	s1 := ChatPharoMCPServer new name: 'Server1'; enabled: false; yourself.
	registry addServer: s1.

	self assert: registry connectedServers isEmpty
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
ChatPharoMCPTest >> testMCPRegistryEnabledServers [

	| s1 s2 |
	s1 := ChatPharoMCPServer new name: 'Server1'; enabled: false; yourself.
	s2 := ChatPharoMCPServer new name: 'Server2'; enabled: false; yourself.

	registry addServer: s1.
	registry addServer: s2.

	"Both are disabled (enabled: false was set before adding)"
	self assert: registry enabledServers isEmpty
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
ChatPharoMCPTest >> testMCPRegistryServersSette [

	| servers |
	servers := OrderedCollection
		with: (ChatPharoMCPServer new name: 'S1'; enabled: false; yourself).
	registry servers: servers.

	self assert: registry servers size equals: 1
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
ChatPharoMCPTest >> testMCPResourceDefaults [

	| resource |
	resource := ChatPharoMCPResource new.
	self assert: resource uri equals: ''.
	self assert: resource name equals: ''.
	self assert: resource description equals: ''.
	self assert: resource mimeType equals: 'text/plain'.
	self assert: resource server isNil
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPResourceFetchWithDisconnectedServerRaisesError [

	| resource |
	resource := ChatPharoMCPResource new
		uri: 'file:///test.txt';
		server: server;
		yourself.

	self should: [ resource fetch ] raise: Error
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerCommandDefaults [

	self assert: server command equals: ''.
	self assert: server arguments isEmpty
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
ChatPharoMCPTest >> testMCPServerConnectWhenAlreadyConnected [

	"Simulate already connected state to test guard clause"
	server status: #connected.
	server connect.
	"Should return immediately without error"
	self assert: server isConnected
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerConnectionTimeNilByDefault [

	self assert: server connectionTime isNil
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
ChatPharoMCPTest >> testMCPServerDisconnectWhenNotConnected [

	"Should not fail when disconnecting a non-connected server"
	server disconnect
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
ChatPharoMCPTest >> testMCPServerLastError [

	self assert: server lastError equals: ''
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerStatus [

	self assert: server isDisconnected.
	self deny: server isConnected.
	self deny: server isConnecting.
	self deny: server isError
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPServerStatusText [

	self assert: server statusText equals: 'Disconnected'.

	server status: #connecting.
	self assert: server statusText equals: 'Connecting...'.

	server status: #connected.
	self assert: server statusText equals: 'Connected'.

	server status: #error.
	self assert: (server statusText includesSubstring: 'Error')
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

{ #category : 'running' }
ChatPharoMCPTest >> testMCPToolDefaults [

	| tool |
	tool := ChatPharoMCPTool new.
	self assert: tool name equals: ''.
	self assert: tool description equals: ''.
	self assert: tool inputSchema isDictionary.
	self assert: tool server isNil
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPToolExecuteWithDisconnectedServerRaisesError [

	| tool |
	tool := ChatPharoMCPTool new
		name: 'test_tool';
		server: server;
		yourself.

	self should: [ tool executeWithArguments: Dictionary new ] raise: Error
]

{ #category : 'running' }
ChatPharoMCPTest >> testMCPToolServerAssignment [

	| tool |
	tool := ChatPharoMCPTool new.
	tool server: server.
	self assert: tool server equals: server
]
