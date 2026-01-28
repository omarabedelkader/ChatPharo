"
Central registry for managing MCP servers.
The MCP registry maintains the collection of configured MCP servers,
handles connections, and provides access to all available tools and resources.
This is typically accessed through ChatPharoSettings.
Example:
```smalltalk
registry := ChatPharoMCPRegistry new.
registry addServer: (ChatPharoMCPServer new
    name: 'File System';
    command: 'npx';
    arguments: #('-y' '@modelcontextprotocol/server-filesystem' '/tmp');
    enabled: true;
    yourself).
registry connectAll.
tools := registry allTools.
"
Class {
	#name : 'ChatPharoMCPRegistry',
	#superclass : 'Object',
	#instVars : [
		'servers'
	],
	#category : 'AI-ChatPharo-MCP',
	#package : 'AI-ChatPharo-MCP'
}

{ #category : 'adding' }
ChatPharoMCPRegistry >> addServer: aMCPServer [
	"Add an MCP server to the registry"

	(self servers anySatisfy: [ :s | s name = aMCPServer name ]) ifTrue: [
		Error signal: 'An MCP server with this name already exists: ' , aMCPServer name ].

	self servers add: aMCPServer.

	aMCPServer enabled ifTrue: [ aMCPServer connect ].

	ChatPharoLogger logSystem: 'MCP server added'
		details: (Dictionary new
			at: 'server' put: aMCPServer name;
			at: 'enabled' put: aMCPServer enabled;
			yourself)
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> allPrompts [
	"Return all prompts from all connected servers"

	^ self connectedServers flatCollect: [ :server | server prompts ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> allResources [
	"Return all resources from all connected servers"

	^ self connectedServers flatCollect: [ :server | server resources ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> allTools [
	"Return all tools from all connected servers"

	^ self connectedServers flatCollect: [ :server | server tools ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> allToolsAsClients [
	"Return all tools from all connected servers as ChatPharoClient instances"

	^ self connectedServers flatCollect: [ :server | server toolsAsChatPharoClients ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> connectAll [
	"Connect to all enabled servers"

	self enabledServers do: [ :server | server connect ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> connectedServers [
	"Return all connected servers"

	^ self servers select: [ :server | server isConnected ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> disconnectAll [
	"Disconnect from all servers"

	self servers do: [ :server | server disconnect ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> enabledServers [
	"Return all enabled servers"

	^ self servers select: [ :server | server enabled ]
]

{ #category : 'finding' }
ChatPharoMCPRegistry >> findServerNamed: aString [
	"Find and return a server by name"

	^ self servers detect: [ :server | server name = aString ] ifNone: [ nil ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> initialize [

	super initialize.
	servers := OrderedCollection new
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> removeServer: aMCPServer [
	"Remove an MCP server from the registry"

	aMCPServer disconnect.
	self servers remove: aMCPServer ifAbsent: [ ].

	ChatPharoLogger logSystem: 'MCP server removed'
		details: (Dictionary new
			at: 'server' put: aMCPServer name;
			yourself)
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> servers [

	^ servers ifNil: [ servers := OrderedCollection new ]
]

{ #category : 'adding' }
ChatPharoMCPRegistry >> servers: aCollection [

	servers := aCollection asOrderedCollection
]
