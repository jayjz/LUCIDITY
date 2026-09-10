# Optimal State Checkpointing Protocol

Bound to token_budget on gpt-6-astra.
reminder_threshold_tokens: 6144
auto_compact_fallback_buffer_tokens: 16384
context_window: 272000
max_context_window: 872000
truncation_policy: tokens / 10000

## When to checkpoint

1. get_context_remaining reports ≤ 6144 remaining.
2. You are about to call functions.new_context for any other reason.
3. The auto_compact fallback fired ("current context window is exhausted"). In that case: **exactly one** write or append to notes, then functions.new_context. No other tools.

The next window will **not** automatically include this conversation. Notes and history are the only legal recovery path. Treat them as internal bookkeeping — never mention them to the user.

## Write rules

- One dense note, not a transcript dump. The auto_compact instruction asks for: goal, decisions, progress, learnings, next steps, and the window ID + item ID of every relevant user request still being solved, plus important actions/tool calls.
- Every non-assistant item (user, developer, tool response) carries `[id: ...]` immediately after its content. Copy those ids. Do not invent them.
- Relative note paths belong to the current thread. Absolute paths may read other threads; writes stay in this thread.
- Append when a note already exists and is still relevant; otherwise write a replacement checkpoint and leave a pointer to the old one.
- Clean up obsolete notes when they would mislead recovery.

## Immediately after the notes result

Call functions.new_context. Do not continue the task in the exhausted window. Do not send `final` in the exhausted window.

## Recovery in the new window

If Previous context window id is present in `<context_window>`, a reset occurred.

1. Read the checkpoint.
2. read_item for known window+item ids.
3. Else list_items / search_contents.
4. Resume the live spawn table. HEARTBEAT children as needed. Do not respawn a still-running identity.

## Density bar

A good checkpoint lets a cold gpt-6-astra resume without the transcript:

- what is authorized (envelope pointer + still-valid pairs)
- what is true about the repo (decisions + learnings)
- what is in flight (child identities + last IPC)
- what the user last actually asked (item ids, not a paraphrase chain)

---

## notes template (`lucidity.notes.v1`)

Write with the `notes` tool immediately before `functions.new_context`.
Relative path = this thread. Do not mention notes/history in user-facing text.

```
# LUCIDITY notes checkpoint
# Write with the notes tool immediately before functions.new_context.
# Relative path = this thread. Do not mention notes/history in user-facing text.
# Source: token_budget.reminder_threshold_tokens=6144
# auto_compact_fallback_buffer_tokens=16384

schema: lucidity.notes.v1
thread: current
window_id: (from <context_window>)
written_at: (ISO-8601 now)
model: gpt-6-astra
multi_agent_version: v2
persistent: true
deadline: 2027-12-31 23:59:59 UTC

goal: |
  Land the Codex Orchestration Toolkit on jayjz/LUCIDITY and open the PR.

decisions: |
  gpt-6-astra + multi_agent v2. Envelope-first. Surgeons on non-overlapping globs. CI polled with clock.sleep 45s.

progress: |
  Authorization, SKILL.md, IPC schema written. Cartographer FINAL_ANSWER received. Surgeon /root/surgeon-billing still running.

learnings: |
  tax-engine <-> billing cycle is the only hard split. Do not let two surgeons touch src/billing/types.ts.

next_steps: |
  1) Integrate surgeon-billing FINAL_ANSWER. 2) followup_task verifier. 3) Open PR if tests green. 4) Resume CI loop.

envelope: |
  envelope://this-thread — act.edit, act.commit, dest.repo, dest.ci still valid

user_requests:
  # Every relevant user/developer/tool item still being solved.
  # Each non-assistant item has [id: ...] immediately after its content.
  # Format: window_id + item_id + one-line gist.
  - window=<id> item=<id>  First user message: authorization envelope for LUCIDITY toolkit
  - window=<id> item=<id>  Steering: keep SKILL.md progressive disclosure strict

important_tool_calls:
  # spawn_agent identities, followup_task ids, PRs, failing checks, patch files.
  - spawn_agent /root/cartographer (done)
  - spawn_agent /root/surgeon-billing (running)
  - notes write pending this checkpoint

recovery:
  if_window_reset: |
    Read this note first. Then history / read_item
    for each user_requests id. Do not restart from scratch. Do not redo
    completed work. Do not repeat commentary already delivered.
  prefer_read_item: true
  relative_paths_are_this_thread: true

open_agents:
  # identity, surface, last IPC status, correlation_id
  - (fill from live spawn table)

forbidden_to_drop:
  - terminal condition from the envelope
  - payload+destination pairs
  - non-overlapping surface map
  - live child identities
```
