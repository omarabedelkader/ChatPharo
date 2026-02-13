# Agents (model backends)

ChatPharo routes requests to a selected “agent”. All agents implement the `ChatPharoAgent` contract so the UI and chat/session code stay backend-agnostic.

## Core responsibilities

An agent typically maintains:

- `model`
- `systemPrompt`
- `history` (LLM-friendly log)
- optional tool calling support
- optional thinking content support

## Included agents (overview)

| Agent | Category | Notes |
|---|---|---|
| `ChatPharoNullAgent` | Offline | Returns a message telling you to configure a backend |
| `ChatPharoOllamaAgent` | Local | Talks to an Ollama server (`localhost:11434` by default) |
| `ChatPharoLMStudioAgent` | Local | Talks to a local LM Studio server |
| `ChatPharoClaudeAgent` | Cloud | Tool-call loop with max iterations; thinking content supported |
| `ChatPharoGeminiAgent` | Cloud | General-purpose cloud backend |
| `ChatPharoDeepSeekAgent` | Cloud | Code-focused cloud backend |
| `ChatPharoMistralAgent` | Cloud | Present but marked as not supported yet |

## Tool calling loop

Some agents follow this pattern:

1. Send request to backend.
2. If the response includes `tool_calls`, execute tools and append results to history.
3. Call the backend again.
4. Stop when no tool calls remain, or when `maximumIterations` is reached.

## Related docs

- Tool schema + execution: **tools.md**
- External API warnings: **safety-ethics.md**
