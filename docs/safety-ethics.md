# Safety & Ethics

ChatPharo includes guardrails to help users avoid accidental misconfiguration and to keep AI-assisted workflows safer.

## Safety Advisor (confirmations and defaults)

The Safety Advisor can:

- propose recommended defaults (agent, tools, skills, caching, sandbox, etc.)
- show confirmations when changing high-impact settings, such as:
  - modifying prompts
  - disabling tools
  - lowering iterations below 1
  - changing message limits
  - selecting cloud agents (external API warning)

## External API warning

When you pick an agent that uses an external API (cloud), ChatPharo can show a warning dialog about sending data to an external provider. Verified developers can optionally dismiss this warning permanently.

## Ethics settings

Ethics controls may include budgets and limits such as:

- token budget
- time budget
- message limit
- cognitive-load budget

Ethics settings are commonly restricted to verified developers and require enabling a “developer” mode or providing a developer ID.

## Practical guidance

- Keep tools enabled for best results; disable only when diagnosing.
- Keep tool iterations bounded (e.g., 2–5).
- Prefer local agents if you handle sensitive code and do not want data to leave your machine.

## Related docs

- Configuration: **configuration.md**
- Sandbox: **sandbox.md**
