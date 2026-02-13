# Multivers

Multivers is ChatPharo’s optional “chain mode”: a configurable sequence of steps where each step can be handled by a different agent. This enables workflows like:

> draft → critique → refine → final

## When Multivers runs

Multivers is consulted during prompt orchestration (before the final agent call). If Multivers is enabled and configured, it can transform the user prompt across multiple steps.

## Mental model

```text
User prompt
   |
   v
[Step 1 Agent] -> produces revised prompt
   |
   v
[Step 2 Agent] -> produces revised prompt
   |
   v
...
   |
   v
Final prompt -> main agent call -> response
```

## Typical step patterns

- **Planner**: restate goal and constraints
- **Critic**: identify missing context / edge cases
- **Refiner**: produce final answer with improvements
- **Verifier**: double-check claims against tools (when available)

## Configuration

Multivers can be configured from the UI:

- enable/disable
- choose number of steps
- assign agents to steps
- reorder steps

## Related docs

- Architecture: **architecture.md**
- Message flow: **message-flow.md**
