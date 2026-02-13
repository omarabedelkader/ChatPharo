# Features

This is a user-facing overview of what ChatPharo can do.

## Core chat

- Multi-tab chat UI (separate conversations per tab).
- Asynchronous requests (UI stays responsive).
- Cancel in-flight requests.
- Commands: `/help`, `/clear`, `/reset`, `/export`, `/history`.

## IDE integration

- System Browser integration: context-aware chats for package/class/method.
- Editor actions: “Ask ChatPharo” and “Code ChatPharo” on selected text/method.
- World menu: open Temp Chat, Settings, Setup Wizard, Tutorial, and Wiki.

See **integration.md**.

## Backends (agents)

Choose between local and cloud models through settings.  
See **agents.md**.

## Tools (function calling)

When enabled, the model can call tools to inspect the codebase, search methods, and more.  
Includes built-in tools, custom tools, and optional MCP tools.  
See **tools.md**.

## Skills (domain docs injection)

Skills provide specialized documentation blocks (Spec2, Roassal, Collections, Bloc, etc.) that are injected into prompts.  
See **skills.md**.

## Memory (long-term)

ChatPharo can store and retrieve memory items (summaries, preferences, corrections) and inject them into prompts.  
See **memory.md**.

## Multivers (prompt chaining)

Multivers runs a configurable chain of steps across agents to improve answer quality for complex tasks.  
See **multivers.md**.

## Safety, ethics, sandbox

- Warnings for high-impact changes (prompt edits, tool disabling, message limits, iterations).
- External API warnings for cloud agents.
- Developer gating for ethics settings.
- Optional sandbox restrictions for code execution.

See **safety-ethics.md** and **sandbox.md**.

## Logging

Optional event logging to a file under the image directory. Helpful for debugging.  
See **configuration.md**.
