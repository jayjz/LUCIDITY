# LUCIDITY Bounded Async Monitoring Loop
# persistent_instructions + clock.sleep + update_up_next
# functions.send_user_message_async for status. final only on a real terminal state.
# Sleep bound: 60s per clock.sleep call.

You are in **persistent mode** until this loop hits a terminal condition below.
First-order goal remains the user's request. Persistence does not broaden authorization.

Do not create an automation, scheduler, or recurring webhook to finish this in-flight wait.
Prefer clock.sleep between checks. Bound the follow-up by purpose, scope, and outcome — not by a check count.
A pending, running, inconclusive, or unchanged result is **not** completion. Never invent an earlier stop.

---

## Target

- What: GitHub Actions on the authorized pull request
- Locator: gh pr checks / gh run watch for the PR opened in this session
- Authorization: only destinations and payloads named in the Authorization Envelope. This loop is not itself a grant.

## Terminal condition (real)

Stop the loop, clear Up Next, and send `final` when **any** of these is true:

1. SUCCESS — Every required check reports conclusion=success and the PR is mergeable (or mergeable_state=unstable only due to non-required checks).
2. FAILURE — Any required check reports conclusion=failure or cancelled, or the PR is closed without merge.
3. CANCEL — The user says stop/cancel, or the persistent deadline 2027-12-31 23:59:59 UTC is reached, or authorization for dest.ci is withdrawn.

If the observation window is still open and the target is running, continue.

## Loop

repeat:
  1. Inspect the target (read-only unless a fix is in-scope).
  2. Classify state: running | success | failure | cancelled | unknown.
  3. If terminal (success/failure/cancel): follow "On terminal" and break.
  4. If running/unknown:
     a. Maybe notify (see cadence).
     b. Call update_up_next **immediately before sleep** with a concise casual first-person waking plan. Include history_summary only if meaningful progress occurred this iteration (state change, new failing step, log signature).
     c. clock.sleep for 45 seconds (hard cap 60).
     d. On wake, **clear Up Next**, then resume at step 1.

Do not sleep longer than 60s in one call. Chain sleeps if the pipeline is slow. Elapsed time is not an answer.

## update_up_next template

Text, casual first person, no tool names in the user-facing Up Next string:

  "I'll wake in 45s and re-check the required CI on this PR. Last seen: <state> on <check>."

history_summary (only on change):

  "CI moved from queued to in_progress on <job>. Still not terminal."

## User-visible cadence (functions.send_user_message_async)

- Send an async user message on the first observation, on every state change, and every 3 running polls.
- After 6 unchanged running polls, send one quiet heartbeat ("still in progress, <job>, <elapsed>") and keep looping.
- Do not duplicate that text in `final`.
- Do not put blocking questions in commentary. If authorization is missing, stop the dependent work and ask in `final` (or keep the question pending).

Lead each async update with the useful finding (current conclusion, failing step, elapsed). Do not announce "follow-up task" or "the follow-up is complete."

## On terminal

SUCCESS:
Send one functions.send_user_message_async with check names and conclusions, then final summarizing the green pipeline. Do not merge unless act.merge is pre-approved.

FAILURE:
Diagnose the failing job logs in-scope, apply a fix if act.edit is authorized, push, and resume the loop on the new run. If the failure is out of scope, final with the diagnosis and stop.

CANCEL:
Stop immediately. One async line if work had been in progress, then `final` stating that the user (or deadline) cancelled the loop.

## Safety

- No `git reset --hard`, no force-push to protected branches, no egress to unlisted destinations while looping.
- Log tails: do not persist secrets from logs into notes, PRs, or async messages. Redact tokens.
- If auto-review rejects a diagnostic command, continue with a safer read and report the block.
