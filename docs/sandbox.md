# Sandbox

ChatPharo can run tool-related code execution under a sandbox configuration to reduce risk.

## What the sandbox is for

- Restrict risky operations during tool execution (especially custom tools)
- Provide a timeout to avoid long-running code
- Offer optional restrictions for:
  - filesystem access
  - network access
  - system/process access

## Typical defaults

Advisor defaults commonly enable:

- sandbox enabled
- restrict filesystem
- restrict network
- restrict system access
- timeout (e.g., 5000ms)

## Where sandboxing applies

- Custom tool execution (if configured to use evaluation)
- Any tool function that executes code dynamically

> Pure introspection tools (listing packages/classes) generally do not need sandboxing.

## Related docs

- Tools: **tools.md**
- Safety & Ethics: **safety-ethics.md**
