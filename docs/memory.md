# Memory

ChatPharo includes an optional long-term memory subsystem that can store and retrieve “memory items” and inject relevant context into prompts.

## What memory is used for

- Remember stable user preferences (e.g., style of explanations)
- Keep concise summaries of prior conversations
- Carry forward important corrections and decisions

## Memory controls

Typical settings include:

- `memoryEnabled`
- `memoryAutoSummarize`
- `memoryRetentionDays`
- `memoryMaxItems`

## How memory affects prompting

When enabled, ChatPharo retrieves relevant memory items for the current query and injects them near the top of the prompt as a dedicated context block.

This is designed to:

- avoid bloating the conversation history
- keep important long-term context available even after resets

## Auto-summarization

When auto-summarize is enabled, ChatPharo can summarize conversations into memory (typically after resets/clears or at a natural conversation boundary).

## Data model (conceptual)

- Memory store: collection of memory items
- Memory item fields: content, timestamp, tags/metadata, source type

## Related docs

- Message flow: **message-flow.md**
- Safety/ethics guidance: **safety-ethics.md**
