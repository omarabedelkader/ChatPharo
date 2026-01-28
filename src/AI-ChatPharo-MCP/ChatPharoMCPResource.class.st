"
Represents an MCP resource that can be accessed by an LLM.
MCP resources are data sources exposed by MCP servers (files, documents, etc.)
that the LLM can read during conversations. This class wraps an MCP resource
definition and handles fetching through the parent server.
Example:
```smalltalk
resource := ChatPharoMCPResource new
    uri: 'file:///path/to/file.txt';
    name: 'Configuration File';
    description: 'Application configuration';
    mimeType: 'text/plain';
    server: myMCPServer;
    yourself.
"
Class {
	#name : 'ChatPharoMCPResource',
	#superclass : 'Object',
	#instVars : [
		'uri',
		'name',
		'description',
		'mimeType',
		'server'
	],
	#category : 'AI-ChatPharo-MCP',
	#package : 'AI-ChatPharo-MCP'
}

{ #category : 'accessing' }
ChatPharoMCPResource >> description [

	^ description ifNil: [ description := '' ]
]

{ #category : 'accessing' }
ChatPharoMCPResource >> description: aString [

	description := aString
]

{ #category : 'fetching' }
ChatPharoMCPResource >> fetch [
	"Fetch the contents of this resource from the MCP server"

	| request response |

	self server isConnected ifFalse: [
		Error signal: 'MCP server is not connected: ' , self server name ].

	request := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'resources/read';
		at: 'params' put: (Dictionary new
			at: 'uri' put: self uri;
			yourself);
		at: 'id' put: DateAndTime now asUnixTime;
		yourself.

	response := self server sendRequest: request.

	(response at: 'error' ifAbsent: [ nil ]) ifNotNil: [ :error |
		Error signal: 'MCP resource fetch failed: ' , (error at: 'message') ].

	^ (response at: 'result' ifAbsent: [ Dictionary new ])
		at: 'contents'
		ifPresent: [ :contents |
			"Extract text from contents array"
			(contents collect: [ :item |
				item at: 'text' ifAbsent: [ '' ] ]) joinUsing: String lf ]
		ifAbsent: [ '' ]
]

{ #category : 'accessing' }
ChatPharoMCPResource >> mimeType [

	^ mimeType ifNil: [ mimeType := 'text/plain' ]
]

{ #category : 'accessing' }
ChatPharoMCPResource >> mimeType: aString [

	mimeType := aString
]

{ #category : 'accessing' }
ChatPharoMCPResource >> name [

	^ name ifNil: [ name := '' ]
]

{ #category : 'accessing' }
ChatPharoMCPResource >> name: aString [

	name := aString
]

{ #category : 'accessing' }
ChatPharoMCPResource >> server [

	^ server
]

{ #category : 'accessing' }
ChatPharoMCPResource >> server: aMCPServer [

	server := aMCPServer
]

{ #category : 'accessing' }
ChatPharoMCPResource >> uri [

	^ uri ifNil: [ uri := '' ]
]

{ #category : 'accessing' }
ChatPharoMCPResource >> uri: aString [

	uri := aString
]
