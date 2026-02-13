# Glossary

- **Agent**: Backend connector that calls a model provider (local or cloud) via the `ChatPharoAgent` interface.
- **Chat (conversation)**: A `ChatPharoChat` instance with UI messages + an LLM history.
- **History**: `ChatPharoHistory` / `ChatPharoHistoryMessage`, the LLM-friendly chat log.
- **Tool**: Callable function exposed to the model (built-in, custom, or MCP).
- **Tool call loop**: Repeated “call model → execute tools → call model again” bounded by `maximumIterations`.
- **Skill**: Documentation pack injected into prompts (manual or auto-detected).
- **Memory**: Long-term store of summaries/preferences/corrections injected into prompts when relevant.
- **Multivers**: Multi-step prompt chaining across multiple agents.
- **Sandbox**: Restrictions/timeout for executing code during tool execution.
- **MCP**: Model Context Protocol integration for external tool servers.
