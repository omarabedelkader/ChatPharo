# Skills

Skills are structured documentation “packs” injected into prompts to improve answer quality in specific domains (Spec2, Roassal, Collections, Bloc, etc.).

## How skills work

A skill is a subclass of `ChatPharoSkill` with:

- `name` (unique ID)
- `description`
- `keywords` (for matching)
- `contextString` (the injected documentation)

Skills are discovered by scanning subclasses and are managed by `ChatPharoSkillRegistry`.

## Manual skills

Manually enabled skills are always injected as:

```text
### ENABLED SKILLS CONTEXT ###
<skill context...>
```

## Automatic skill detection

If enabled, ChatPharo extracts keywords from the current query and injects matching skills that are marked as auto-enabled:

```text
### AUTO-DETECTED SKILLS CONTEXT ###
(Based on detected keywords: ...)
<skill context...>
```

## Skill tools

When `skillToolsEnabled` is enabled, the model can call tools such as:

- `list_available_skills`
- `get_skill_context`

This lets the model request specialized docs on demand.

## Included skills (examples)

- ChatPharo help skill (how to use ChatPharo)
- Roassal (visualization)
- Spec2 (UI)
- Collections (core library)
- Bloc (low-level UI)

## Adding a new skill (developer)

1. Create a new subclass of `ChatPharoSkill`.
2. Implement `name`, `description`, `keywords`, and `contextString`.
3. Refresh the skills list in settings (or reset the registry).

## Related docs

- Features: **features.md**
- Tools and skill tools: **tools.md**
