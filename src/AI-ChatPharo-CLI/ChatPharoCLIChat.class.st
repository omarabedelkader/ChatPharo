"
Handles the **chat** command for interactive conversations.

Provides a REPL (Read-Eval-Print Loop) interface where users can have
back-and-forth conversations with the AI agent.

**Features:**
- Interactive command loop
- Multi-line input support
- File attachment during conversation
- Conversation history
- Special commands (/help, /exit, /clear, /attach, /export, /save)

**Example usage:**
```bash
# Start interactive chat
pharo ChatPharo.image clap chatpharo chat

# With specific agent
pharo ChatPharo.image clap chatpharo chat --agent claude --model claude-opus-4-20250514

# Load existing conversation
pharo ChatPharo.image clap chatpharo chat --load conversation.json

# Custom system prompt
pharo ChatPharo.image clap chatpharo chat --system 'You are a Pharo expert'
```

**Special commands in chat:**
- `/help` - Show available commands
- `/exit` or `/quit` - Exit chat
- `/clear` - Clear conversation history
- `/attach <file>` - Attach file to next message
- `/export <file>` - Export conversation to JSON
- `/save` - Save current agent configuration
- `/history` - Show conversation history
- `/model <name>` - Switch model
"
Class {
	#name : 'ChatPharoCLIChat',
	#superclass : 'Object',
	#instVars : [
		'agent',
		'model',
		'systemPrompt',
		'loadFrom',
		'chat',
		'attachments'
	],
	#category : 'AI-ChatPharo-CLI',
	#package : 'AI-ChatPharo-CLI'
}

