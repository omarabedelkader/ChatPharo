"
The **ChatPharo Command-Line Interface**.

A terminal-based interface for ChatPharo inspired by AMP function (https://ampcode.com).
Allows users to interact with AI agents directly from the command line without a GUI.

**Usage:**

One-shot questions:
```bash
pharo ChatPharo.image clap chatpharo ask 'How do I create a class in Pharo?'
pharo ChatPharo.image clap chatpharo ask 'Explain this code' --file src/MyClass.st
```

Interactive chat mode:
```bash
pharo ChatPharo.image clap chatpharo chat
pharo ChatPharo.image clap chatpharo chat --agent claude --model claude-opus-4-20250514
```

Configuration:
```bash
pharo ChatPharo.image clap chatpharo config set api-key YOUR_KEY
pharo ChatPharo.image clap chatpharo config set agent claude
pharo ChatPharo.image clap chatpharo config list agents
```

History management:
```bash
pharo ChatPharo.image clap chatpharo history export output.json
pharo ChatPharo.image clap chatpharo history import input.json
```

**Features:**
- One-shot and interactive modes
- File attachment support
- Multiple agent backends (Claude, Gemini, Ollama, etc.)
- Conversation export/import
- Configuration management
"
Class {
	#name : 'ChatPharoCLI',
	#superclass : 'ClapApplication',
	#category : 'AI-ChatPharo-CLI',
	#package : 'AI-ChatPharo-CLI'
}

{ #category : 'commands' }
ChatPharoCLI class >> chatpharoCommand [
	<commandline>

	^ (ClapCommand withName: 'chatpharo')
		description: 'ChatPharo terminal interface - interact with AI agents from the command line';
		add: self askCommand;
		add: self chatCommand;
		add: self configCommand;
		add: self historyCommand;
		yourself
]

{ #category : 'commands - ask' }
ChatPharoCLI class >> askCommand [

	^ (ClapCommand withName: 'ask')
		description: 'Ask a single question and get a response (one-shot mode)';
		add: ((ClapPositional withName: 'question')
			description: 'The question to ask';
			meaning: [ :arg | arg word ];
			yourself);
		add: ((ClapFlag withName: 'agent')
			description: 'Agent to use (claude, gemini, ollama, deepseek, mistral, lmstudio)';
			add: (ClapPositional withName: 'name');
			yourself);
		add: ((ClapFlag withName: 'model')
			description: 'Model to use (e.g., claude-opus-4-20250514)';
			add: (ClapPositional withName: 'name');
			yourself);
		add: ((ClapFlag withName: 'file')
			description: 'Attach file(s) to the prompt (can be used multiple times)';
			add: (ClapPositional withName: 'path');
			multiple;
			yourself);
		add: ((ClapFlag withName: 'system')
			description: 'Custom system prompt';
			add: (ClapPositional withName: 'prompt');
			yourself);
		add: (ClapFlag withName: 'json')
			description: 'Output response as JSON';
		meaning: [ :args |
			ChatPharoCLIAsk new
				question: (args at: 'question');
				agent: (args atName: 'agent' ifFound: [ :v | v value ] ifNone: [ nil ]);
				model: (args atName: 'model' ifFound: [ :v | v value ] ifNone: [ nil ]);
				files: (args atName: 'file' ifFound: [ :flags | flags collect: [ :f | f value ] ] ifNone: [ #() ]);
				systemPrompt: (args atName: 'system' ifFound: [ :v | v value ] ifNone: [ nil ]);
				jsonOutput: (args includesKey: 'json');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - chat' }
ChatPharoCLI class >> chatCommand [

	^ (ClapCommand withName: 'chat')
		description: 'Start an interactive chat session (REPL mode)';
		add: ((ClapFlag withName: 'agent')
			description: 'Agent to use (claude, gemini, ollama, deepseek, mistral, lmstudio)';
			add: (ClapPositional withName: 'name');
			yourself);
		add: ((ClapFlag withName: 'model')
			description: 'Model to use (e.g., claude-opus-4-20250514)';
			add: (ClapPositional withName: 'name');
			yourself);
		add: ((ClapFlag withName: 'system')
			description: 'Custom system prompt';
			add: (ClapPositional withName: 'prompt');
			yourself);
		add: ((ClapFlag withName: 'load')
			description: 'Load existing conversation from JSON file';
			add: (ClapPositional withName: 'path');
			yourself);
		meaning: [ :args |
			ChatPharoCLIChat new
				agent: (args atName: 'agent' ifFound: [ :v | v value ] ifNone: [ nil ]);
				model: (args atName: 'model' ifFound: [ :v | v value ] ifNone: [ nil ]);
				systemPrompt: (args atName: 'system' ifFound: [ :v | v value ] ifNone: [ nil ]);
				loadFrom: (args atName: 'load' ifFound: [ :v | v value ] ifNone: [ nil ]);
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - config' }
ChatPharoCLI class >> configCommand [

	^ (ClapCommand withName: 'config')
		description: 'Manage ChatPharo configuration';
		add: self configSetCommand;
		add: self configGetCommand;
		add: self configListCommand;
		add: self configTestCommand;
		yourself
]

{ #category : 'commands - config' }
ChatPharoCLI class >> configSetCommand [

	^ (ClapCommand withName: 'set')
		description: 'Set a configuration value';
		add: ((ClapPositional withName: 'key')
			description: 'Configuration key (api-key, agent, model)';
			meaning: [ :arg | arg word ];
			yourself);
		add: ((ClapPositional withName: 'value')
			description: 'Configuration value';
			meaning: [ :arg | arg word ];
			yourself);
		meaning: [ :args |
			ChatPharoCLIConfig new
				operation: #set;
				key: (args at: 'key');
				value: (args at: 'value');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - config' }
ChatPharoCLI class >> configGetCommand [

	^ (ClapCommand withName: 'get')
		description: 'Get a configuration value';
		add: ((ClapPositional withName: 'key')
			description: 'Configuration key (api-key, agent, model)';
			meaning: [ :arg | arg word ];
			yourself);
		meaning: [ :args |
			ChatPharoCLIConfig new
				operation: #get;
				key: (args at: 'key');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - config' }
ChatPharoCLI class >> configListCommand [

	^ (ClapCommand withName: 'list')
		description: 'List available options';
		add: ((ClapPositional withName: 'what')
			description: 'What to list (agents, models, settings)';
			meaning: [ :arg | arg word ];
			yourself);
		meaning: [ :args |
			ChatPharoCLIConfig new
				operation: #list;
				key: (args at: 'what');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - config' }
ChatPharoCLI class >> configTestCommand [

	^ (ClapCommand withName: 'test')
		description: 'Test connection to the configured agent';
		meaning: [ :args |
			ChatPharoCLIConfig new
				operation: #test;
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - history' }
ChatPharoCLI class >> historyCommand [

	^ (ClapCommand withName: 'history')
		description: 'Manage conversation history';
		add: self historyExportCommand;
		add: self historyImportCommand;
		add: self historyClearCommand;
		yourself
]

{ #category : 'commands - history' }
ChatPharoCLI class >> historyExportCommand [

	^ (ClapCommand withName: 'export')
		description: 'Export current conversation to JSON file';
		add: ((ClapPositional withName: 'path')
			description: 'Output file path';
			meaning: [ :arg | arg word ];
			yourself);
		meaning: [ :args |
			ChatPharoCLIHistory new
				operation: #export;
				path: (args at: 'path');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - history' }
ChatPharoCLI class >> historyImportCommand [

	^ (ClapCommand withName: 'import')
		description: 'Import conversation from JSON file';
		add: ((ClapPositional withName: 'path')
			description: 'Input file path';
			meaning: [ :arg | arg word ];
			yourself);
		meaning: [ :args |
			ChatPharoCLIHistory new
				operation: #import;
				path: (args at: 'path');
				execute;
				yourself ];
		yourself
]

{ #category : 'commands - history' }
ChatPharoCLI class >> historyClearCommand [

	^ (ClapCommand withName: 'clear')
		description: 'Clear conversation history';
		meaning: [ :args |
			ChatPharoCLIHistory new
				operation: #clear;
				execute;
				yourself ];
		yourself
]
