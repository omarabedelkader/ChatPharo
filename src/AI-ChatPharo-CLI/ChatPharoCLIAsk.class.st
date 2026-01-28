"
Handles the **ask** command for one-shot questions.

Sends a single question to the AI agent and prints the response to stdout.
Supports file attachments, custom agents, models, and system prompts.

**Example usage:**
```bash
# Simple question
pharo ChatPharo.image clap chatpharo ask 'What is Pharo?'

# With file attachment
pharo ChatPharo.image clap chatpharo ask 'Explain this code' --file src/MyClass.st

# With specific agent and model
pharo ChatPharo.image clap chatpharo ask 'Help me debug this' --agent claude --model claude-opus-4-20250514 --file app.st

# Custom system prompt
pharo ChatPharo.image clap chatpharo ask 'Write a test' --system 'You are a testing expert' --file MyClass.st

# JSON output
pharo ChatPharo.image clap chatpharo ask 'What is 2+2?' --json
```
"
Class {
	#name : 'ChatPharoCLIAsk',
	#superclass : 'Object',
	#instVars : [
		'question',
		'agent',
		'model',
		'files',
		'systemPrompt',
		'jsonOutput'
	],
	#category : 'AI-ChatPharo-CLI',
	#package : 'AI-ChatPharo-CLI'
}

{ #category : 'accessing' }
ChatPharoCLIAsk >> agent [

	^ agent
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> agent: aString [

	agent := aString
]

{ #category : 'private' }
ChatPharoCLIAsk >> createAgent [
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
ChatPharoCLIAsk >> createAgentNamed: agentName [
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
ChatPharoCLIAsk >> createClaudeAgent [
	"Create a Claude agent using saved API key or default settings"

	| settings apiKey |
	settings := ChatPharoSettings default.

	"Try to get API key from settings"
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
ChatPharoCLIAsk >> createDeepSeekAgent [
	"Create a DeepSeek agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoDeepSeekAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'DeepSeek API key not configured. Run: chatpharo config set api-key YOUR_KEY'.
		self exitWithError
	].

	^ ChatPharoDeepSeekAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'deepseek-chat' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIAsk >> createGeminiAgent [
	"Create a Gemini agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoGeminiAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'Gemini API key not configured. Run: chatpharo config set api-key YOUR_KEY'.
		self exitWithError
	].

	^ ChatPharoGeminiAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'gemini-pro' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIAsk >> createLMStudioAgent [
	"Create an LMStudio agent"

	| settings |
	settings := ChatPharoSettings default.

	^ ChatPharoLMStudioAgent new
		host: 'localhost';
		port: '1234';
		model: (self model ifNil: [ 'local-model' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIAsk >> createMistralAgent [
	"Create a Mistral agent"

	| settings apiKey |
	settings := ChatPharoSettings default.

	apiKey := settings agent
		ifNotNil: [ :a | (a isKindOf: ChatPharoMistralAgent) ifTrue: [ a apiKey ] ifFalse: [ nil ] ]
		ifNil: [ nil ].

	apiKey ifNil: [
		self printError: 'Mistral API key not configured. Run: chatpharo config set api-key YOUR_KEY'.
		self exitWithError
	].

	^ ChatPharoMistralAgent new
		apiKey: apiKey;
		model: (self model ifNil: [ 'mistral-large-latest' ]);
		yourself
]

{ #category : 'private' }
ChatPharoCLIAsk >> createOllamaAgent [
	"Create an Ollama agent"

	^ ChatPharoOllamaAgent new
		host: 'localhost';
		port: '11434';
		model: (self model ifNil: [ 'mistral:latest' ]);
		yourself
]

{ #category : 'execution' }
ChatPharoCLIAsk >> execute [
	"Execute the ask command"

	| chat agentInstance attachments response |

	"Create and configure agent"
	agentInstance := self createAgent.

	"Create chat session"
	chat := ChatPharoChat new agent: agentInstance; yourself.

	"Prepare file attachments"
	attachments := self prepareAttachments.

	"Print progress message"
	self jsonOutput ifFalse: [
		Transcript cr; show: '🤖 Asking '; show: agentInstance displayName; show: '...'; cr.
		attachments ifNotEmpty: [
			Transcript show: '📎 Attached files: ';
				show: (attachments collect: [ :f | f basename ]) asCommaString;
				cr
		]
	].

	"Send message and wait for response"
	attachments ifEmpty: [
		chat sendMessage: self question
	] ifNotEmpty: [
		chat sendMessage: self question withAttachments: attachments
	].

	"Wait for response"
	[ chat promptProcess isNotNil and: [ chat promptProcess isTerminated not ] ]
		whileTrue: [ 10 milliSeconds wait ].

	"Get response"
	response := chat messages ifNotEmpty: [ :msgs | msgs last answer ] ifEmpty: [ 'No response' ].

	"Output response"
	self outputResponse: response.

	"Exit successfully"
	self exitSuccess
]

{ #category : 'private' }
ChatPharoCLIAsk >> exitSuccess [
	"Exit with success code"

	Smalltalk snapshot: false andQuit: true
]

{ #category : 'private' }
ChatPharoCLIAsk >> exitWithError [
	"Exit with error code"

	Smalltalk snapshot: false andQuit: true exitCode: 1
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> files [

	^ files ifNil: [ files := OrderedCollection new ]
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> files: aCollection [

	files := aCollection
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> jsonOutput [

	^ jsonOutput ifNil: [ false ]
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> jsonOutput: aBoolean [

	jsonOutput := aBoolean
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> model: aString [

	model := aString
]

{ #category : 'private' }
ChatPharoCLIAsk >> outputResponse: responseText [
	"Output the response in the requested format"

	self jsonOutput
		ifTrue: [ self outputResponseAsJson: responseText ]
		ifFalse: [ self outputResponseAsText: responseText ]
]

{ #category : 'private' }
ChatPharoCLIAsk >> outputResponseAsJson: responseText [
	"Output response as JSON"

	| json |
	json := STONJSON toString: (Dictionary new
		at: 'question' put: self question;
		at: 'response' put: responseText;
		at: 'agent' put: self agent;
		at: 'model' put: self model;
		yourself).

	Transcript cr; show: json; cr
]

{ #category : 'private' }
ChatPharoCLIAsk >> outputResponseAsText: responseText [
	"Output response as plain text"

	Transcript cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr;
		show: responseText; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr
]

{ #category : 'private' }
ChatPharoCLIAsk >> prepareAttachments [
	"Convert file paths to FileReference objects"

	^ self files collect: [ :pathString |
		| fileRef |
		fileRef := pathString asFileReference.
		fileRef exists ifFalse: [
			self printError: 'File not found: ', pathString.
			self exitWithError
		].
		fileRef
	]
]

{ #category : 'private' }
ChatPharoCLIAsk >> printError: messageString [
	"Print an error message to stderr"

	Transcript cr; show: '❌ Error: '; show: messageString; cr
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> question [

	^ question
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> question: aString [

	question := aString
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
ChatPharoCLIAsk >> systemPrompt: aString [

	systemPrompt := aString
]
