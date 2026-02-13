# Architecture

This document describes ChatPharo as a set of layers with **separation of concerns**. All diagrams are plain text so the docs remain **100% Markdown**.

## Layered architecture overview

```text
+--------------------------------------------------------------+
| UI Layer (Spec presenters)                                   |
| - ChatPharoPresenter (tabs + input)                           |
| - Settings presenters (Agent, Tools, Skills, Memory, etc.)    |
| - Help + Thinking presenters                                  |
+-------------------------------+------------------------------+
                                |
                                v
+--------------------------------------------------------------+
| Chat Session Layer                                           |
| - ChatPharoChat (one conversation)                            |
| - ChatPharoMessage (UI messages)                              |
| - ChatPharoCommandParser (/help, /reset, /export, ...)         |
| - ChatPharoHistory + ChatPharoHistoryMessage (LLM log)        |
+-------------------------------+------------------------------+
                                |
                                v
+--------------------------------------------------------------+
| Prompt Orchestration Layer                                   |
| - History → promptPrefix                                      |
| - + Memory context injection (optional)                       |
| - + Skills context injection (optional)                       |
| - Multivers prompt chaining (optional)                        |
+-------------------------------+------------------------------+
                                |
                                v
+--------------------------------------------------------------+
| Agent Layer (Backends)                                       |
| - ChatPharoAgent (contract)                                   |
| - Claude / Gemini / Ollama / DeepSeek / LM Studio / ...        |
| - Tool-call loop bounded by maximumIterations                 |
+-------------------------------+------------------------------+
                                |
                                v
+--------------------------------------------------------------+
| Tool & Execution Layer                                       |
| - ChatPharoTool (OpenAI-like request/response + tool_calls)   |
| - ChatPharoBrowserEnvironment tools                            |
| - Custom tools (user-defined)                                 |
| - MCP tools (optional)                                        |
| - Sandbox restrictions (optional)                             |
+-------------------------------+------------------------------+
                                |
                                v
+--------------------------------------------------------------+
| Persistence & Observability                                  |
| - ChatPharoSettings (saved defaults)                          |
| - Memory store + history export/import                        |
| - ChatPharoLogger (frontend/backend/system logs)              |
+--------------------------------------------------------------+
```

## Key design goals

- **Pluggable backends**: any agent implementing the `ChatPharoAgent` contract can be selected.
- **Tooling as callable functions**: tools have a name/description/schema; the model can call them.
- **Optional subsystems**: Memory, Skills, Multivers, MCP, Sandbox can be enabled independently.
- **Dual representation**: UI messages and LLM history messages are kept in sync but are different objects.

## What to read next

- End-to-end execution path: **message-flow.md**
- Tool calling lifecycle: **tools.md**
- Memory injection model: **memory.md**
- Multivers chain: **multivers.md**
## Runtime flow summary

The layered view shows *where* things live; this snippet shows *how* they cooperate at runtime:

```text
ChatPharoPresenter -> ChatPharoChat
    -> (history + memory + skills + multivers) -> final prompt
    -> ChatPharoAgent -> ChatPharoTool (HTTP)
    -> (optional tool_calls loop) -> ChatPharoChat updates UI + history
```

For the fully detailed pipeline, see **message-flow.md**.
