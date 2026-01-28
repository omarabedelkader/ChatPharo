"
Handles the **history** command for conversation management.

Provides export, import, and clear operations for conversation history.

**Subcommands:**
- `export` - Export conversation to JSON file
- `import` - Import conversation from JSON file
- `clear` - Clear conversation history

**Example usage:**
```bash
# Export conversation
pharo ChatPharo.image clap chatpharo history export conversation.json

# Import conversation
pharo ChatPharo.image clap chatpharo history import conversation.json

# Clear history
pharo ChatPharo.image clap chatpharo history clear
```

**JSON Format:**
The exported JSON contains:
- Messages array with user/assistant pairs
- Agent configuration
- Timestamps
- Attachments metadata
"
Class {
	#name : 'ChatPharoCLIHistory',
	#superclass : 'Object',
	#instVars : [
		'operation',
		'path',
		'chat'
	],
	#category : 'AI-ChatPharo-CLI',
	#package : 'AI-ChatPharo-CLI'
}

{ #category : 'accessing' }
ChatPharoCLIHistory >> chat [

	^ chat ifNil: [ chat := self getOrCreateChat ]
]

{ #category : 'execution' }
ChatPharoCLIHistory >> execute [
	"Execute the history command based on operation"

	self operation = #export ifTrue: [ ^ self executeExport ].
	self operation = #import ifTrue: [ ^ self executeImport ].
	self operation = #clear ifTrue: [ ^ self executeClear ].

	self printError: 'Unknown operation: ', self operation asString.
	self exitWithError
]

{ #category : 'execution - clear' }
ChatPharoCLIHistory >> executeClear [
	"Clear conversation history"

	| chat |
	chat := self getOrCreateChat.

	chat messages ifEmpty: [
		Transcript show: '📭 No history to clear'; cr.
		^ self exitSuccess
	].

	chat reset.
	Transcript show: '✅ Conversation history cleared (';
		show: chat messages size asString;
		show: ' messages removed)'; cr.

	self exitSuccess
]

{ #category : 'execution - export' }
ChatPharoCLIHistory >> executeExport [
	"Export conversation to JSON file"

	| chat json fileRef |
	chat := self getOrCreateChat.

	chat messages ifEmpty: [
		self printError: 'No conversation to export. Start a chat first.'.
		^ self exitWithError
	].

	[
		json := chat exportAsJson.
		fileRef := self path asFileReference.

		"Create parent directories if needed"
		fileRef parent ensureCreateDirectory.

		"Write JSON to file"
		fileRef writeStreamDo: [ :stream |
			stream nextPutAll: json
		].

		Transcript show: '✅ Conversation exported to: '; show: self path; cr.
		Transcript show: '   Messages: '; show: chat messages size asString; cr.
		Transcript show: '   Size: '; show: fileRef size asString; show: ' bytes'; cr.

		self exitSuccess
	] on: Error do: [ :ex |
		self printError: 'Export failed: ', ex messageText.
		self exitWithError
	]
]

{ #category : 'execution - import' }
ChatPharoCLIHistory >> executeImport [
	"Import conversation from JSON file"

	| chat json fileRef |
	fileRef := self path asFileReference.

	fileRef exists ifFalse: [
		self printError: 'File not found: ', self path.
		^ self exitWithError
	].

	[
		json := fileRef contents.
		chat := self getOrCreateChat.
		chat importFromJson: json.

		Transcript show: '✅ Conversation imported from: '; show: self path; cr.
		Transcript show: '   Messages: '; show: chat messages size asString; cr.

		self exitSuccess
	] on: Error do: [ :ex |
		self printError: 'Import failed: ', ex messageText.
		self exitWithError
	]
]

{ #category : 'private' }
ChatPharoCLIHistory >> exitSuccess [
	"Exit with success code"

	Smalltalk snapshot: false andQuit: true
]

{ #category : 'private' }
ChatPharoCLIHistory >> exitWithError [
	"Exit with error code"

	Smalltalk snapshot: false andQuit: true exitCode: 1
]

{ #category : 'private' }
ChatPharoCLIHistory >> getOrCreateChat [
	"Get or create a chat instance"

	| settings agent |
	settings := ChatPharoSettings default.
	agent := settings agent ifNil: [ ChatPharoClaudeAgent new ].

	^ ChatPharoChat new agent: agent; yourself
]

{ #category : 'accessing' }
ChatPharoCLIHistory >> operation [

	^ operation
]

{ #category : 'accessing' }
ChatPharoCLIHistory >> operation: aSymbol [

	operation := aSymbol
]

{ #category : 'accessing' }
ChatPharoCLIHistory >> path [

	^ path
]

{ #category : 'accessing' }
ChatPharoCLIHistory >> path: aString [

	path := aString
]

{ #category : 'private' }
ChatPharoCLIHistory >> printError: messageString [
	"Print an error message"

	Transcript cr; show: '❌ Error: '; show: messageString; cr
]
