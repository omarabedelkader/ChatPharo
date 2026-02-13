# Director/Team pattern (multi-agent)

ChatPharo includes a Director/Team subsystem for complex tasks that benefit from role specialization (research, coding, summarization).

## Concept

A `ChatPharoDirector` coordinates an agent team:

- decomposes a request into tasks
- assigns tasks to agents by role
- manages dependencies and execution order
- merges results into a coherent output (optionally via a summarizer agent)

## Components (conceptual)

```text
ChatPharoDirector
  ├── analyzeRequest:  -> task list
  ├── assignTask:      -> select agent by role
  ├── executeTasks     -> run tasks (currently sequential)
  └── mergeResults     -> synthesize response

ChatPharoAgentTeam
  ├── members (Role -> Agent)
  └── agentForRole:

ChatPharoTask
  ├── description / priority / dependencies
  └── status + result

Roles: ChatPharoCoderRole / ChatPharoResearcherRole / ChatPharoSummarizerRole
```

## When to use

- Architecture exploration + implementation plan
- Multi-step feature work (design → code → docs)
- Code review with a dedicated “researcher” and “coder” pass

## Related docs

- Multivers (prompt chaining): **multivers.md**
- Tools: **tools.md**
