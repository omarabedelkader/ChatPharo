"
Represents an MCP tool that can be called by an LLM.
MCP tools are functions exposed by MCP servers that can be invoked
by the LLM during conversations. This class wraps an MCP tool definition
and handles execution through the parent server.
Example:
```smalltalk
tool := ChatPharoMCPTool new
    name: 'read_file';
    description: 'Read contents of a file';
    inputSchema: (Dictionary new
        at: 'type' put: 'object';
        at: 'properties' put: (Dictionary new
            at: 'path' put: (Dictionary new
                at: 'type' put: 'string';
                at: 'description' put: 'File path to read';
                yourself);
            yourself);
        yourself);
    server: myMCPServer;
    yourself.
```
"
Class {
	#name : 'ChatPharoMCPTool',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'inputSchema',
		'server'
	],
	#category : 'AI-ChatPharo-MCP',
	#package : 'AI-ChatPharo-MCP'
}

{ #category : 'converting' }
ChatPharoMCPTool >> asChatPharoClient [
	"Convert this MCP tool to a ChatPharoClient for use with agents"

	^ ChatPharoClient new
		name: self name;
		description: self description;
		inputSchema: self inputSchema;
		block: [ :args | self executeWithArguments: args ];
		yourself
]

{ #category : 'converting' }
ChatPharoMCPTool >> description [

	^ description ifNil: [ description := '' ]
]

{ #category : 'converting' }
ChatPharoMCPTool >> description: aString [

	description := aString
]

{ #category : 'converting' }
ChatPharoMCPTool >> executeWithArguments: argumentsDictionary [
	"Execute this tool with the given arguments via the MCP server"

	| request response |

	self server isConnected ifFalse: [
		Error signal: 'MCP server is not connected: ' , self server name ].

	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'tools/call';
		at: 'params' put: (Dictionary new
			at: 'name' put: self name;
			at: 'arguments' put: argumentsDictionary;
			yourself);
		at: 'id' put: DateAndTime now asUnixTime;
		yourself.

	response := self server sendRequest: request.

	(response at: 'error' ifAbsent: [ nil ]) ifNotNil: [ :error |
		Error signal: 'MCP tool execution failed: ' , (error at: 'message') ].

	^ (response at: 'result' ifAbsent: [ Dictionary new ])
		at: 'content'
		ifPresent: [ :content |
			"Extract text from content array"
			(content collect: [ :item |
				item at: 'text' ifAbsent: [ '' ] ]) joinUsing: String lf ]
		ifAbsent: [ '' ]
]

{ #category : 'converting' }
ChatPharoMCPTool >> inputSchema [

	^ inputSchema ifNil: [ inputSchema := Dictionary new ]
]

{ #category : 'converting' }
ChatPharoMCPTool >> inputSchema: aDictionary [

	inputSchema := aDictionary
]

{ #category : 'converting' }
ChatPharoMCPTool >> name [

	^ name ifNil: [ name := '' ]
]

{ #category : 'converting' }
ChatPharoMCPTool >> name: aString [ 

	name := aString
]

{ #category : 'converting' }
ChatPharoMCPTool >> server [

	^ server
]

{ #category : 'converting' }
ChatPharoMCPTool >> server: aMCPServer [

	server := aMCPServer
]
