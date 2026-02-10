"
Skill providing comprehensive help about ChatPharo itself.
This skill helps users understand how to use ChatPharo effectively,
troubleshoot common issues, and discover available features.
This skill provides documentation about:
- Getting started with ChatPharo
- Available AI agents and how to switch between them
- Tools and skills system
- Chat features and keyboard shortcuts
- Settings and configuration
- Common troubleshooting steps
- Integration with System Browser
"
Class {
	#name : 'ChatPharoHelpSkill',
	#superclass : 'ChatPharoSkill',
	#category : 'AI-ChatPharo-Skills',
	#package : 'AI-ChatPharo-Skills'
}

{ #category : 'accessing' }
ChatPharoHelpSkill >> contextString [

	^ '## ChatPharo Help & Documentation
### What is ChatPharo?
ChatPharo is an AI coding assistant integrated directly into the Pharo IDE. It provides:
- **AI-powered chat** for code exploration, debugging, and learning
- **Multiple AI agent support** (Claude, Gemini, Mistral, Ollama, LM Studio, DeepSeek, etc.)
- **Tools and skills system** for domain-specific knowledge
- **System Browser integration** for context-aware code assistance
- **Multi-tab conversations** to manage multiple topics
- **Tutorial system** with 16 interactive lessons
### Getting Started
#### First Launch
If this is your first time using ChatPharo, you should:
1. **Complete the setup wizard** - Configure your AI agent and API key
2. **Run the tutorial** - Learn ChatPharo features interactively
   - Execute: `ChatPharoTutorial start`
   - Or: Click the tutorial button in the toolbar
3. **Try example prompts**:
   - "How do I create a Spec2 window?"
   - "Explain the difference between OrderedCollection and Array"
   - "Show me examples of using Roassal for visualization"
#### Configuring AI Agents
1. Click the **Settings** button (gear icon) in the toolbar
2. Select your preferred AI agent from the list
3. Enter your API key (for cloud providers like Claude, Gemini)
4. For local models (Ollama, LM Studio), configure the endpoint URL
5. Save settings
**Supported AI Agents:**
- **Claude** (Anthropic) - Excellent for coding, analysis, and explanations
- **Gemini** (Google) - Fast and versatile
- **Mistral** - Open-source alternative
- **Ollama** - Run local models (llama3, codellama, mistral, etc.)
- **LM Studio** - Local model hosting with GUI
- **DeepSeek** - Specialized in code understanding
### Core Features
#### 1. Chat Interface
- **Type messages** in the text field at the bottom
- **Press Enter** or click Submit to send
- **Cancel** button stops ongoing AI responses
- **Copy/Execute** buttons on AI code snippets
- **Feedback buttons** (thumbs up/down) to rate responses
- **Multi-line input** supported (use Shift+Enter for new lines)
#### 2. Tools System
ChatPharo can execute tools to help you:
- **Search your code** - Find classes, methods, packages
- **Execute Smalltalk** - Run code snippets and see results
- **Browse documentation** - Access API docs and examples
- **Analyze dependencies** - Understand code relationships
**Creating Custom Tools:**
- Tools extend the AI''s capabilities
- Create new tools via Settings > Tools
- Define tool name, description, and parameters
- Implement the tool''s behavior in Smalltalk
#### 3. Skills System
Skills provide domain-specific knowledge to the AI:
**Available Skills:**
- **Spec2** - UI framework documentation
- **Roassal** - Visualization library
- **Collections** - Lists, sets, dictionaries
- **Bloc** - Modern graphics framework
**Using Skills:**
- **Automatic** - Skills activate when keywords are detected
- **Manual** - Enable specific skills in Settings > Skills
- Skills improve AI responses for specific topics
**When to enable skills manually:**
- Working extensively with a specific framework
- Getting generic answers about specialized topics
- Need detailed API documentation in context
#### 4. System Browser Integration
ChatPharo can provide context-aware help when you''re browsing code:
- **Enable in Settings** > Browser Integration
- **Ask about classes/methods** currently open in System Browser
- AI focuses answers on the package you''re exploring
- Get explanations of unfamiliar code patterns
**Example prompts when browsing:**
- "What does this class do?"
- "How is this method used in the system?"
- "Show me similar patterns in this package"
#### 5. Memory System
ChatPharo can remember important information across sessions:
- **Configure in Settings** > Memory
- **Enable long-term memory** to persist knowledge
- **Review memories** to see what AI has learned
- **Clear memories** to reset context
**Use cases:**
- Remember project-specific conventions
- Store frequently used code patterns
- Track ongoing work across sessions
#### 6. Multiverse Mode
Chain multiple AI agents together for complex tasks:
- **Enable in Settings** > Multiverse
- **Configure agent sequence** (e.g., Claude for planning, Codellama for implementation)
- Each agent processes the previous agent''s output
- Useful for multi-step workflows
### Keyboard Shortcuts & Tips
#### Essential Shortcuts
- **Enter** - Send message
- **Shift+Enter** - New line in message (if enabled)
- **Cmd/Ctrl+N** - New chat tab
- **Cmd/Ctrl+W** - Close current tab
- **Cmd/Ctrl+,** - Open settings
#### Chat Management
- **Multiple tabs** - Click "New Chat" to create another conversation
- **Tab names** - Automatically generated from conversation topic
- **Close tabs** - Click X on tab or use keyboard shortcut
- **Switch tabs** - Click tab headers to navigate
#### Message Features
- **Code blocks** in AI responses have Copy and Execute buttons
- **Markdown rendering** for formatted text
- **Syntax highlighting** for Smalltalk code
- **Thinking indicators** show when AI is processing
### Common Tasks & Examples
#### Learning Pharo Concepts
**Prompt:** "Explain blocks and closures in Pharo with examples"
**Prompt:** "What''s the difference between = and == ?"
**Prompt:** "How do I handle exceptions in Pharo?"
#### Exploring Existing Code
**Prompt:** "What does the Collection class hierarchy look like?"
**Prompt:** "Find all implementors of #printOn:"
**Prompt:** "Show me how to use the Visitor pattern in Pharo"
#### Writing New Code
**Prompt:** "Create a class to parse CSV files"
**Prompt:** "Write a method to calculate Fibonacci numbers recursively"
**Prompt:** "Build a simple HTTP client using Zinc"
#### Debugging Help
**Prompt:** "Why might I get a MessageNotUnderstood error?"
**Prompt:** "My UI isn''t refreshing - what should I check?"
**Prompt:** "How do I debug asynchronous code in Pharo?"
#### Spec2 UI Development
**Prompt:** "Create a window with a button and text input"
**Prompt:** "How do I make a resizable table with multiple columns?"
**Prompt:** "Show me how to create custom toolbar buttons"
**Note:** Enable the Spec2 skill for detailed UI help!
#### Roassal Visualization
**Prompt:** "Create a simple bar chart with Roassal"
**Prompt:** "How do I make an interactive node graph?"
**Prompt:** "Show me how to animate visualizations"
**Note:** Enable the Roassal skill for visualization help!
### Troubleshooting
#### "No response from AI"
**Solutions:**
1. Check your internet connection (for cloud agents)
2. Verify API key in Settings
3. Check API quota/billing for your provider
4. Try switching to a different AI agent
5. For local models (Ollama/LM Studio), ensure server is running
#### "AI gives generic answers"
**Solutions:**
1. **Enable relevant skills** for your topic (Spec2, Roassal, etc.)
2. **Provide more context** in your prompt
3. **Show code examples** in your question
4. **Enable Browser Integration** if working with specific classes
5. **Be specific** - instead of "How do I make a UI?", try "How do I create a Spec2 window with a table and submit button?"
#### "Code examples don''t work"
**Solutions:**
1. **Try executing** the code directly with Execute button
2. **Check for typos** in class/method names
3. **Verify dependencies** are loaded in your image
4. **Ask for clarification** - "This code gave an error: [paste error]"
5. **Update context** - "I''m using Pharo 12" if examples seem outdated
#### "Settings/Features not appearing"
**Solutions:**
1. **Update ChatPharo** to latest version
2. **Reload package** if recently installed
3. **Check permissions** for file system access (for memory features)
4. **Reset settings** if corrupted: `ChatPharoSettings reset`
#### "Slow responses"
**Solutions:**
1. **Switch to faster model** (e.g., Gemini Flash, Claude Haiku)
2. **Disable unused skills** to reduce context size
3. **Use local models** (Ollama) for faster iteration
4. **Clear long chat histories** - start new tab for fresh context
### Advanced Features
#### Custom System Prompts
Customize how the AI behaves:
1. Go to Settings > Agent Configuration
2. Edit the system prompt
3. Add project-specific instructions
4. Examples:
   - "Always use descriptive variable names"
   - "Prefer composition over inheritance"
   - "Include unit tests with all code"
#### Tutorial System
Interactive lessons covering:
- Basic ChatPharo usage
- Working with skills
- Browser integration
- Advanced features
- Custom tool creation
**Access:** `ChatPharoTutorial start` or click Tutorial button
#### Ethics Advisor
Optional feature to review code for:
- Security vulnerabilities
- Performance issues
- Code quality
- Best practices
**Enable in Settings** > Ethics Advisor
#### Sandboxing
Control what the AI can execute:
- **Enable in Settings** > Security
- **Configure allowed operations** (file access, network, etc.)
- **Protect sensitive data** from AI tools
- **Review tool usage** before execution
### Getting More Help
#### Resources
- **Tutorial** - Interactive lessons: `ChatPharoTutorial start`
- **Examples** - Built-in example prompts and use cases
- **Pharo Documentation** - Ask AI about specific classes/methods
- **Community** - Pharo Discord, mailing lists
#### Effective Prompting Tips
1. **Be specific** - Include context, constraints, and desired outcome
2. **Show examples** - "Like this, but for..." is very effective
3. **Iterate** - Start simple, then refine based on responses
4. **Use skills** - Enable relevant skills for specialized topics
5. **Break down complex tasks** - Ask step-by-step questions
6. **Reference code** - Paste snippets to get targeted help
7. **Specify Pharo version** - If targeting specific version
#### Example of Good vs. Bad Prompts
**Bad:** "make a ui"
**Good:** "Create a Spec2 window with a table showing Person objects (name, age), a text input to filter by name, and a button to add new entries"
**Bad:** "collections?"
**Good:** "What''s the difference between OrderedCollection, SortedCollection, and Array? When should I use each one?"
**Bad:** "error"
**Good:** "I''m getting a MessageNotUnderstood: #asInteger when I run this code: [paste code]. How do I fix it?"
### Privacy & Data
- **API Keys** stored locally in Pharo image
- **Chat history** saved locally (can be cleared)
- **Cloud agents** send messages to their respective APIs
- **Local agents** (Ollama, LM Studio) keep data on your machine
- **Memory system** stores data locally
- **No telemetry** sent from ChatPharo itself
### Tips for Best Experience
1. **Start with tutorial** if new to ChatPharo
2. **Use appropriate AI agent** for your task
   - Claude: Complex reasoning, code analysis
   - Gemini: Fast iterations, quick answers
   - Ollama: Privacy, offline work, experimentation
3. **Enable skills** before diving into specialized topics
4. **Use multiple tabs** to separate different conversations
5. **Provide context** - the more specific, the better
6. **Execute code** using the Execute button to verify
7. **Rate responses** with thumbs up/down to help improve
8. **Ask follow-up questions** - conversations build context
9. **Experiment** - try different phrasings, models, and skills
10. **Have fun!** ChatPharo is here to help you learn and build
### Quick Command Reference
```smalltalk
"Start tutorial"
ChatPharoTutorial start.
"Resume tutorial from where you left off"
ChatPharoTutorial resume.
"Open ChatPharo"
ChatPharoPresenter open.
"Reset settings to defaults"
ChatPharoSettings reset.
"Access skill registry"
ChatPharoSkillRegistry default.
"Enable a skill programmatically"
ChatPharoSkillRegistry default
    skillNamed: ''Spec2''
    ifPresent: [ :skill | skill enabled: true ].
"Create a new chat programmatically"
ChatPharoChat new.
```
### Remember
- **Ask questions freely** - no question is too basic
- **Iterate on solutions** - refine prompts based on results
- **Experiment with different agents** - each has strengths
- **Enable skills** when working with specific frameworks
- **Use the tutorial** to discover features you might miss
- **Provide feedback** with thumbs up/down to help improve responses
ChatPharo is designed to make Pharo development faster, easier, and more enjoyable. Whether you''re learning Pharo or building complex applications, the AI is here to assist you every step of the way!'
]

{ #category : 'accessing' }
ChatPharoHelpSkill >> description [

	^ 'Comprehensive help for using ChatPharo effectively. Covers getting started, features, tools, skills, troubleshooting, and tips for best experience.'
]

{ #category : 'accessing' }
ChatPharoHelpSkill >> keywords [

	^ #(
		'help' 'how' 'tutorial' 'guide' 'documentation' 'docs'
		'ChatPharo' 'getting started' 'setup' 'configure' 'settings'
		'troubleshoot' 'error' 'problem' 'issue' 'not working'
		'how do I' 'how to' 'what is' 'explain'
		'API key' 'agent' 'model' 'Claude' 'Gemini' 'Ollama'
		'skill' 'tool' 'feature' 'keyboard shortcut'
		'slow' 'fast' 'improve' 'better'
		'tutorial' 'learn' 'beginner' 'start'
	)
]

{ #category : 'accessing' }
ChatPharoHelpSkill >> name [

	^ 'ChatPharoHelp'
]
