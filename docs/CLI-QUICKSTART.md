# ChatPharo CLI - Quick Start Guide

## ⚡ Get Started in 5 Minutes

This guide will get you up and running with ChatPharo's terminal interface in just a few minutes.

---

## Step 1: Install Dependencies

### Install Clap (if not already installed)

Clap should be automatically loaded with ChatPharo. If you need to install it separately:

```smalltalk
"In Pharo Playground"
Metacello new
    baseline: 'Clap';
    repository: 'github://pharo-contributions/clap-st:master/src';
    load.
```

---

## Step 2: Choose Your Agent

ChatPharo supports multiple AI backends. Choose one:

### Option A: Claude (Recommended)

**Pros**: Most powerful, best code understanding
**Cons**: Requires API key ($)

```bash
# Get API key from: https://console.anthropic.com/
pharo ChatPharo.image clap chatpharo config set agent claude
pharo ChatPharo.image clap chatpharo config set api-key sk-ant-api03-xxx...
pharo ChatPharo.image clap chatpharo config set model claude-opus-4-20250514
```

### Option B: Ollama (Free, Local)

**Pros**: Free, private, no API key needed
**Cons**: Requires local installation, less powerful

```bash
# Install Ollama
brew install ollama  # macOS
# or: curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull mistral

# Configure ChatPharo
pharo ChatPharo.image clap chatpharo config set agent ollama
pharo ChatPharo.image clap chatpharo config set model mistral:latest
```

### Option C: Gemini (Google)

**Pros**: Good performance, competitive pricing
**Cons**: Requires API key

```bash
# Get API key from: https://makersuite.google.com/app/apikey
pharo ChatPharo.image clap chatpharo config set agent gemini
pharo ChatPharo.image clap chatpharo config set api-key YOUR_GEMINI_KEY
pharo ChatPharo.image clap chatpharo config set model gemini-pro
```

---

## Step 3: Test Your Setup

```bash
# Test connection
pharo ChatPharo.image clap chatpharo config test

# Expected output:
# Testing connection to Claude (Anthropic)...
# ✅ Connection successful!
#    Agent: Claude (Anthropic)
#    Model: claude-opus-4-20250514
```

---

## Step 4: Ask Your First Question

```bash
pharo ChatPharo.image clap chatpharo ask "What is Pharo Smalltalk?"
```

**Expected output:**
```
🤖 Asking Claude (Anthropic)...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pharo is a modern, open-source implementation of Smalltalk...
[full response]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Step 5: Try Interactive Mode

```bash
pharo ChatPharo.image clap chatpharo chat
```

**You'll see:**
```
╔════════════════════════════════════════════════════════╗
║         ChatPharo Terminal Interface v1.0              ║
╚════════════════════════════════════════════════════════╝

🤖 Agent: Claude (Anthropic)
📦 Model: claude-opus-4-20250514

💡 Type /help for available commands
💡 Type /exit to quit

💬 You: _
```

**Try these commands:**
```
💬 You: How do I create a class in Pharo?
💬 You: /attach src/MyClass.st
💬 You: Can you review this class?
💬 You: /help
💬 You: /exit
```

---

## Common Commands Cheat Sheet

### Ask Questions

```bash
# Simple question
pharo ChatPharo.image clap chatpharo ask "Your question here"

# With file
pharo ChatPharo.image clap chatpharo ask "Explain this code" --file src/MyClass.st

# Multiple files
pharo ChatPharo.image clap chatpharo ask "How do these work together?" \
  --file src/Model.st \
  --file src/View.st
```

### Configuration

```bash
# View settings
pharo ChatPharo.image clap chatpharo config list settings

# Change agent
pharo ChatPharo.image clap chatpharo config set agent ollama

# Change model
pharo ChatPharo.image clap chatpharo config set model mistral:latest

# Test connection
pharo ChatPharo.image clap chatpharo config test
```

### Interactive Chat

```bash
# Start chat
pharo ChatPharo.image clap chatpharo chat

# In-chat commands:
/help           # Show help
/attach <file>  # Attach file
/export <file>  # Save conversation
/clear          # Clear history
/exit           # Quit
```

---

## Creating Shortcuts (Optional)

### Bash Alias

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
alias cpharo='pharo /path/to/ChatPharo.image clap chatpharo'
```

Then use:
```bash
cpharo ask "What is polymorphism?"
cpharo chat
cpharo config list agents
```

### Shell Script

Create `/usr/local/bin/chatpharo`:

```bash
#!/bin/bash
exec pharo /path/to/ChatPharo.image clap chatpharo "$@"
```

```bash
chmod +x /usr/local/bin/chatpharo
```

Then use:
```bash
chatpharo ask "Your question"
chatpharo chat
```

---

## Next Steps

### 📖 Read Full Documentation
See [CLI-README.md](./CLI-README.md) for comprehensive documentation.

### 💡 Try Examples
See [CLI-EXAMPLES.md](./CLI-EXAMPLES.md) for real-world usage examples.

### 🔧 Advanced Configuration
Explore system prompts, multi-file analysis, and conversation export.

### 🤖 Try Different Agents
Experiment with Claude, Gemini, Ollama, and local models.

---

## Troubleshooting

### "Command not found: clap"

Clap might not be loaded. Load it:
```smalltalk
Metacello new
    baseline: 'Clap';
    repository: 'github://pharo-contributions/clap-st:master/src';
    load.
```

### "Agent not configured"

Set up your agent:
```bash
pharo ChatPharo.image clap chatpharo config set agent claude
pharo ChatPharo.image clap chatpharo config set api-key YOUR_KEY
```

### "Connection failed"

1. Check your API key
2. Test internet connection
3. Try `pharo ChatPharo.image clap chatpharo config test`
4. Consider using Ollama (local, no network needed)

### Ollama not responding

```bash
# Check if Ollama is running
ollama list

# Start Ollama
ollama serve

# Pull a model
ollama pull mistral
```

---

## Support

- **GitHub Issues**: [Report bugs](https://github.com/omarabedelkader/ChatPharo/issues)
- **Documentation**: [Full CLI docs](./CLI-README.md)
- **Pharo Community**: [Discord](https://discord.gg/QewZMZa)

---

**You're ready to go! 🚀**

Start exploring AI-powered development from your terminal with ChatPharo CLI.
