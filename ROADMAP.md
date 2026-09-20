# LUCIDITY roadmap

## Goal

Make LUCIDITY the reproducible source of truth for Jay's personal Codex workflow across accounts and machines.

## P0 — Foundation

Status: active

Deliver:

- root development `AGENTS.md`
- global `codex/AGENTS.md`
- architecture and roadmap
- stable base config template
- model-agnostic profiles
- diff-first installer
- shared personal skill installation
- separate-account launcher convention
- static doctor checks

Exit criteria:

- no credentials are tracked;
- installer can target a disposable `CODEX_HOME` and disposable skills directory;
- user-global skills install to the documented `$HOME/.agents/skills` surface;
- durable files contain no dependency on private runtime-only contracts;
- current LUCIDITY orchestration behavior is preserved until a later migration.

## P1 — Instruction audit

Classify instructions from LUCIDITY and active project repositories as:

```text
GLOBAL
REPO
SKILL
PROFILE
AGENT
RUNTIME_OBSERVATION
STALE
UNKNOWN
```

Produce a dated inventory and remove duplication only after review.

## P2 — Account isolation

Validate independent `~/.codex-pro` and `~/.codex-credits` homes.

Add Linux/macOS and Windows launchers.

Do not assume either account's model catalog, credit behavior, service tier, or rate limits. Record observed account capabilities separately.

Personal skills remain shared at `$HOME/.agents/skills` unless later evidence justifies a different account-isolation mechanism.

## P3 — Core skills

Adopt or adapt a small initial set covering engineering, writing, review, issue implementation, security research, literature/citation work, experiment design, model evaluation, and skill development.

Every skill requires a clear description, trigger/non-trigger cases, provenance, and validation.

## P4 — Orchestration refactor

Audit `skills/lucidity-orchestration`.

Remove or isolate hard model pins, transient internal tool names, unrelated UI design constraints, and assumptions no longer supported by public documentation.

Split the skill only if evaluation shows narrower skills activate more reliably.

## P5 — Profiles and model routing

Add profiles only for observed recurring modes such as default, research, review, read-only, and heavy.

Keep model names in configuration rather than behavioral instructions. Validate model availability per account before assigning routing.

## P6 — Custom agents

Evaluate bounded roles such as researcher, reviewer, security-reviewer, and experiment-auditor.

Require a measurable reason for each agent to exist.

## P7 — Tooling

Add installed-config diff, provenance lockfile, update command, and deeper configuration validation.

Add MCP servers only for recurring workflows with clear trust and secret boundaries.

## P8 — Evaluation harness

Use real tasks from active repositories to measure global instruction compliance, skill activation, skill effectiveness, false activation, unnecessary tool use, verification quality, model/profile differences, and cost/latency where available.

Preserve failures and null results.

## P9 — Project migration

Reduce duplicated global rules from project `AGENTS.md` files incrementally while keeping project-specific contracts local.
