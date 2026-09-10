# SKILL.md architecture

Canonical source: [`skills/lucidity-orchestration/SKILL.md`](../skills/lucidity-orchestration/SKILL.md)

This module is a Codex skill (YAML frontmatter + body), not a paste-in prompt. Copy the skill file into a session's skills tree. Do not duplicate the body here — keep one source of truth.

## What the skill binds

| Dump section | Skill section |
|---|---|
| Using skills · trigger rules | `## Trigger rules` |
| Context hygiene · progressive disclosure | `## Progressive disclosure` + `### Reference routing` |
| User instructions take precedence | Constraint override (design system + vocabulary) |
| confirmation_policies + Data Exfiltration | `## Authorization surface` |
| skills.list / skills.read | Orchestrator discovery note |

## Reference routing (opt-in)

Load only the reference whose `when` matches the current step:

- `references/confirmation-policies.md` — composing or auditing an authorization envelope
- `references/exfiltration.md` — any payload will leave the current execution environment
- `references/multi-agent-ipc.md` — spawning or messaging sub-agents
- `references/monitor-loop.md` — CI/CD or log-tail follow-ups
- `references/checkpoint.md` — token budget ≤ 6144 or before `functions.new_context`

`SKILL.md` is the only instruction file loaded by default. Do not deep-chase. Do not delegate reading this skill to a sub-agent.
