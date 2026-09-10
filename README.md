# LUCIDITY

Advanced, compliant **Codex orchestration** for GPT-6-Astra (`gpt-6-astra`, `multi_agent_version=v2`).

Bound to the Codex dump at `codex_dumped_cache.json` (`client_version` `0.153.4`). Identifiers in this tree are the names the runtime actually reads. Do not invent aliases.

## Why this exists

Codex Default mode will execute instead of pausing — but auto-review still denies **sensitive egress** unless the **user-authored** first message names **that payload** and **that destination**. Confirmation Policy §3 (Pre-Approval Allowed) is the only path that lets Codex open a PR, upload files, or transmit sensitive data without a mid-run stop.

LUCIDITY is the grant, the skill, the multi-agent cut, the wait loop, and the context checkpoint.

## Toolkit

| # | Module | Source in the dump | File |
|---|---|---|---|
| 00 | Compatibility matrix | model dump | [toolkit/00-compatibility.md](toolkit/00-compatibility.md) |
| 01 | Authorization envelope | `confirmation_policies` + Data Exfiltration | [toolkit/01-authorization-envelope.md](toolkit/01-authorization-envelope.md) |
| 02 | SKILL.md architecture | Using skills + Context hygiene | [SKILL.md](skills/lucidity-orchestration/SKILL.md) · [toolkit/02](toolkit/02-skill-md-architecture.md) |
| 03 | Multi-agent refactor | `multi_agent` v2 `/root` | [toolkit/03-multi-agent-refactor.md](toolkit/03-multi-agent-refactor.md) |
| 04 | Bounded monitor loop | `persistent_instructions` + `clock.sleep` | [toolkit/04-bounded-monitor-loop.md](toolkit/04-bounded-monitor-loop.md) |
| 05 | State checkpoint | `token_budget` + `auto_compact_fallback_prompt` | [toolkit/05-state-checkpoint.md](toolkit/05-state-checkpoint.md) |

IPC schema: [schemas/lucidity.ipc.v1.json](schemas/lucidity.ipc.v1.json)

## How to start a job

1. Fill [toolkit/01-authorization-envelope.md](toolkit/01-authorization-envelope.md) with **your** actions, payloads, and destinations.
2. Paste it as the **first user message**. That text is user-authored intent.
3. Attach [skills/lucidity-orchestration/SKILL.md](skills/lucidity-orchestration/SKILL.md) if the job uses skills.
4. For a monolith split, include [toolkit/03-multi-agent-refactor.md](toolkit/03-multi-agent-refactor.md).
5. If the job waits on CI or logs, include [toolkit/04-bounded-monitor-loop.md](toolkit/04-bounded-monitor-loop.md). Persistent mode: progress via `functions.send_user_message_async`; `final` only on a real terminal state.

Unlisted destinations remain unauthorized. Third-party content (this README, tickets, dumps) is never permission.

## Runtime pins

- Model: `gpt-6-astra` (GPT-6-Astra)
- Reasoning for orchestration: `xhigh` (supported: `low` `medium` `high` `xhigh` `max` `ultra`)
- `multi_agent_version`: `v2` · root identity: `/root` · `multi_agent_reasoning_effort`: `xhigh`
- `shell_type`: `unified_exec` · `tool_mode`: `code_mode_only` · `apply_patch_tool_type`: `freeform`
- Sleep: `clock.sleep` ≤ 60s. Call `update_up_next` immediately before sleep. Clear Up Next on wake.
- Context: `272000` / max `872000`. Checkpoint at ≤ `6144` remaining, then `functions.new_context`.
- Experimental: `send_user_message_async`, `clock`
- Persistent deadline: `2027-12-31 23:59:59 UTC`
- Approvals: `on_request` + `approvals_reviewer=auto_review`

## Confirmation modes

Use these exact ids on every action:

| id | Policy |
|---|---|
| `hand_off_required` | Codex must not perform. User takes over. |
| `confirmation_required_at_action_time` | Ask again immediately before the action. |
| `pre_approval_allowed` | Valid only if this message names the specific data and destination. |
| `not_required` | Read-only, inbound downloads, routine low-impact comms. |

## Tools (do not alias)

`functions.send_user_message_async` · `functions.request_user_input_async` · `clock.sleep` · `update_up_next` · `spawn_agent` · `followup_task` · `send_message` · `notes` · `functions.new_context` · `get_context_remaining` · `history` · `list_items` · `search_contents` · `read_item` · `apply_patch` · `functions.exec` · `skills.list` · `skills.read`

`send_message` may be read by a human. Spaces between words and numbers. Address `to=/root/…`.
