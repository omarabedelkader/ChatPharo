Welcome to the ChatPharo Wiki!

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)

   1. [Prerequisites](#prerequisites)
   2. [Load with Metacello](#load-with-metacello)
   3. [Post‑install smoke test](#post-install-smoke-test)
3. [First Run & Quick Tour](#first-run--quick-tour)
4. [Architecture Deep Dive](#architecture-deep-dive)

   1. [Core Packages](#core-packages)
   2. [High‑level Class Responsibilities](#high-level-class-responsibilities)
   3. [Async Prompt Pipeline](#async-prompt-pipeline)
5. [Agents](#agents)

   1. [NullAgent (offline)](#nullagent-offline)
   2. [Ollama (local LLMs)](#ollama-local-llms)
   3. [Gemini (Google AI Studio)](#gemini-google-ai-studio)
   4. [Mistral (beta)](#mistral-beta)
   5. [Adding new agents](#adding-new-agents)
6. [Settings & Persistence](#settings--persistence)
7. [Using the UI](#using-the-ui)

   1. [Main Window](#main-window)
   2. [Temporary Chats](#temporary-chats)
   3. [System Browser Integration](#system-browser-integration)
8. [Tools / Function‑Calling](#tools--function-calling)
9. [Feature Support](#feature-support)
10. [Extending ChatPharo](#extending-chatpharo)
12. [Testing & CI](#testing--ci)
12. [Troubleshooting FAQ](#troubleshooting-faq)
13. [Contributing](#contributing)
13. [License & Credits](#license--credits)

---

## Overview

**ChatPharo** is a modular chat interface that connects Pharo to LLMs. It separates concerns into adapters, presenters, and model objects for clarity and flexibility.

**ChatPharo** embeds modern LLMs directly inside the Pharo IDE, providing an interactive chat assistant, system‑browser helpers, and function‑calling bindings to the live image. The design keeps the UI layer, agent back‑ends, and tool wrappers loosely coupled so you can swap or extend any part independently.


Key concepts in one glance:

| Concept      | Responsibility                                              | Key Classes                        |
| ------------ | ----------------------------------------------------------- | ---------------------------------- |
| *Agent*      | Talks to a concrete service (Ollama REST, Google Gemini, …) | `ChatPharoAgent` & subclasses      |
| *Chat*       | One conversation transcript                                 | `ChatPharoChat`                    |
| *History*    | OpenAI‑style message log used by agents                     | `ChatPharoHistory*`                |
| *Tool*       | Function that the LLM can call                              | `ChatPharoClient`, `ChatPharoTool` |
| *Presenters* | Spec‑based UI façade for domain objects                     | `ChatPharo*Presenter`              |


## Installation

### Prerequisites

* **Pharo 13** or newer (64‑bit).<br>
  The framework is known to work on Linux, macOS (Apple Silicon & Intel) and Windows 11.
* A working **Git** client (Iceberg) and **Metacello** (bundled with recent images).
* For cloud agents: outbound HTTPS connectivity.

### Load with Metacello <a id="load-with-metacello"></a>

```smalltalk
Metacello new
    baseline: 'AIChatPharo';
    repository: 'github://omarabedelkader/ChatPharo:main/src';
    load.
```
---

*Tip – during development you may replace `main` with a branch or commit SHA.*

#### Headless / CI images

If you run in a headless VM (e.g. CI pipeline) load only the core packages:

```smalltalk
Metacello new
    baseline: 'AIChatPharo';
    repository: 'github://omarabedelkader/ChatPharo:main/src';
    onConflictUseIncoming;
    load: #( 'AI-ChatPharo' 'AI-ChatPharo-Agent' ).
```

### Post‑install smoke test

```smalltalk
ChatPharo new presenter open.
ChatPharoSettings default presenter open.
```

---

## First Run & Quick Tour

1. **ChatPharo** ▶ **Temp ChatPharo** (opens the main window)<br>
   You start with no chats; click *New Chat* (toolbar) to spawn one.
2. **Send a message**. With the default `NullAgent` you get a reminder to configure an API.
3. **Settings dialog** (toolbar ▸ *Settings*)

   * *Configuration* tab – choose **Ollama**, **Gemini** or another agent.
   * *Chat* tab – tweak the global system prompt.
   * *Extensions* tab – enable the System‑Browser integration.
4. **System Browser integration** – when enabled, new tabs (*ChatPharo Package / Class / Method*) appear contextually, feeding the selected entity name into the assistant.

---

## Architecture Deep Dive

### Core Packages

| Package                  | Purpose                                       |
| ------------------------ | --------------------------------------------- |
| **AI‑ChatPharo**         | Domain model & main application               |
| **AI‑ChatPharo‑Agent**   | Built‑in agent implementations                |
| **AI‑ChatPharo‑Tools**   | Function‑calling environment (System Browser) |
| **AI‑ChatPharo‑History** | Message persistence helpers                   |
| **AI‑ChatPharo‑Spec**    | Spec2 UI presenters                           |
| **AI‑ChatPharo‑Env**     | IDE extensions / menus                        |
| **AI‑ChatPharo‑Tests**   | 250+ unit tests covering the model            |

Diagram of key flows:

```
ChatPharoPresenter  ─┬─> ChatPharoChat ─┬─> ChatPharoAgent ─┬─> ChatPharoTool (REST)
                     │                  │                   │
                     │                  │                   └── Tools (function calls)
                     │                  └── ChatPharoHistory <── ChatPharoHistorySaver*
                     └── Settings UI  <──────── ChatPharoSettings
```

Another diagram to sow the structure:

```
┌────────────────────┐      ┌───────────────────────────┐
│      UI layer      │◄────►│   Chat / History models    │
│  (Spec presenters) │      │ (ChatPharoChat, History…) │
└────────┬───────────┘      └───────────┬───────────────┘
         │                               │
         ▼                               ▼
┌────────────────────┐      ┌───────────────────────────┐
│     Agent layer    │◄────►│  Browser‑tools  facade     │
│  (ChatPharoAgent*) │      │ (ChatPharoBrowserEnv)      │
└────────┬───────────┘      └───────────┬───────────────┘
         │                               │  executes
         ▼                               ▼
┌────────────────────────────────────────────────────────┐
│                ChatPharoTool (REST client)            │
│  – builds OpenAI/Mistral/Ollama/Gemini JSON payloads  │
│  – sends /chat/completions                            │
│  – decodes tool‑calls and loops until done            │
└────────────────────────────────────────────────────────┘
```

### High‑level Class Responsibilities

* **`ChatPharoAgent`** – abstract base; holds `model`, `systemPrompt`, `history`, exposes `getResponseForPrompt:`.
* **`ChatPharoChat`** – synchronous façade; spins a background Smalltalk process for each prompt so the UI stays responsive.
* **`ChatPharoTool`** – generic OpenAI‑style `/chat/completions` client; auto‑routes function calls.
* **`ChatPharoBrowserEnvironment`** – read‑only wrapper around an `RBBrowserEnvironment` exposing safe helpers (list packages, get class comments, …).

### Async Prompt Pipeline

1. UI adds a *user* message to `ChatPharoHistory` ➜ forks `#promptProcess`.
2. `ChatPharoAgent` serialises history, calls `ChatPharoTool` (or custom REST).
3. `ChatPharoTool` posts composite JSON (messages + optional tools).
4. Reply is parsed into `ChatPharoHistorySaver` (+ tool call chain if any).
5. The assistant message is appended; UI callback updates the view.

---

## Agents

### NullAgent (offline)

* **Display name:** *None (offline)*
* Always reachable; returns a static reminder.
* Useful to ship a UI without exposing credentials.

### Ollama (local LLMs)

|                     | Value                    |
| ------------------- | ------------------------ |
| **Endpoint**        | `http://localhost:11434` |
| **Auth**            | none                     |
| **Discover models** | `/api/tags`              |

#### Installation Checklist

1. 💻 Install **Ollama ≥ 0.2.0** (`brew install ollama` or manual download).
2. Pull a model, e.g.:

   ```bash
   ollama pull mistral:7b
   ```
3. In *Settings ▶ Configuration ▶ Agent*, pick **Ollama**.
4. Click **Refresh** to list tags, pick a model.
5. *Test Connection* should turn green.

### Gemini (Google AI Studio)

|              | Value                                                     |
| ------------ | --------------------------------------------------------- |
| **Endpoint** | `https://generativelanguage.googleapis.com/v1beta/openai` |
| **Header**   | `Authorization: Bearer <API‑KEY>`                         |

#### Obtaining an API Key

1. Sign in to [https://aistudio.google.com/](https://aistudio.google.com/).
2. Create a new **API key** in *Settings ▶ API Keys*.<br>
   Keep it restricted to *Generative Language*.
3. Paste the key in *Settings ▶ Configuration ▶ Gemini*.
4. Select a model (`models/gemini-2.0-pro` or `-flash`).
<!---
### Mistral (beta)

The skeleton is present (`ChatPharoMistralAgent`) but wire‑up is pending. Track progress in \[issue #42].
-->
### Adding new agents

Implement the `ChatPharoAgent` protocol:

```smalltalk
MyAgent subclass: #ChatPharoAgent
    instanceVariableNames: 'host apiKey'
    classVariableNames: ''
    package: 'AI-ChatPharo-Agent'
```

*Override class‑side hooks:* `displayName`, `isReachable`, `modelNames`, `settingsPresenterFor:`.
*Override instance method:* `getResponseForPrompt:`

---

## Settings & Persistence

* `ChatPharoSettings` holds the *selected agent* and UI flags.
* Serialised as **STON** in `~/pharo/chatpharo-settings.ston`.<br>
  Use `ChatPharoSettings resetDefault` during development.
* Model & system prompt updates propagate instantly to new chats; existing chats embed a *copy* of the agent for isolation.

---

## Using the UI

### Main Window

Toolbar actions:

| Button                 | Action                                         |
| ---------------------- | ---------------------------------------------- |
| **New Chat**           | Add a notebook page, copying the current agent |
| **Delete Chat**        | Remove selected page                           |
| **Settings**           | Open global settings dialog                    |
| **Refresh Connection** | Re‑ping the active agent                       |

### Temporary Chats

`ChatPharoTemporaryChatPresenter` opens a modal with *Submit/Cancel*. Handy for quick prompts without cluttering the notebook.

### System Browser Integration

Enable *Extensions ▶ Enable browser tab*.
ChatPharo adds context‑aware tabs for **Package**, **Class** and **Method**. The agent receives the entity name via `#packageName:` / `#className:` / `#methodName:` so you can craft specialised prompts.

---

## Tools / Function‑Calling

`ChatPharoBrowserEnvironment` registers a catalogue of safe, read‑only helpers exposed as **OpenAI function calls**:

* `get_packages`
* `get_classes_in_packages`
* `get_class_definitions`
* `get_class_comments`
* `get_class_methods`
* `get_class_subclasses`
* `find_methods_with_substring`
* `open_playground` (opens a Playground when invoked)

---
## Feature Support

The following table summarizes major ChatPharo functionality

| Feature | v1-stable |
|---------|------------|
| Chat sessions with history | ✅ |
| Temporary one-shot prompts | ✅ |
| System Browser integration | ✅ |
| Codebase query tools | ✅ |
| Pluggable LLM agents | ✅ | 

---

## Extending ChatPharo

* **Add new browser tools** by subclassing `ChatPharoBrowserEnvironment` or composing additional `ChatPharoClient`s.
* **Custom UI** – write Spec presenters; embed a `ChatPharoChatPresenter` or drive the model directly.
* **REST tweaks** – override `ChatPharoTool` or provide a completely custom `ChatPharoAgent`.

---

## Contributing

1. Fork [https://github.com/omarabedelkader/ChatPharo](https://github.com/omarabedelkader/ChatPharo) (MIT licensed).
2. Make sure unit tests stay green.
3. Use *pull requests*; CI runs headless Pharo 13 tests.
4. For major features open an issue first to discuss design.

---

## License & Credits

* © 2025 **Omar ABEDELKADER** and contributors – MIT.
* Built on *Pharo [https://pharo.org](https://pharo.org)*.
* Thanks to the **ESUG & Pharo Consortium** community for feedback.
