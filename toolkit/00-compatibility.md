# Compatibility matrix

Source: `codex_dumped_cache.json` · `client_version` `0.153.4` · `fetched_at` `2026-09-10T13:46:37.579710707Z`

Do not invent aliases. If a later dump changes a slug, update this table before generating envelopes.

## gpt-6-astra

| field | value |
|---|---|
| slug | `gpt-6-astra` |
| display_name | GPT-6-Astra |
| default_reasoning_level | `low` |
| supported_reasoning_levels | `low` `medium` `high` `xhigh` `max` `ultra` |
| shell_type | `unified_exec` |
| tool_mode | `code_mode_only` |
| apply_patch_tool_type | `freeform` |
| web_search_tool_type | `text_and_image` |
| multi_agent_version | `v2` |
| multi_agent_reasoning_effort | `xhigh` |
| experimental_supported_tools | `send_user_message_async` `clock` |
| context_window | `272000` |
| max_context_window | `872000` |
| truncation_policy | `tokens` / `10000` |
| collaboration_modes | `default` `plan` |
| approval_policies | `on_request` `never` `unless_trusted` |
| persistent_deadline | `2027-12-31 23:59:59 UTC` |
| sleep_bound_seconds | `60` |
| reminder_threshold_tokens | `6144` |
| auto_compact_fallback_buffer_tokens | `16384` |
| root_identity | `/root` |
| channels | `commentary` `final` `analysis` |

## Tools

| name | constraint |
|---|---|
| `functions.send_user_message_async` | Persistent-mode progress. Do not duplicate in `final`. |
| `functions.request_user_input_async` | Optional questions only. Never permission. |
| `clock.sleep` | ≤ 60s per call. Prefer over automations for in-flight waits. |
| `update_up_next` | Immediately before sleep. Casual first-person. Clear on resume. |
| `spawn_agent` | Creates a child. `fork_turns` controls context. |
| `followup_task` | New task on an existing child; triggers a turn. |
| `send_message` | Async IPC, no turn. Human-legible. `to=/root/…`. |
| `notes` | Dense checkpoint. |
| `functions.new_context` | Only after `notes` succeeds. Next window does not inherit. |
| `get_context_remaining` | Reminder at 6144 remaining. |
| `history` `list_items` `search_contents` `read_item` | Recover `[id: …]` items. Prefer `read_item`. |
| `apply_patch` | Local edits. Do not cat-write. |
| `functions.exec` | Parallelize independent calls. Never shadow `$HOME`. |
| `skills.list` `skills.read` | Orchestrator: `{"authority":{"kind":"orchestrator"}}`. |

## Confirmation catalog

- `hand_off_required` — confirmation_policies.computer_use §1
- `confirmation_required_at_action_time` — §2
- `pre_approval_allowed` — §3 (must name specific data + specific destination)
- `not_required` — §4