{ #category : 'accessing' }
ChatPharoCLIChat >> agent [

	^ agent
]

{ #category : 'accessing' }
ChatPharoCLIChat >> agent: aString [

	agent := aString
]

{ #category : 'private' }
ChatPharoCLIChat >> createAgent [
	"Create and configure the agent based on CLI parameters"

	| agentInstance settings agentName |
	settings := ChatPharoSettings default.

	"Determine which agent to use"
	agentName := self agent ifNil: [
		settings agent ifNotNil: [ :a | a class name asLowercase ] ifNil: [ 'claude' ]
	].

	"Create agent instance"
	agentInstance := self createAgentNamed: agentName.

	"Configure model if specified"
	self model ifNotNil: [ :m | agentInstance model: m ].

	"Configure system prompt if specified"
	self systemPrompt ifNotNil: [ :sp | agentInstance systemPrompt: sp ].

	^ agentInstance
]

{ #category : 'private' }
ChatPharoCLIChat >> createAgentNamed: agentName [
	"Create an agent instance by name"

	| normalizedName |
	normalizedName := agentName asLowercase.

	normalizedName = 'claude' ifTrue: [ ^ self createClaudeAgent ].
	normalizedName = 'gemini' ifTrue: [ ^ self createGeminiAgent ].
	normalizedName = 'ollama' ifTrue: [ ^ self createOllamaAgent ].
	normalizedName = 'deepseek' ifTrue: [ ^ self createDeepSeekAgent ].
	normalizedName = 'mistral' ifTrue: [ ^ self createMistralAgent ].
	normalizedName = 'lmstudio' ifTrue: [ ^ self createLMStudioAgent ].

	"Default to current settings agent or Claude"
	^ ChatPharoSettings default agent ifNil: [ self createClaudeAgent ]
]

{ #category : 'private' }
ChatPharoCLIChat >> createClaudeAgent [
	"Create a Claude agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoClaudeAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'Claude API key not configured. Run: chatpharo config set api-key YOUR_KEY'.
		self exitWithError
	].

	^ ChatPharoClaudeAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'claude-opus-4-20250514' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIChat >> createDeepSeekAgent [
	"Create a DeepSeek agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoDeepSeekAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'DeepSeek API key not configured.'.
		self exitWithError
	].

	^ ChatPharoDeepSeekAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'deepseek-chat' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIChat >> createGeminiAgent [
	"Create a Gemini agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoGeminiAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'Gemini API key not configured.'.
		self exitWithError
	].

	^ ChatPharoGeminiAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'gemini-pro' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIChat >> createLMStudioAgent [
	"Create an LMStudio agent"

	^ ChatPharoLMStudioAgent new
		host: 'localhost';
		port: '1234';
		model: (self model ifNil: [ 'local-model' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIChat >> createMistralAgent [
	"Create a Mistral agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoMistralAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'Mistral API key not configured.'.
		self exitWithError
	].

	^ ChatPharoMistralAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'mistral-large-latest' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIChat >> createOllamaAgent [
	"Create an Ollama agent"

	^ ChatPharoOllamaAgent new
		host: 'localhost';
		port: '11434';
		model: (self model ifNil: [ 'mistral:latest' ]);
		yourself
]

{ #category : 'execution' }
ChatPharoCLIChat >> execute [
	"Execute the interactive chat command"

	| agentInstance |

	"Create and configure agent"
	agentInstance := self createAgent.

	"Create chat session"
	chat := ChatPharoChat new agent: agentInstance; yourself.

	"Load conversation if specified"
	self loadFrom ifNotNil: [ :path | self loadConversation: path ].

	"Print welcome message"
	self printWelcome: agentInstance.

	"Start interactive loop"
	self interactiveLoop.

	"Exit successfully"
	self exitSuccess
]

{ #category : 'private' }
ChatPharoCLIChat >> exitSuccess [
	"Exit with success code"

	Smalltalk snapshot: false andQuit: true
]

{ #category : 'private' }
ChatPharoCLIChat >> exitWithError [
	"Exit with error code"

	Smalltalk snapshot: false andQuit: true exitCode: 1
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleAttachCommand: input [
	"Handle /attach <file> command"

	| parts filePath fileRef |
	parts := input substrings.
	parts size < 2 ifTrue: [
		Transcript show: '❌ Usage: /attach <file-path>'; cr.
		^ self
	].

	filePath := parts allButFirst joinUsing: ' '.
	fileRef := filePath asFileReference.

	fileRef exists ifFalse: [
		Transcript show: '❌ File not found: '; show: filePath; cr.
		^ self
	].

	self attachments add: fileRef.
	Transcript show: '✅ Attached: '; show: fileRef basename;
		show: ' ('; show: fileRef size asString; show: ' bytes)'; cr
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleClearCommand [
	"Handle /clear command"

	chat reset.
	Transcript show: '✅ Conversation cleared'; cr
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleExportCommand: input [
	"Handle /export <file> command"

	| parts filePath json |
	parts := input substrings.
	parts size < 2 ifTrue: [
		Transcript show: '❌ Usage: /export <file-path>'; cr.
		^ self
	].

	filePath := parts allButFirst joinUsing: ' '.

	[
		json := chat exportAsJson.
		filePath asFileReference writeStreamDo: [ :stream |
			stream nextPutAll: json
		].
		Transcript show: '✅ Conversation exported to: '; show: filePath; cr
	] on: Error do: [ :ex |
		Transcript show: '❌ Export failed: '; show: ex messageText; cr
	]
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleHelpCommand [
	"Handle /help command"

	Transcript cr;
		show: '📖 Available Commands:'; cr;
		show: '  /help           - Show this help message'; cr;
		show: '  /exit or /quit  - Exit chat'; cr;
		show: '  /clear          - Clear conversation history'; cr;
		show: '  /attach <file>  - Attach file to next message'; cr;
		show: '  /export <file>  - Export conversation to JSON'; cr;
		show: '  /save           - Save current configuration'; cr;
		show: '  /history        - Show conversation history'; cr;
		show: '  /model <name>   - Switch to different model'; cr;
		cr
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleHistoryCommand [
	"Handle /history command"

	chat messages ifEmpty: [
		Transcript show: '📭 No messages yet'; cr.
		^ self
	].

	Transcript cr; show: '📜 Conversation History:'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr.

	chat messages do: [ :msg |
		Transcript cr;
			show: '👤 You: '; show: msg content; cr;
			show: '🤖 '; show: msg assistantLabel; show: ': ';
			show: msg answer; cr;
			show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr
	]
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleModelCommand: input [
	"Handle /model <name> command"

	| parts modelName |
	parts := input substrings.
	parts size < 2 ifTrue: [
		Transcript show: '❌ Usage: /model <model-name>'; cr.
		^ self
	].

	modelName := parts allButFirst joinUsing: ' '.
	chat agent model: modelName.
	Transcript show: '✅ Switched to model: '; show: modelName; cr
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleSaveCommand [
	"Handle /save command"

	[
		ChatPharoSettings saveDefault.
		Transcript show: '✅ Configuration saved'; cr
	] on: Error do: [ :ex |
		Transcript show: '❌ Save failed: '; show: ex messageText; cr
	]
]

{ #category : 'private - commands' }
ChatPharoCLIChat >> handleSpecialCommand: input [
	"Handle special commands starting with /"

	| command |
	command := (input substrings at: 1 ifAbsent: [ '' ]) asLowercase.

	command = '/help' ifTrue: [ ^ self handleHelpCommand ].
	command = '/exit' ifTrue: [ ^ self exitSuccess ].
	command = '/quit' ifTrue: [ ^ self exitSuccess ].
	command = '/clear' ifTrue: [ ^ self handleClearCommand ].
	command = '/attach' ifTrue: [ ^ self handleAttachCommand: input ].
	command = '/export' ifTrue: [ ^ self handleExportCommand: input ].
	command = '/save' ifTrue: [ ^ self handleSaveCommand ].
	command = '/history' ifTrue: [ ^ self handleHistoryCommand ].
	command = '/model' ifTrue: [ ^ self handleModelCommand: input ].

	Transcript show: '❌ Unknown command: '; show: command;
		show: ' (type /help for available commands)'; cr
]

{ #category : 'private' }
ChatPharoCLIChat >> interactiveLoop [
	"Main interactive loop for chat"

	| input |

	[
		"Show prompt"
		Transcript cr; show: '💬 You: '.

		"Read input"
		input := self readInput.

		"Check for empty input"
		input ifNil: [ ^ self ].
		input := input trim.
		input isEmpty ifTrue: [ ^ self interactiveLoop ].

		"Handle special commands"
		(input beginsWith: '/') ifTrue: [
			self handleSpecialCommand: input.
			^ self interactiveLoop
		].

		"Send message to agent"
		self sendMessage: input.

		"Continue loop"
		self interactiveLoop

	] on: Error do: [ :ex |
		Transcript cr; show: '❌ Error: '; show: ex messageText; cr.
		self interactiveLoop
	]
]

{ #category : 'private' }
ChatPharoCLIChat >> loadConversation: filePath [
	"Load conversation from JSON file"

	| fileRef json |
	fileRef := filePath asFileReference.

	fileRef exists ifFalse: [
		self printError: 'File not found: ', filePath.
		^ self
	].

	[
		json := fileRef contents.
		chat importFromJson: json.
		Transcript show: '✅ Loaded conversation from: '; show: filePath; cr
	] on: Error do: [ :ex |
		self printError: 'Failed to load conversation: ', ex messageText
	]
]

{ #category : 'accessing' }
ChatPharoCLIChat >> loadFrom [

	^ loadFrom
]

{ #category : 'accessing' }
ChatPharoCLIChat >> loadFrom: aString [

	loadFrom := aString
]

{ #category : 'accessing' }
ChatPharoCLIChat >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoCLIChat >> model: aString [

	model := aString
]

{ #category : 'accessing' }
ChatPharoCLIChat >> attachments [

	^ attachments ifNil: [ attachments := OrderedCollection new ]
]

{ #category : 'private' }
ChatPharoCLIChat >> printError: messageString [
	"Print an error message"

	Transcript cr; show: '❌ Error: '; show: messageString; cr
]

{ #category : 'private' }
ChatPharoCLIChat >> printWelcome: agentInstance [
	"Print welcome message"

	Transcript cr;
		show: '╔════════════════════════════════════════════════════════╗'; cr;
		show: '║         ChatPharo Terminal Interface v1.0              ║'; cr;
		show: '╚════════════════════════════════════════════════════════╝'; cr;
		cr;
		show: '🤖 Agent: '; show: agentInstance displayName; cr;
		show: '📦 Model: '; show: agentInstance model; cr;
		cr;
		show: '💡 Type /help for available commands'; cr;
		show: '💡 Type /exit to quit'; cr;
		cr
]

{ #category : 'private' }
ChatPharoCLIChat >> readInput [
	"Read input from stdin"

	^ FileStream stdin nextLine
]

{ #category : 'private' }
ChatPharoCLIChat >> sendMessage: messageText [
	"Send message to agent and wait for response"

	| currentAttachments response |

	"Get and clear attachments"
	currentAttachments := self attachments copy.
	self attachments removeAll.

	"Show thinking indicator"
	Transcript cr; show: '🤖 '; show: chat agent displayName; show: ' is thinking...'; cr.

	"Send message"
	currentAttachments ifEmpty: [
		chat sendMessage: messageText
	] ifNotEmpty: [
		Transcript show: '📎 With attachments: ';
			show: (currentAttachments collect: [ :f | f basename ]) asCommaString; cr.
		chat sendMessage: messageText withAttachments: currentAttachments
	].

	"Wait for response"
	[ chat promptProcess isNotNil and: [ chat promptProcess isTerminated not ] ]
		whileTrue: [ 50 milliSeconds wait ].

	"Print response"
	response := chat messages ifNotEmpty: [ :msgs | msgs last answer ] ifEmpty: [ 'No response' ].
	Transcript cr;
		show: '🤖 '; show: chat agent displayName; show: ':'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr;
		show: response; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr
]

{ #category : 'accessing' }
ChatPharoCLIChat >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
ChatPharoCLIChat >> systemPrompt: aString [

	systemPrompt := aString
]
