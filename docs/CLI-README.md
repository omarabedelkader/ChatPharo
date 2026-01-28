# ChatPharo Terminal Interface (CLI)

## 🎯 Overview

ChatPharo now features a powerful **command-line interface** inspired by [AMP function](https://ampcode.com), allowing you to interact with AI agents directly from the terminal **without needing a GUI**. This is perfect for:

- **Server environments** where GUI is not available
- **Automation and scripting** workflows
- **CI/CD pipelines** for AI-powered code analysis
- **Remote development** over SSH
- **Quick questions** without launching the full IDE
- **Integrated development** workflows

## 🚀 Quick Start

### 1. Installation

The CLI is built using [Clap](https://github.com/pharo-contributions/clap-st) for Pharo. It's automatically included when you install ChatPharo.

```bash
# Install ChatPharo (if not already installed)
git clone https://github.com/omarabedelkader/ChatPharo.git
cd ChatPharo

# Load the project in Pharo
# The CLI package (AI-ChatPharo-CLI) will be loaded automatically
```

### 2. Configuration

Before using the CLI, configure your AI agent and API key:

```bash
# Set your agent (claude, gemini, ollama, deepseek, mistral, lmstudio)
pharo ChatPharo.image clap chatpharo config set agent claude

# Set your API key
pharo ChatPharo.image clap chatpharo config set api-key YOUR_API_KEY_HERE

# Set the model (optional, defaults are provided)
pharo ChatPharo.image clap chatpharo config set model claude-opus-4-20250514

# Test the connection
pharo ChatPharo.image clap chatpharo config test
```

### 3. Your First Question

```bash
# Ask a simple question
pharo ChatPharo.image clap chatpharo ask "What is Pharo?"

# Ask with file context
pharo ChatPharo.image clap chatpharo ask "Explain this code" --file src/MyClass.st

# Interactive chat mode
pharo ChatPharo.image clap chatpharo chat
```

## 📖 Commands Reference

### `ask` - One-Shot Questions

Ask a single question and get an immediate response.

**Syntax:**
```bash
pharo ChatPharo.image clap chatpharo ask <question> [options]
```

**Options:**
- `--agent <name>` - Agent to use (claude, gemini, ollama, deepseek, mistral, lmstudio)
- `--model <name>` - Model to use (e.g., claude-opus-4-20250514)
- `--file <path>` - Attach file(s) to the prompt (can be used multiple times)
- `--system <prompt>` - Custom system prompt
- `--json` - Output response as JSON

**Examples:**

```bash
# Simple question
pharo ChatPharo.image clap chatpharo ask "What is polymorphism in Pharo?"

# With file attachment
pharo ChatPharo.image clap chatpharo ask "Review this code for bugs" --file src/MyClass.st

# Multiple files
pharo ChatPharo.image clap chatpharo ask "Explain how these classes interact" \
  --file src/Model.st \
  --file src/Controller.st \
  --file src/View.st

# With specific agent and model
pharo ChatPharo.image clap chatpharo ask "Write unit tests for this class" \
  --agent claude \
  --model claude-opus-4-20250514 \
  --file src/Calculator.st

# Custom system prompt
pharo ChatPharo.image clap chatpharo ask "Refactor this method" \
  --file src/LegacyCode.st \
  --system "You are a refactoring expert focused on clean code principles"

# JSON output (for scripting)
pharo ChatPharo.image clap chatpharo ask "What is 2+2?" --json
```

---

### `chat` - Interactive Mode

Start an interactive REPL-style chat session.

**Syntax:**
```bash
pharo ChatPharo.image clap chatpharo chat [options]
```

**Options:**
- `--agent <name>` - Agent to use
- `--model <name>` - Model to use
- `--system <prompt>` - Custom system prompt
- `--load <file>` - Load existing conversation from JSON

**In-Chat Commands:**
- `/help` - Show available commands
- `/exit` or `/quit` - Exit chat
- `/clear` - Clear conversation history
- `/attach <file>` - Attach file to next message
- `/export <file>` - Export conversation to JSON
- `/save` - Save current configuration
- `/history` - Show conversation history
- `/model <name>` - Switch to different model

**Examples:**

```bash
# Start interactive chat with default agent
pharo ChatPharo.image clap chatpharo chat

# With specific agent and model
pharo ChatPharo.image clap chatpharo chat \
  --agent claude \
  --model claude-opus-4-20250514

# With custom system prompt
pharo ChatPharo.image clap chatpharo chat \
  --system "You are a Pharo expert specializing in Seaside web development"

# Load previous conversation
pharo ChatPharo.image clap chatpharo chat --load previous-session.json
```

**Interactive Session Example:**
```
╔════════════════════════════════════════════════════════╗
║         ChatPharo Terminal Interface v1.0              ║
╚════════════════════════════════════════════════════════╝

🤖 Agent: Claude (Anthropic)
📦 Model: claude-opus-4-20250514

💡 Type /help for available commands
💡 Type /exit to quit

💬 You: How do I create a new class in Pharo?
🤖 Claude is thinking...

🤖 Claude:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To create a new class in Pharo, you can use the System Browser...
[response continues]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 You: /attach src/MyClass.st
✅ Attached: MyClass.st (1234 bytes)

💬 You: Can you review this class?
🤖 Claude is thinking...
📎 With attachments: MyClass.st

[continues...]
```

---

### `config` - Configuration Management

Manage ChatPharo settings, agents, API keys, and models.

**Syntax:**
```bash
pharo ChatPharo.image clap chatpharo config <subcommand> [arguments]
```

**Subcommands:**
- `set <key> <value>` - Set a configuration value
- `get <key>` - Get a configuration value
- `list <what>` - List available options
- `test` - Test connection to configured agent

**Examples:**

```bash
# Set API key
pharo ChatPharo.image clap chatpharo config set api-key sk-ant-api03-xxx...

# Set agent
pharo ChatPharo.image clap chatpharo config set agent claude
pharo ChatPharo.image clap chatpharo config set agent ollama
pharo ChatPharo.image clap chatpharo config set agent gemini

# Set model
pharo ChatPharo.image clap chatpharo config set model claude-opus-4-20250514
pharo ChatPharo.image clap chatpharo config set model mistral:latest

# Get current configuration
pharo ChatPharo.image clap chatpharo config get agent
pharo ChatPharo.image clap chatpharo config get model
pharo ChatPharo.image clap chatpharo config get api-key

# List available agents
pharo ChatPharo.image clap chatpharo config list agents

# List available models (for current agent)
pharo ChatPharo.image clap chatpharo config list models

# Show all settings
pharo ChatPharo.image clap chatpharo config list settings

# Test connection
pharo ChatPharo.image clap chatpharo config test
```

**Available Agents:**
- **claude** - Anthropic Claude (API key required)
- **gemini** - Google Gemini (API key required)
- **ollama** - Local Ollama server (no API key needed)
- **deepseek** - DeepSeek AI (API key required)
- **mistral** - Mistral AI (API key required)
- **lmstudio** - Local LM Studio (no API key needed)

---

### `history` - Conversation Management

Export, import, and manage conversation history.

**Syntax:**
```bash
pharo ChatPharo.image clap chatpharo history <subcommand> [arguments]
```

**Subcommands:**
- `export <file>` - Export conversation to JSON
- `import <file>` - Import conversation from JSON
- `clear` - Clear conversation history

**Examples:**

```bash
# Export conversation
pharo ChatPharo.image clap chatpharo history export conversation.json

# Import conversation
pharo ChatPharo.image clap chatpharo history import conversation.json

# Clear history
pharo ChatPharo.image clap chatpharo history clear
```

---

## 🔧 Advanced Usage

### Scripting with ChatPharo CLI

The CLI is designed to be script-friendly:

```bash
#!/bin/bash
# analyze-code.sh - Automated code review script

PHARO="pharo ChatPharo.image clap chatpharo"

# Configure agent
$PHARO config set agent claude
$PHARO config set model claude-opus-4-20250514

# Analyze all classes in src/
for file in src/*.st; do
  echo "Analyzing $file..."
  $PHARO ask "Review this code for potential issues" --file "$file" --json >> report.json
done

echo "Analysis complete! See report.json"
```

### CI/CD Integration

```yaml
# .github/workflows/ai-review.yml
name: AI Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Pharo
        run: |
          # Install Pharo and ChatPharo

      - name: Configure ChatPharo
        env:
          CLAUDE_API_KEY: ${{ secrets.CLAUDE_API_KEY }}
        run: |
          pharo ChatPharo.image clap chatpharo config set agent claude
          pharo ChatPharo.image clap chatpharo config set api-key $CLAUDE_API_KEY

      - name: Review changed files
        run: |
          for file in $(git diff --name-only origin/main); do
            pharo ChatPharo.image clap chatpharo ask \
              "Review this code change" \
              --file "$file" \
              --json >> review.json
          done

      - name: Post results
        # Post review results as PR comment
```

### Using Local Models (Ollama)

For privacy-sensitive projects or offline work:

```bash
# Setup Ollama
brew install ollama  # macOS
# or: curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull mistral

# Configure ChatPharo to use Ollama
pharo ChatPharo.image clap chatpharo config set agent ollama
pharo ChatPharo.image clap chatpharo config set model mistral:latest

# No API key needed!
pharo ChatPharo.image clap chatpharo ask "Explain this code" --file src/MyClass.st
```

---

## 💡 Use Cases

### 1. Code Review Assistant

```bash
# Review a class before committing
pharo ChatPharo.image clap chatpharo ask \
  "Review this code for bugs, performance issues, and style" \
  --file src/UserManager.st \
  --system "You are a senior Pharo developer focused on best practices"
```

### 2. Documentation Generation

```bash
# Generate documentation for a class
pharo ChatPharo.image clap chatpharo ask \
  "Generate comprehensive documentation for this class" \
  --file src/Calculator.st > docs/Calculator.md
```

### 3. Test Generation

```bash
# Generate unit tests
pharo ChatPharo.image clap chatpharo ask \
  "Generate comprehensive SUnit tests for this class" \
  --file src/StringProcessor.st > tests/StringProcessorTest.st
```

### 4. Refactoring Suggestions

```bash
# Get refactoring suggestions
pharo ChatPharo.image clap chatpharo ask \
  "Suggest refactorings to improve this code" \
  --file src/LegacyController.st
```

### 5. Learning Assistant

```bash
# Start interactive learning session
pharo ChatPharo.image clap chatpharo chat \
  --system "You are a patient Pharo tutor. Explain concepts clearly with examples."
```

### 6. Project Understanding

```bash
# Understand relationships between classes
pharo ChatPharo.image clap chatpharo ask \
  "Explain how these classes work together and their responsibilities" \
  --file src/Model.st \
  --file src/View.st \
  --file src/Controller.st
```

---

## 🔐 Security & Privacy

### API Keys

API keys are stored in ChatPharo's settings file:
```
<pharo-image-directory>/chatpharo/chatpharo-settings.ston
```

**Best Practices:**
- Never commit API keys to version control
- Use environment variables in scripts:
  ```bash
  pharo ChatPharo.image clap chatpharo config set api-key $CLAUDE_API_KEY
  ```
- Consider using local models (Ollama) for sensitive code

### Local Models

For maximum privacy, use local models:
- **Ollama** - Run models locally, no data leaves your machine
- **LM Studio** - Another local option with GUI

---

## 🐛 Troubleshooting

### "Agent not configured" error

```bash
# Solution: Set up your agent first
pharo ChatPharo.image clap chatpharo config set agent claude
pharo ChatPharo.image clap chatpharo config set api-key YOUR_KEY
```

### "Connection failed" error

```bash
# Check your configuration
pharo ChatPharo.image clap chatpharo config test

# Verify API key
pharo ChatPharo.image clap chatpharo config get api-key

# Try a different agent
pharo ChatPharo.image clap chatpharo config set agent ollama
```

### "File not found" error

```bash
# Use absolute paths or verify relative paths
pharo ChatPharo.image clap chatpharo ask "Explain" --file /absolute/path/to/file.st

# Or from project root
cd /path/to/project
pharo /path/to/ChatPharo.image clap chatpharo ask "Explain" --file src/MyClass.st
```

### Ollama connection issues

```bash
# Verify Ollama is running
ollama list

# Start Ollama service
ollama serve

# Pull required model
ollama pull mistral
```

---

## 📚 Additional Resources

- **Clap Documentation**: [https://github.com/pharo-contributions/clap-st](https://github.com/pharo-contributions/clap-st)
- **ChatPharo Main Docs**: See main README.md
- **AMP Function**: [https://ampcode.com](https://ampcode.com) (inspiration)
- **Pharo by Example**: [http://books.pharo.org](http://books.pharo.org)

---

## 🤝 Contributing

Contributions are welcome! To contribute to the CLI:

1. Fork the repository
2. Create a feature branch
3. Make your changes in `src/AI-ChatPharo-CLI/`
4. Add tests if applicable
5. Submit a pull request

---

## 📝 License

ChatPharo is open source. See the main repository LICENSE file.

---

## 🎓 Academic Context

This terminal interface was developed as part of a university project to make AI-powered development tools more accessible in command-line environments, following the principles of tools like AMP function.

**Developed by**: Omar Abedelkader
**Institution**: [Your University]
**Course**: [Course Name]
**Supervisor**: [Professor Name]

---

**Made with ❤️ using Pharo Smalltalk**
