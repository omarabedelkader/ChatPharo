"
Handles the **config** command for managing ChatPharo settings.

Allows configuration of agents, API keys, models, and other settings
from the command line.

**Subcommands:**
- `set` - Set a configuration value
- `get` - Get a configuration value
- `list` - List available options (agents, models, settings)
- `test` - Test connection to configured agent

**Example usage:**
```bash
# Set API key for current agent
pharo ChatPharo.image clap chatpharo config set api-key YOUR_API_KEY

# Set agent
pharo ChatPharo.image clap chatpharo config set agent claude

# Set model
pharo ChatPharo.image clap chatpharo config set model claude-opus-4-20250514

# Get current configuration
pharo ChatPharo.image clap chatpharo config get agent
pharo ChatPharo.image clap chatpharo config get model

# List available agents
pharo ChatPharo.image clap chatpharo config list agents

# List available models
pharo ChatPharo.image clap chatpharo config list models

# Test connection
pharo ChatPharo.image clap chatpharo config test
```
"
Class {
	#name : 'ChatPharoCLIConfig',
	#superclass : 'Object',
	#instVars : [
		'operation',
		'key',
		'value'
	],
	#category : 'AI-ChatPharo-CLI',
	#package : 'AI-ChatPharo-CLI'
}

{ #category : 'execution' }
ChatPharoCLIConfig >> execute [
	"Execute the config command based on operation"

	self operation = #set ifTrue: [ ^ self executeSet ].
	self operation = #get ifTrue: [ ^ self executeGet ].
	self operation = #list ifTrue: [ ^ self executeList ].
	self operation = #test ifTrue: [ ^ self executeTest ].

	self printError: 'Unknown operation: ', self operation asString.
	self exitWithError
]

{ #category : 'execution - get' }
ChatPharoCLIConfig >> executeGet [
	"Get a configuration value"

	| settings normalizedKey result |
	settings := ChatPharoSettings default.
	normalizedKey := self key asLowercase.

	normalizedKey = 'agent' ifTrue: [
		result := settings agent
			ifNotNil: [ :a | a class name ]
			ifNil: [ 'Not configured' ].
		Transcript show: 'Agent: '; show: result; cr.
		^ self exitSuccess
	].

	normalizedKey = 'model' ifTrue: [
		result := settings agent
			ifNotNil: [ :a | a model ]
			ifNil: [ 'Not configured' ].
		Transcript show: 'Model: '; show: result; cr.
		^ self exitSuccess
	].

	normalizedKey = 'api-key' ifTrue: [
		result := settings agent
			ifNotNil: [ :a |
				(a respondsTo: #apiKey)
					ifTrue: [ (a apiKey first: 10), '...' ]
					ifFalse: [ 'N/A (local agent)' ]
			]
			ifNil: [ 'Not configured' ].
		Transcript show: 'API Key: '; show: result; cr.
		^ self exitSuccess
	].

	self printError: 'Unknown configuration key: ', self key.
	self exitWithError
]

{ #category : 'execution - list' }
ChatPharoCLIConfig >> executeList [
	"List available options"

	| normalizedKey |
	normalizedKey := self key asLowercase.

	normalizedKey = 'agents' ifTrue: [ ^ self listAgents ].
	normalizedKey = 'models' ifTrue: [ ^ self listModels ].
	normalizedKey = 'settings' ifTrue: [ ^ self listSettings ].

	self printError: 'Unknown list option: ', self key.
	self printError: 'Available: agents, models, settings'.
	self exitWithError
]

{ #category : 'execution - set' }
ChatPharoCLIConfig >> executeSet [
	"Set a configuration value"

	| settings normalizedKey |
	settings := ChatPharoSettings default.
	normalizedKey := self key asLowercase.

	normalizedKey = 'agent' ifTrue: [ ^ self setAgent ].
	normalizedKey = 'api-key' ifTrue: [ ^ self setApiKey ].
	normalizedKey = 'model' ifTrue: [ ^ self setModel ].

	self printError: 'Unknown configuration key: ', self key.
	self printError: 'Available keys: agent, api-key, model'.
	self exitWithError
]

{ #category : 'execution - test' }
ChatPharoCLIConfig >> executeTest [
	"Test connection to configured agent"

	| settings agent result |
	settings := ChatPharoSettings default.
	agent := settings agent.

	agent ifNil: [
		self printError: 'No agent configured. Run: chatpharo config set agent <name>'.
		^ self exitWithError
	].

	Transcript show: 'Testing connection to '; show: agent displayName; show: '...'; cr.

	[
		result := agent testConnection.
		result
			ifTrue: [
				Transcript show: '✅ Connection successful!'; cr.
				Transcript show: '   Agent: '; show: agent displayName; cr.
				Transcript show: '   Model: '; show: agent model; cr.
				self exitSuccess
			]
			ifFalse: [
				self printError: 'Connection failed!'.
				self exitWithError
			]
	] on: Error do: [ :ex |
		self printError: 'Connection error: ', ex messageText.
		self exitWithError
	]
]

{ #category : 'private' }
ChatPharoCLIConfig >> exitSuccess [
	"Exit with success code"

	Smalltalk snapshot: false andQuit: true
]

{ #category : 'private' }
ChatPharoCLIConfig >> exitWithError [
	"Exit with error code"

	Smalltalk snapshot: false andQuit: true exitCode: 1
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> key [

	^ key
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> key: aString [

	key := aString
]

{ #category : 'private - list' }
ChatPharoCLIConfig >> listAgents [
	"List available agents"

	Transcript cr;
		show: '📋 Available Agents:'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr;
		show: '  claude     - Anthropic Claude (API key required)'; cr;
		show: '  gemini     - Google Gemini (API key required)'; cr;
		show: '  ollama     - Local Ollama (no API key)'; cr;
		show: '  deepseek   - DeepSeek AI (API key required)'; cr;
		show: '  mistral    - Mistral AI (API key required)'; cr;
		show: '  lmstudio   - Local LM Studio (no API key)'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr;
		cr.

	self exitSuccess
]

{ #category : 'private - list' }
ChatPharoCLIConfig >> listModels [
	"List available models for current agent"

	| settings agent models |
	settings := ChatPharoSettings default.
	agent := settings agent.

	agent ifNil: [
		self printError: 'No agent configured. Configure an agent first.'.
		^ self exitWithError
	].

	Transcript cr;
		show: '📋 Available Models for '; show: agent displayName; show: ':'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr.

	[
		models := agent modelNames.
		models do: [ :modelName |
			Transcript show: '  '; show: modelName; cr
		].
	] on: Error do: [ :ex |
		Transcript show: '  (Unable to fetch models: '; show: ex messageText; show: ')'; cr
	].

	Transcript show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr; cr.

	self exitSuccess
]

{ #category : 'private - list' }
ChatPharoCLIConfig >> listSettings [
	"List all current settings"

	| settings agent |
	settings := ChatPharoSettings default.
	agent := settings agent.

	Transcript cr;
		show: '⚙️  Current Configuration:'; cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr.

	agent
		ifNotNil: [
			Transcript show: '  Agent:        '; show: agent displayName; cr.
			Transcript show: '  Model:        '; show: agent model; cr.
			(agent respondsTo: #apiKey) ifTrue: [
				agent apiKey ifNotNil: [ :key |
					Transcript show: '  API Key:      '; show: (key first: 10); show: '...'; cr
				]
			].
			(agent respondsTo: #host) ifTrue: [
				Transcript show: '  Host:         '; show: agent host; cr
			].
			(agent respondsTo: #port) ifTrue: [
				Transcript show: '  Port:         '; show: agent port; cr
			]
		]
		ifNil: [
			Transcript show: '  Agent:        Not configured'; cr
		].

	Transcript
		show: '  Cache:        '; show: (settings cacheEnabled ifTrue: [ 'Enabled' ] ifFalse: [ 'Disabled' ]); cr;
		show: '  Memory:       '; show: (settings memoryEnabled ifTrue: [ 'Enabled' ] ifFalse: [ 'Disabled' ]); cr;
		show: '  Logging:      '; show: (settings loggingEnabled ifTrue: [ 'Enabled' ] ifFalse: [ 'Disabled' ]); cr;
		show: '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'; cr;
		cr.

	self exitSuccess
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> operation [

	^ operation
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> operation: aSymbol [

	operation := aSymbol
]

{ #category : 'private' }
ChatPharoCLIConfig >> printError: messageString [
	"Print an error message"

	Transcript cr; show: '❌ Error: '; show: messageString; cr
]

{ #category : 'private - set' }
ChatPharoCLIConfig >> setAgent [
	"Set the agent"

	| settings normalizedValue newAgent |
	settings := ChatPharoSettings default.
	normalizedValue := self value asLowercase.

	"Create new agent"
	newAgent := self createAgentNamed: normalizedValue.

	"Save to settings"
	settings agent: newAgent.
	ChatPharoSettings saveDefault.

	Transcript show: '✅ Agent set to: '; show: newAgent displayName; cr.
	self exitSuccess
]

{ #category : 'private - set' }
ChatPharoCLIConfig >> setApiKey [
	"Set the API key for current agent"

	| settings agent |
	settings := ChatPharoSettings default.
	agent := settings agent.

	agent ifNil: [
		self printError: 'No agent configured. Set agent first: chatpharo config set agent <name>'.
		^ self exitWithError
	].

	(agent respondsTo: #apiKey:) ifFalse: [
		self printError: 'Current agent does not use API keys (local agent)'.
		^ self exitWithError
	].

	agent apiKey: self value.
	ChatPharoSettings saveDefault.

	Transcript show: '✅ API key configured for '; show: agent displayName; cr.
	self exitSuccess
]

{ #category : 'private - set' }
ChatPharoCLIConfig >> setModel [
	"Set the model for current agent"

	| settings agent |
	settings := ChatPharoSettings default.
	agent := settings agent.

	agent ifNil: [
		self printError: 'No agent configured. Set agent first: chatpharo config set agent <name>'.
		^ self exitWithError
	].

	agent model: self value.
	ChatPharoSettings saveDefault.

	Transcript show: '✅ Model set to: '; show: self value; cr.
	self exitSuccess
]

{ #category : 'private' }
ChatPharoCLIConfig >> createAgentNamed: agentName [
	"Create an agent instance by name"

	agentName = 'claude' ifTrue: [ ^ ChatPharoClaudeAgent new ].
	agentName = 'gemini' ifTrue: [ ^ ChatPharoGeminiAgent new ].
	agentName = 'ollama' ifTrue: [
		^ ChatPharoOllamaAgent new
			host: 'localhost';
			port: '11434';
			model: 'mistral:latest';
			yourself
	].
	agentName = 'deepseek' ifTrue: [ ^ ChatPharoDeepSeekAgent new ].
	agentName = 'mistral' ifTrue: [ ^ ChatPharoMistralAgent new ].
	agentName = 'lmstudio' ifTrue: [
		^ ChatPharoLMStudioAgent new
			host: 'localhost';
			port: '1234';
			model: 'local-model';
			yourself
	].

	self printError: 'Unknown agent: ', agentName.
	self printError: 'Available agents: claude, gemini, ollama, deepseek, mistral, lmstudio'.
	self exitWithError
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> value [

	^ value
]

{ #category : 'accessing' }
ChatPharoCLIConfig >> value: aString [

	value := aString
]
