# Tools

Tools are the bridge between the LLM and the Pharo environment. When tool calling is enabled and the backend supports it, the model can request specific tool functions to be executed locally.

## Tool categories

### Built-in environment tools

`ChatPharoBrowserEnvironment` exposes a set of functions for IDE/codebase introspection, such as:

- list packages/classes
- describe classes/methods
- find methods by substring
- (optionally) evaluate code

These tools are typically toggled on/off via settings.

### Custom tools

Custom tools are user-defined functions created from the UI:

- name + description
- parameter definitions (schema-like)
- Smalltalk code body
- test execution from the tool editor
- saved into settings and exposed as “clients” to the LLM

### MCP tools (optional)

When MCP is enabled, MCP servers contribute tools which are surfaced as clients (see **mcp.md**).

## Tool calling lifecycle

```text
Model response includes tool_calls
            |
            v
ChatPharoAgent detects tool_calls
            |
            v
Execute tool locally (browser/custom/MCP)
            |
            v
Append tool result to ChatPharoHistory (role: tool)
            |
            v
Call model again with updated history
```

## Sandbox interaction

If the sandbox is enabled, tool execution can be restricted (filesystem/network/system access) and timed out.  
See **sandbox.md**.

## Extending tools

- For built-in tools: add functions to `ChatPharoBrowserEnvironment` and expose a proper schema.
- For user tools: create via the Tools UI (recommended for most use cases).
- For external tool servers: use MCP.

## Related docs

- Message flow: **message-flow.md**
- Sandbox: **sandbox.md**
- MCP: **mcp.md**
