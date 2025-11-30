{
"title" : "ChatPharo Documentation",
"layout": "index",
"publishDate": "2025-09-30"
}

# ChatPharo: Complete Technical Documentation

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Core Components](#core-components)
4. [Agent System](#agent-system)
5. [Tool System & Function Calling](#tool-system--function-calling)
6. [User Interface Layer](#user-interface-layer)
7. [History & Conversation Management](#history--conversation-management)
8. [System Browser Integration](#system-browser-integration)
9. [Settings & Configuration](#settings--configuration)
10. [Installation & Setup](#installation--setup)
11. [Usage Guide](#usage-guide)
12. [Extension Points](#extension-points)
13. [Troubleshooting](#troubleshooting)

---

## Executive Summary

**ChatPharo** is an AI-powered coding assistant integrated directly into the Pharo Smalltalk development environment. It enables developers to interact with Large Language Models (LLMs) through a native interface, leveraging function calling to query and manipulate the live Pharo image.

### Key Features

- **Multi-Backend Support**: Compatible with Ollama (local), Google Gemini, and Mistral AI
- **Function Calling**: LLMs can query packages, classes, methods, and execute code snippets
- **System Browser Integration**: Chat tabs embedded within the browser for contextual assistance
- **Persistent Settings**: Configuration saved between sessions
- **Tool Safety**: Configurable tool execution with iteration limits
- **Logging & Monitoring**: Comprehensive activity logging for debugging and analysis

### Technology Stack

- **Language**: Pharo Smalltalk (13 & 14 compatible)
- **UI Framework**: Spec2 (Pharo's native UI framework)
- **LLM Integration**: REST APIs via ZnClient
- **Persistence**: STON (Smalltalk Object Notation)

---

## Architecture Overview

ChatPharo follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                    User Interface Layer                 │
│  (Spec Presenters: ChatPharoPresenter, Settings, etc.)  │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                   Application Layer                     │
│    (ChatPharo, ChatPharoChat, ChatPharoMessage)         │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                    Agent Layer                          │
│  (ChatPharoAgent, OllamaAgent, GeminiAgent, etc.)       │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                    Tool Layer                           │
│   (ChatPharoTool, ChatPharoClient, BrowserEnvironment)  │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                 History & Persistence                   │
│     (ChatPharoHistory, ChatPharoSettings, Logger)       │
└─────────────────────────────────────────────────────────┘
```

### Package Structure

| Package | Purpose |
|---------|---------|
| **AI-ChatPharo** | Core domain models (ChatPharo, ChatPharoChat, ChatPharoMessage, ChatPharoSettings) |
| **AI-ChatPharo-Agent** | Backend agent implementations (Ollama, Gemini, Mistral, Null) |
| **AI-ChatPharo-Spec** | Spec2 UI presenters and layouts |
| **AI-ChatPharo-Tools** | Function calling infrastructure and Pharo environment tools |
| **AI-ChatPharo-History** | Conversation history management and serialization |
| **AI-ChatPharo-Env** | System Browser integration (menu commands, tab extensions) |
| **AI-ChatPharo-Safety** | Safety advisors and user confirmation dialogs |
| **BaselineOfAIChatPharo** | Metacello baseline for project loading |

---

## Core Components

### 1. ChatPharo (Application Root)

**Location**: `src/AI-ChatPharo/ChatPharo.class.st`

**Responsibilities**:
- Maintains global settings (`ChatPharoSettings`)
- Manages multiple chat sessions (`chats` collection)
- Spawns new chat instances
- Provides class-side convenience methods for quick actions

**Key Methods**:
```smalltalk
ChatPharo >> newChat
    "Creates a new chat session with a copy of the configured agent"
    
ChatPharo class >> ask: text
    "Quick action to ask a question in a new temporary chat"
    
ChatPharo class >> askAboutMethod: aMethod
    "Context-aware question about a specific method"
```

**Example Usage**:
```smalltalk
ChatPharo new presenter open.
ChatPharo ask: 'How do I create a new class?'.
```

---

### 2. ChatPharoChat (Conversation Session)

**Location**: `src/AI-ChatPharo/ChatPharoChat.class.st`

**Responsibilities**:
- Manages a single conversation's messages
- Maintains parallel UI (`ChatPharoMessage`) and LLM-friendly (`ChatPharoHistory`) representations
- Handles asynchronous prompting via forked processes
- Implements caching to avoid redundant API calls
- Notifies UI when assistant responses arrive

**Key Attributes**:
```smalltalk
messages        "OrderedCollection of ChatPharoMessage (UI models)"
agent           "The backend agent (Ollama, Gemini, etc.)"
history         "ChatPharoHistory (LLM message format)"
promptProcess   "Forked process handling current prompt"
cache           "Dictionary mapping prompts to cached responses"
```

**Key Methods**:
```smalltalk
ChatPharoChat >> sendMessage: aText
    "Adds user message, forks background process to query agent"
    
ChatPharoChat >> addAssistantMessage: answerText
    "Records assistant response in both UI and history"
    
ChatPharoChat >> clearChat
    "Resets conversation and cache"
```

**Process Flow**:
1. User submits message via UI
2. `sendMessage:` checks cache; if miss, forks background process
3. Background process calls `agent getResponseForPrompt:`
4. Agent may trigger tool calls (function execution)
5. Response stored in cache and history
6. UI notified via `onAnswerReceived` callback

---

### 3. ChatPharoMessage (UI Model)

**Location**: `src/AI-ChatPharo/ChatPharoMessage.class.st`

**Responsibilities**:
- Represents a single user-assistant exchange for UI rendering
- Stores user `content` and assistant `answer`
- Creates its own Microdown presenter on demand
- Tracks user feedback (good/bad buttons)

**Key Attributes**:
```smalltalk
content         "User's question/prompt"
answer          "Assistant's response"
assistantLabel  "Display label (e.g., 'Assistant', 'ChatPharo')"
feedback        "Boolean or nil (thumbs up/down)"
presenter       "Lazy-initialized ChatPharoMessagePresenter"
```

---

### 4. ChatPharoSettings (Configuration)

**Location**: `src/AI-ChatPharo/ChatPharoSettings.class.st`

**Responsibilities**:
- Persists user configuration to `chatpharo/chatpharo-settings.ston`
- Manages active agent selection
- Stores feature toggles (browser extension, logging, caching, etc.)
- Handles maximum tool execution iterations

**Key Attributes**:
```smalltalk
agent                      "Active ChatPharoAgent instance"
browserExtensionEnabled    "Enable System Browser tabs"
browserToolsEnabled        "Collection of enabled tool names"
maximumIterations          "Max tool call loops (default: 3)"
cacheEnabled               "Enable response caching"
loggingEnabled             "Enable activity logging"
feedbackButtonsEnabled     "Show thumbs up/down buttons"
welcomeMessageEnabled      "Show welcome message on new chats"
```

**Persistence**:
```smalltalk
ChatPharoSettings class >> loadOrNew
    "Loads from file or creates default settings"
    
ChatPharoSettings class >> saveDefault
    "Serializes current settings to disk"
```

---

## Agent System

### Abstract Base: ChatPharoAgent

**Location**: `src/AI-ChatPharo-Agent/ChatPharoAgent.class.st`

**Contract**:
- **Class-side queries**: `displayName`, `isReachable`, `modelNames`, `settingsPresenterFor:`
- **Instance-side service**: `getResponseForPrompt:` (must be overridden)
- **State management**: `model`, `systemPrompt`, `history`, `promptPrefix`, `response`

**Key Methods**:
```smalltalk
ChatPharoAgent class >> displayName
    "Human-readable name (e.g., 'Ollama', 'Gemini')"
    
ChatPharoAgent class >> isReachable
    "Connectivity check (e.g., ping local server)"
    
ChatPharoAgent >> getResponseForPrompt: prompt
    "Send prompt to LLM, return text response"
    
ChatPharoAgent >> copyForChat
    "Create fresh instance with empty history for new chat"
```

---

### Concrete Implementations

#### 1. ChatPharoOllamaAgent (Local Models)

**Location**: `src/AI-ChatPharo-Agent/ChatPharoOllamaAgent.class.st`

**Configuration**:
- **Host**: `localhost` (default)
- **Port**: `11434` (default)
- **Models**: Dynamically fetched via `/api/tags`

**Features**:
- Model management (pull, delete)
- Temperature control
- Streaming support (future)

**Example**:
```smalltalk
agent := ChatPharoOllamaAgent new
    model: 'codellama:7b';
    temperature: 0.3;
    yourself.
```

#### 2. ChatPharoGeminiAgent (Google Cloud)

**Location**: `src/AI-ChatPharo-Agent/ChatPharoGeminiAgent.class.st`

**Configuration**:
- **Host**: `generativelanguage.googleapis.com`
- **API Key**: User-provided
- **Models**: `gemini-2.0-flash`, etc.

**Example**:
```smalltalk
agent := ChatPharoGeminiAgent new
    apiKey: 'YOUR_API_KEY';
    model: 'models/gemini-2.0-flash';
    yourself.
```

#### 3. ChatPharoMistralAgent (Mistral AI)

**Location**: `src/AI-ChatPharo-Agent/ChatPharoMistralAgent.class.st`

**Status**: Experimental (not fully supported)

**Configuration**:
- **Host**: `api.mistral.ai`
- **API Key**: User-provided

#### 4. ChatPharoNullAgent (Placeholder)

**Location**: `src/AI-ChatPharo-Agent/ChatPharoNullAgent.class.st`

**Purpose**: Default agent when no backend is configured; returns static message prompting user to configure API.

---

### Agent Lifecycle

1. **Selection**: User chooses agent type in Settings → Configuration
2. **Instantiation**: `ChatPharoSettings >> useApi:` creates new agent instance
3. **Configuration**: User provides credentials (API keys, model selection)
4. **Validation**: `testConnection` verifies connectivity
5. **Usage**: Agent copied per chat session via `copyForChat`
6. **Execution**: `getResponseForPrompt:` orchestrates LLM interaction

---

## Tool System & Function Calling

### Architecture

ChatPharo implements **OpenAI-compatible function calling** to enable LLMs to query and manipulate the Pharo environment.

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Agent      │────────▶│ ChatPharoTool│────────▶│   LLM API    │
│              │         │              │         │              │
└──────┬───────┘         └──────┬───────┘         └──────┬───────┘
       │                        │                        │
       │                        │                        │
       ▼                        ▼                        ▼
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│ChatPharoClient│◀────── │  Response    │◀────────│ Tool Calls   │
│(Function Def)│         │  (JSON)      │         │   (JSON)     │
└──────────────┘         └──────────────┘         └──────────────┘
```

### Components

#### 1. ChatPharoTool (REST Client)

**Location**: `src/AI-ChatPharo-Tools/ChatPharoTool.class.st`

**Responsibilities**:
- Unified OpenAI-style REST client for all backends
- Constructs `/chat/completions` requests with `tools` array
- Parses `tool_calls` from LLM responses
- Executes tool functions locally
- Handles multi-turn tool execution loops

**Key Methods**:
```smalltalk
ChatPharoTool class >> geminiWithAPIKey:system:tools:
    "Factory for Gemini backend"
    
ChatPharoTool >> getResponseForHistory:
    "POST /chat/completions, return ChatPharoHistorySaver"
    
ChatPharoTool >> applyToolFunction:arguments:
    "Execute tool by name with JSON arguments"
```

**Request Structure**:
```json
{
  "model": "codellama:7b",
  "messages": [
    {"role": "system", "content": "You are an AI assistant..."},
    {"role": "user", "content": "List packages in the image"}
  ],
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "get_packages",
        "description": "Gets all of the packages.",
        "parameters": {...}
      }
    }
  ],
  "tool_choice": "auto"
}
```

---

#### 2. ChatPharoClient (Function Definition)

**Location**: `src/AI-ChatPharo-Tools/ChatPharoClient.class.st`

**Responsibilities**:
- Encapsulates a single tool/function
- Stores name, description, JSON schema for parameters
- Holds executable Smalltalk block

**Example Definition**:
```smalltalk
ChatPharoClient
    name: 'get_packages'
    description: 'Gets all of the packages.'
    parameters: (Dictionary
        with: 'type' -> 'object'
        with: 'properties' -> Dictionary new
        with: 'required' -> #())
    block: [:arguments |
        Dictionary
            with: 'packages'
            -> (RBBrowserEnvironment default packages
                collect: [:pkg | pkg name]) sorted
    ]
```

---

#### 3. ChatPharoBrowserEnvironment (Pharo Tools)

**Location**: `src/AI-ChatPharo-Tools/ChatPharoBrowserEnvironment.class.st`

**Responsibilities**:
- Wraps Refactoring Browser environment
- Exports read-only introspection tools
- Prevents destructive operations (no class creation/deletion)

**Available Tools**:

| Tool Name | Description | Example |
|-----------|-------------|---------|
| `get_packages` | Lists all packages | `→ ["AI-ChatPharo", "Kernel", ...]` |
| `get_classes_in_packages` | Lists classes per package | `→ {"AI-ChatPharo": ["ChatPharo", ...]}` |
| `get_class_definitions` | Class structure (superclass, ivars, etc.) | `→ {"ChatPharo": {"superclass": "Object", ...}}` |
| `get_class_comments` | Class documentation | `→ {"ChatPharo": "The application root..."}` |
| `get_class_methods` | Method source or selectors | `→ {"ChatPharo": {"instance": {...}}}` |
| `get_class_subclasses` | Subclass hierarchy | `→ {"ChatPharoAgent": ["OllamaAgent", ...]}` |
| `find_methods_with_substring` | Code search | `→ [{"class": "ChatPharo", "selector": "newChat"}]` |
| `describe_package` | Complete package overview | `→ {"summary_per_class": {...}}` |
| `check_syntax` | Validate Smalltalk code | `→ {"syntax_ok": true}` |
| `open_playground` | Open code in Playground | `→ {"playground_opened": true}` |

**Implementation Pattern**:
```smalltalk
functionGetPackages
    ^ ChatPharoClient
        name: 'get_packages'
        description: 'Gets all of the packages.'
        parameters: (Dictionary with: 'type' -> 'object' ...)
        block: [:arguments | self applyFunctionGetPackages: arguments]
```

---

### Tool Execution Flow

1. **Agent sends prompt** with available tools to LLM
2. **LLM responds** with `tool_calls` array:
   ```json
   {
     "tool_calls": [
       {
         "id": "call_123",
         "type": "function",
         "function": {
           "name": "get_classes_in_packages",
           "arguments": "{\"packages\": [\"AI-ChatPharo\"]}"
         }
       }
     ]
   }
   ```
3. **ChatPharoTool executes** each tool locally via `applyToolFunction:arguments:`
4. **Results appended** to conversation as `tool` role messages
5. **Loop continues** until LLM stops calling tools or iteration limit reached

---

### Safety Features

#### Iteration Limiting

Prevents infinite tool call loops:

```smalltalk
ChatPharoGeminiAgent >> getResponseForPrompt: userPrompt
    | result max count |
    max := ChatPharoSettings default maximumIterations ifNil: [1].
    count := 0.
    [result toolCalls notNil and: [count < max]] whileTrue: [
        result := api getResponseForHistory: self history.
        count := count + 1
    ].
    ^ result content
```

#### User Confirmation

For potentially disruptive actions:

```smalltalk
ChatPharoSafetyAdvisor class >> confirmToolDisableOn: aPresenter
    ^ aPresenter confirm: 'For optimal performance we recommend keeping all tools enabled.\nAre you sure you want to disable this tool?'
```

---

## User Interface Layer

### Architecture

ChatPharo uses **Spec2** (Pharo's native UI framework) with a **Model-View-Presenter** pattern:

```
Model (Domain)         Presenter (UI Logic)         View (Morphic)
──────────────         ────────────────────         ──────────────
ChatPharo          ─▶  ChatPharoPresenter      ─▶   Window + Toolbar
ChatPharoChat      ─▶  ChatPharoChatPresenter  ─▶   Message List + Input
ChatPharoMessage   ─▶  ChatPharoMessagePresenter ─▶ Microdown Renderer
ChatPharoSettings  ─▶  ChatPharoSettingsPresenter ─▶ Tabbed Settings
```

### Main Window: ChatPharoPresenter

**Location**: `src/AI-ChatPharo-Spec/ChatPharoPresenter.class.st`

**Layout**:
```
┌────────────────────────────────────────────────────────┐
│  [New Chat] [Delete] [Delete All] [Save] [Settings]    │ ← Toolbar
├────────────────────────────────────────────────────────┤
│  ┌──────┬──────┬──────┐                                │
│  │Chat 1│Chat 2│Chat 3│                                │ ← Notebook Tabs
│  └──────┴──────┴──────┘                                │
│  ┌────────────────────────────────────────────────┐    │
│  │  User: How do I create a class?                │    │
│  │  Assistant: To create a class in Pharo...      │    │
│  │  ────────────────────────────────────────────  │    │ ← Chat Messages
│  │  User: Show me an example                      │    │
│  │  Assistant: ```smalltalk...                    │    │
│  └────────────────────────────────────────────────┘    │
│  ┌────────────────────────────────────────────────┐    │
│  │ Type your message here...         [Submit]     │    │ ← Input Field
│  └────────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────┘
```

**Key Features**:
- **Multi-chat tabs**: Create/delete independent conversations
- **Connection status**: Real-time backend reachability indicator
- **Export**: Save conversations as JSON

---

### Chat Tab: ChatPharoChatPresenter

**Location**: `src/AI-ChatPharo-Spec/ChatPharoChatPresenter.class.st`

**Responsibilities**:
- Renders message list with Microdown formatting
- Handles user input submission
- Updates UI when assistant responses arrive
- Provides cancel button for long-running prompts

**Message Rendering**:
- Uses `MicrodownPresenter` for rich text (code blocks, headers, lists)
- Copy-to-clipboard button (appears on hover)
- Optional feedback buttons (thumbs up/down)

---

### Settings Dialog: ChatPharoSettingsPresenter

**Location**: `src/AI-ChatPharo-Spec/ChatPharoSettingsPresenter.class.st`

**Tabs**:

1. **Chat**: System prompt, max iterations, tool toggles, feature flags
2. **History**: View raw conversation history
3. **Configuration**: Agent selection, credentials, model choice
4. **Extensions** (conditional): Browser integration settings, tool selection

**Dynamic UI**:
- Agent-specific settings panels loaded on demand
- Tool checkboxes generated from `ChatPharoBrowserEnvironment`
- Test connection button per agent

---

### Agent Settings Presenters

Each agent provides a custom settings panel:

| Agent | Presenter | Configuration |
|-------|-----------|---------------|
| Ollama | `ChatPharoOllamaSettingsPresenter` | Host, port, model dropdown, temperature, model management |
| Gemini | `ChatPharoGeminiSettingsPresenter` | Host, API key (masked), model dropdown, temperature |
| Mistral | `ChatPharoMistralSettingsPresenter` | Host, API key, model dropdown |
| Null | `ChatPharoNullSettingsPresenter` | Info label prompting configuration |

---

## History & Conversation Management

### ChatPharoHistory (LLM Format)

**Location**: `src/AI-ChatPharo-History/ChatPharoHistory.class.st`

**Purpose**: Maintains conversation in OpenAI-compatible message format for API requests.

**Structure**:
```smalltalk
messages: OrderedCollection of ChatPharoHistoryMessage
```

**Methods**:
```smalltalk
addUser: text
    "Append user message"
    
addAssistant: text
    "Append assistant message"
    
asPromptPrefix
    "Serialize as plain text for debugging"
    
chatMessagesOn: aStream
    "Write JSON message array to stream"
```

---

### ChatPharoHistoryMessage (Message Model)

**Location**: `src/AI-ChatPharo-History/ChatPharoHistoryMessage.class.st`

**Attributes**:
```smalltalk
role        "system | user | assistant | tool"
content     "Message text"
toolCalls   "Array of ChatPharoHistorySaverToolCall (optional)"
```

**Serialization**:
```smalltalk
chatMessagesOn: aStream
    | msg |
    msg := Dictionary with: 'role' -> role.
    content ifNotNil: [msg add: 'content' -> content].
    toolCalls ifNotNil: [
        msg add: 'tool_calls' -> (toolCalls collect: [:tc |
            tc openAIChatToolCall]) as: Array].
    aStream nextPut: msg.
```

---

### ChatPharoHistorySaverToolCall (Tool Record)

**Location**: `src/AI-ChatPharo-History/ChatPharoHistorySaverToolCall.class.st`

**Attributes**:
```smalltalk
id             "Unique call identifier from LLM"
functionName   "Tool name (e.g., 'get_packages')"
arguments      "JSON string of parameters"
content        "Tool execution result (JSON)"
```

**Purpose**: Records tool calls for multi-turn conversations, allowing LLM to see previous tool results.

---

## System Browser Integration

ChatPharo extends Calypso (Pharo's System Browser) with contextual AI assistance.

### Browser Tab Extension

**Class**: `ChatPharoPackageBrowser`  
**Location**: `src/AI-ChatPharo-Env/ChatPharoPackageBrowser.class.st`

**Activation**:
```smalltalk
ChatPharoPackageBrowser class >> shouldBeActivatedInContext: aBrowserContext
    ^ ChatPharoSettings default browserExtensionEnabled
```

**Features**:
- Tab appears when browsing packages
- Agent automatically scoped to selected package via `packageName:` injection
- System prompt modified to reference current package

**Hierarchy**:
```
ChatPharoPackageBrowser         (package-level)
    ↓
ChatPharoClassBrowser           (class-level)
    ↓
ChatPharoMethodBrowser          (method-level)
```

Each subclass narrows the agent's focus by setting `className:` or `methodName:`.

---

### Context Menu Commands

#### 1. "Ask ChatPharo" Command

**Class**: `ChatPharoAskCommand`  
**Activation**: Right-click on method → "Ask ChatPharo"  
**Shortcut**: `Cmd+P`

**Behavior**:
```smalltalk
ChatPharoAskCommand >> execute
    | method |
    method := element browserItem actualObject.
    ChatPharo askAboutMethod: method
```

Generates prompt:
```
Explain what the following Smalltalk method does and highlight any potential improvements or edge cases.

Class: ChatPharo
Selector: newChat

```smalltalk
newChat
    | agentCopy |
    agentCopy := self settings agent copyForChat.
    chats add: (ChatPharoChat new agent: agentCopy; yourself).
```
```

#### 2. "Code ChatPharo" Command

**Class**: `ChatPharoCodeCommand`  
**Activation**: Right-click on method → "Code ChatPharo"  
**Shortcut**: `Cmd+Shift+K`

**Behavior**: Similar to Ask but prompts LLM to suggest code improvements.

---

### Editor Context Menu

**Class**: `ChatPharoCodeMenu`  
**Integration**: Extends `RubSmalltalkCodeMode` (Pharo's text editor)

**Menu Items**:
- **Ask ChatPharo**: Selected text → explanation prompt
- **Code ChatPharo**: Selected text → code improvement prompt

**Implementation**:
```smalltalk
ChatPharoCodeMenu class >> menuOn: aBuilder
    <contextMenu>
    <RubSmalltalkCodeMenu>
    settings askFeatureEnabled ifTrue: [
        (aBuilder item: #'Ask ChatPharo' translated)
            selector: #openChatCharo;
            icon: ChatPharoIcons chatPharoIcon
    ].
```

---

## Settings & Configuration

### File Structure

**Location**: `<image-directory>/chatpharo/chatpharo-settings.ston`

**Legacy Location**: `<image-directory>/chatpharo-settings.ston` (migrated automatically)

**Format**: STON (Smalltalk Object Notation)

**Example**:
```ston
ChatPharoSettings {
    #agent : ChatPharoOllamaAgent {
        #model : 'codellama:7b',
        #host : 'localhost',
        #port : '11434',
        #temperature : 0.3,
        #systemPrompt : 'You are an AI coding assistant...'
    },
    #browserExtensionEnabled : true,
    #browserToolsEnabled : ['get_packages', 'get_classes_in_packages', ...],
    #maximumIterations : 3,
    #cacheEnabled : true,
    #loggingEnabled : true,
    #feedbackButtonsEnabled : true,
    #welcomeMessageEnabled : true,
    #askFeatureEnabled : true,
    #codeFeatureEnabled : true
}
```

---

### Loading & Saving

```smalltalk
"Load settings on image startup"
settings := ChatPharoSettings loadOrNew.

"Modify settings"
settings agent: ChatPharoGeminiAgent new.
settings maximumIterations: 5.

"Persist to disk"
ChatPharoSettings saveDefault.
```

---

### Feature Flags

| Flag | Description | Default |
|------|-------------|---------|
| `browserExtensionEnabled` | Show chat tabs in System Browser | `false` |
| `browserAutoTabEnabled` | Auto-open browser tab on selection | `true` |
| `cacheEnabled` | Cache LLM responses to avoid re-querying | `true` |
| `loggingEnabled` | Write activity to `chatpharo/log-chatpharo.txt` | `true` |
| `feedbackButtonsEnabled` | Show thumbs up/down on messages | `true` |
| `welcomeMessageEnabled` | Display welcome message on new chats | `true` |
| `askFeatureEnabled` | Enable "Ask ChatPharo" in editors | `true` |
| `codeFeatureEnabled` | Enable "Code ChatPharo" in editors | `true` |

---

## Installation & Setup

### Prerequisites

- **Pharo 13 or 14** ([download](https://pharo.org/download))
- **Git** (for cloning repository)
- **Ollama** (optional, for local models): [ollama.com](https://ollama.com)

---

### Installation via Metacello

#### Stable Release

```smalltalk
Metacello new
  githubUser: 'omarabedelkader'
  project: 'ChatPharo'
  commitish: 'v0.1.0'
  path: 'src';
  baseline: 'AIChatPharo';
  load.
```

#### Development Version

```smalltalk
Metacello new
  githubUser: 'omarabedelkader'
  project: 'ChatPharo'
  commitish: 'main'
  path: 'src';
  baseline: 'AIChatPharo';
  load.
```

---

### Initial Configuration

1. **Open Settings**:
   ```smalltalk
   ChatPharoSettings default presenter open.
   ```

2. **Select Agent** (Configuration tab):
   - Dropdown: Choose "Ollama", "Gemini", or "Mistral AI"

3. **Configure Credentials**:
   - **Ollama**: Verify host/port, select model
   - **Gemini**: Enter API key, select model
   - **Mistral**: Enter API key, select model

4. **Test Connection**: Click "Test Connection" button

5. **Adjust Features** (Chat tab):
   - Enable/disable browser extension
   - Configure tool permissions
   - Set maximum iterations

6. **Save**: Settings auto-save on modification

---

### Ollama Setup (Local Models)

1. **Install Ollama**: [ollama.com/download](https://ollama.com/download)

2. **Pull Model**:
   ```bash
   ollama pull codellama:7b
   ```

3. **Verify Service**:
   ```bash
   curl http://localhost:11434/api/tags
   ```

4. **Configure in ChatPharo**:
   - Settings → Configuration → Agent: "Ollama"
   - Model dropdown: Select "codellama:7b"
   - Test Connection

---

## Usage Guide

### Quick Start

```smalltalk
"1. Open temporary chat"
ChatPharo new presenter open.

"2. Ask a question"
ChatPharo ask: 'How do I create a Set in Pharo?'.

"3. Query about a method"
method := ChatPharoChat >> #sendMessage:.
ChatPharo askAboutMethod: method.
```

---

### Chat Window Usage

1. **Create New Chat**: Toolbar → "New Chat"
2. **Type Message**: Enter prompt in input field
3. **Submit**: Press Enter or click "Submit"
4. **Wait for Response**: Status shows "Running..."
5. **View Answer**: Rendered with Microdown formatting
6. **Copy Answer**: Hover over response → click copy icon
7. **Delete Chat**: Select tab → Toolbar → "Delete Chat"

---

### System Browser Integration

1. **Enable Extension**:
   ```smalltalk
   ChatPharoSettings default browserExtensionEnabled: true.
   ```

2. **Browse Package**: Open System Browser → Select package
3. **See Chat Tab**: New tab labeled with package name
4. **Ask Question**: Type prompt relevant to package
5. **LLM Has Context**: Agent automatically queries package classes/methods

---

### Context Menu Actions

#### In Method Browser

1. Select method → Right-click
2. Choose:
   - **"Ask ChatPharo"** (`Cmd+P`): Explain method
   - **"Code ChatPharo"** (`Cmd+Shift+K`): Suggest improvements

#### In Code Editor

1. Highlight code snippet
2. Right-click → Choose:
   - **"Ask ChatPharo"**: Explain selection
   - **"Code ChatPharo"**: Improve selection

---

### Advanced: Function Calling

LLMs can query the image:

**User**: "List all classes in the AI-ChatPharo package"

**LLM** (internal):
```json
{
  "tool_calls": [{
    "function": {
      "name": "get_classes_in_packages",
      "arguments": "{\"packages\": [\"AI-ChatPharo\"]}"
    }
  }]
}
```

**Tool Execution**:
```json
{
  "classes_per_package": {
    "AI-ChatPharo": [
      "ChatPharo",
      "ChatPharoChat",
      "ChatPharoMessage",
      "ChatPharoSettings",
      "ChatPharoLogger"
    ]
  }
}
```

**LLM** (to user): "The AI-ChatPharo package contains 5 classes: ChatPharo, ChatPharoChat, ChatPharoMessage, ChatPharoSettings, and ChatPharoLogger."

---

## Extension Points

### Creating a Custom Agent

```smalltalk
Object subclass: #MyCustomAgent
    superclass: ChatPharoAgent
    instanceVariableNames: 'endpoint apiToken'
    classVariableNames: ''
    package: 'MyExtension'

"Implement required methods"
MyCustomAgent class >> displayName
    ^ 'My Custom LLM'

MyCustomAgent class >> isReachable
    ^ [ZnClient new get: self defaultEndpoint. true]
        on: Error do: [false]

MyCustomAgent class >> modelNames
    ^ #('my-model-v1' 'my-model-v2')

MyCustomAgent >> getResponseForPrompt: prompt
    | response |
    response := ZnClient new
        url: endpoint, '/chat';
        headerAt: 'Authorization' put: 'Bearer ', apiToken;
        entity: (ZnEntity json: (self buildRequestFor: prompt));
        post;
        contents.
    ^ (STONJSON fromString: response) at: 'text'
```

**Register**:
```smalltalk
ChatPharoSettings >> availableApis
    ^ super availableApis, {MyCustomAgent}
```

---

### Creating a Custom Tool

```smalltalk
ChatPharoClient
    name: 'search_web'
    description: 'Searches the web and returns top 5 results.'
    parameters: (Dictionary
        with: 'type' -> 'object'
        with: 'properties' -> (Dictionary
            with: 'query' -> (Dictionary
                with: 'type' -> 'string'
                with: 'description' -> 'Search query'))
        with: 'required' -> #('query'))
    block: [:arguments |
        | query results |
        query := arguments at: 'query'.
        results := MyWebSearchEngine search: query limit: 5.
        Dictionary
            with: 'results' -> (results collect: [:r |
                Dictionary
                    with: 'title' -> r title
                    with: 'url' -> r url
                    with: 'snippet' -> r snippet])
    ]
```

**Register**:
```smalltalk
ChatPharoBrowserEnvironment >> initializeWithEnvironment: env
    tools := {
        self functionGetPackages.
        "... existing tools ..."
        self functionSearchWeb.  "<-- Add here"
    }
```

---

### Adding a Settings Page

```smalltalk
ChatPharoSettingsPresenter >> newMyCustomTab
    ^ SpPresenter new
        layout: (SpBoxLayout newTopToBottom
            add: (self newLabel label: 'My Custom Settings');
            add: myCustomCheckbox;
            yourself);
        yourself

"In initializePresenters:"
notebook addPage: (SpNotebookPage
    title: 'My Custom'
    icon: (self iconNamed: #smallConfiguration)
    provider: [self newMyCustomTab])
```

---

## Troubleshooting

### Common Issues

#### 1. "No backend is configured"

**Cause**: `ChatPharoNullAgent` is active  
**Solution**:
1. Open Settings → Configuration
2. Select agent from dropdown
3. Configure credentials
4. Test connection

---

#### 2. "Connection failed" (Ollama)

**Checks**:
```bash
# Verify Ollama is running
ollama list

# Test API
curl http://localhost:11434/api/version

# Check port
lsof -i :11434
```

**Solutions**:
- Restart Ollama service
- Verify host/port in ChatPharo settings
- Check firewall rules

---

#### 3. "Invalid API key" (Gemini/Mistral)

**Verify**:
```bash
# Gemini
curl -H "Authorization: Bearer YOUR_KEY" \
  https://generativelanguage.googleapis.com/v1beta/models

# Mistral
curl -H "Authorization: Bearer YOUR_KEY" \
  https://api.mistral.ai/v1/models
```

**Solutions**:
- Regenerate API key from provider
- Re-enter in masked field
- Check for trailing spaces

---

#### 4. Tools not executing

**Symptoms**: LLM says "I don't have access to that information"

**Checks**:
1. Settings → Chat → Verify tool checkboxes enabled
2. Settings → Chat → Max Iterations > 0
3. Check logs: `<image-dir>/chatpharo/log-chatpharo.txt`

**Debug**:
```smalltalk
"Test tool manually"
env := ChatPharoBrowserEnvironment new.
tool := env functionGetPackages.
result := tool applyTo: Dictionary new.
result inspect.
```

---

#### 5. Slow responses

**Optimizations**:
1. Enable caching: `Settings → Chat → Enable cache`
2. Use local models (Ollama) for faster inference
3. Reduce context: Shorter system prompts
4. Limit tools: Disable unused tools in browser extension

---

#### 6. Memory issues

**Symptoms**: Image freezes, high CPU usage

**Solutions**:
1. Limit max iterations: `Settings → Chat → Max iterations = 1`
2. Disable caching if memory constrained
3. Use smaller models (e.g., `codellama:7b` vs `codellama:34b`)
4. Close unused chat tabs

---

### Logging

**Location**: `<image-directory>/chatpharo/log-chatpharo.txt`

**Sample Entry**:
```
[2025-01-15 14:23:45] [FRONTEND] Chat tab send triggered
  Details:
    chatId: 12345678
    text: How do I create a class?
    agent: Ollama

[2025-01-15 14:23:47] [BACKEND] Assistant response recorded
  Details:
    chatId: 12345678
    agent: Ollama
    assistantLabel: Assistant
    response: To create a class in Pharo...
```

**Enable/Disable**:
```smalltalk
ChatPharoSettings default loggingEnabled: true.
ChatPharoLogger deleteLogFile.  "Clear log"
```

---

### Reset Settings

```smalltalk
ChatPharoSettings resetDefault.  "Delete settings file"
ChatPharoSettings default presenter open.  "Reconfigure"
```

---

## Appendix

### Class Reference

| Class | Package | Responsibility |
|-------|---------|----------------|
| `ChatPharo` | AI-ChatPharo | Application root, manages global state |
| `ChatPharoChat` | AI-ChatPharo | Single conversation session |
| `ChatPharoMessage` | AI-ChatPharo | UI model for one user-assistant exchange |
| `ChatPharoSettings` | AI-ChatPharo | Persistent configuration |
| `ChatPharoLogger` | AI-ChatPharo | Activity logging |
| `ChatPharoAgent` | AI-ChatPharo-Agent | Abstract LLM backend |
| `ChatPharoOllamaAgent` | AI-ChatPharo-Agent | Ollama integration |
| `ChatPharoGeminiAgent` | AI-ChatPharo-Agent | Google Gemini integration |
| `ChatPharoMistralAgent` | AI-ChatPharo-Agent | Mistral AI integration (experimental) |
| `ChatPharoNullAgent` | AI-ChatPharo-Agent | Placeholder agent |
| `ChatPharoPresenter` | AI-ChatPharo-Spec | Main window UI |
| `ChatPharoChatPresenter` | AI-ChatPharo-Spec | Chat tab UI |
| `ChatPharoMessagePresenter` | AI-ChatPharo-Spec | Message rendering |
| `ChatPharoSettingsPresenter` | AI-ChatPharo-Spec | Settings dialog |
| `ChatPharoTool` | AI-ChatPharo-Tools | OpenAI-style REST client |
| `ChatPharoClient` | AI-ChatPharo-Tools | Function/tool definition |
| `ChatPharoBrowserEnvironment` | AI-ChatPharo-Tools | Pharo introspection tools |
| `ChatPharoHistory` | AI-ChatPharo-History | Conversation history (LLM format) |
| `ChatPharoHistoryMessage` | AI-ChatPharo-History | Single message in history |
| `ChatPharoHistorySaver` | AI-ChatPharo-History | History builder |
| `ChatPharoHistorySaverToolCall` | AI-ChatPharo-History | Tool call record |
| `ChatPharoPackageBrowser` | AI-ChatPharo-Env | System Browser extension (package) |
| `ChatPharoClassBrowser` | AI-ChatPharo-Env | System Browser extension (class) |
| `ChatPharoMethodBrowser` | AI-ChatPharo-Env | System Browser extension (method) |
| `ChatPharoAskCommand` | AI-ChatPharo-Env | "Ask ChatPharo" menu command |
| `ChatPharoCodeCommand` | AI-ChatPharo-Env | "Code ChatPharo" menu command |
| `ChatPharoSafetyAdvisor` | AI-ChatPharo-Safety | User confirmation dialogs |

---

### Contributors

- **Omar AbedelKader** - Original author and maintainer

### License

MIT License - See `LICENSE` file

### Repository

[https://github.com/omarabedelkader/ChatPharo](https://github.com/omarabedelkader/ChatPharo)

---

### Acknowledgments

- **Pharo Community** - For the robust Smalltalk environment
- **Anthropic/OpenAI** - For pioneering function calling
- **Ollama Team** - For making local LLMs accessible

---

**Document Version**: 1.0  
**Last Updated**: September 2025  
**Compatible with**: Pharo 13, Pharo 14