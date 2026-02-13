# IDE integration

ChatPharo integrates with Pharo through world menu items, editor actions, and System Browser context tracking.

## World menu entries

A “ChatPharo” world menu group commonly contains:

- Temp ChatPharo (open a temp chat window)
- ChatPharo Settings
- Setup Wizard
- Tutorial
- Wiki/Documentation link

## Editor integration

In the code editor, ChatPharo can expose actions for selected text:

- “Ask ChatPharo” — ask questions about the selected code
- “Code ChatPharo” — request generated code for the selection

These integrations are typically implemented as extensions on `RubSmalltalkEditor` or command objects.

## System Browser context

ChatPharo can maintain separate chat histories keyed by context:

- package
- class
- method

This enables context-aware assistance where the agent system prompt can include the active package/method information.

## Related docs

- Features: **features.md**
- Message flow: **message-flow.md**
