# Configuration

ChatPharo configuration is managed by `ChatPharoSettings` and edited via Spec presenters.

## Persistence locations

- Logs (when enabled): `FileLocator imageDirectory / 'chatpharo' / 'log-chatpharo.txt'`
- Settings are saved as the default configuration for the image.

## Safety Advisor defaults

ChatPharo includes an Advisor that can apply recommended settings such as:

- agent selection
- enabling tools and skills
- enabling caching + feedback buttons
- enabling sandbox restrictions with a timeout
- setting a safe `maximumIterations`

## Common settings overview

| Setting | What it affects |
|---|---|
| Agent + model | Which backend answers prompts |
| `maximumIterations` | Bounds tool-call loops |
| Tools enabled list | Which built-in tools the model can call |
| Custom tools | User-defined tools exposed to the model |
| Skills enabled list | Which skills are always injected |
| `automaticSkillsEnabled` | Auto-inject skills via keyword detection |
| `skillToolsEnabled` | Allow the model to request skill context |
| Memory toggles | Retention, item limit, auto-summarize |
| Multivers | Whether prompt chaining is active |
| MCP | Whether MCP servers are connected and tools exposed |
| Sandbox | Restrictions/timeout used by tool execution |
| Logging | Whether events are written to disk |

## Practical guidance

- Prefer local agents (Ollama/LM Studio) if you need offline behavior.
- Keep tools enabled unless you are diagnosing problems.
- Keep `maximumIterations` modest (2–5) for predictable tool behavior.

## Related docs

- Agents: **agents.md**
- Tools: **tools.md**
- Memory: **memory.md**
- Sandbox: **sandbox.md**
