# P1 instruction archaeology

Date: 2026-09-20 UTC  
Branch: `feat/p1-instruction-archaeology`  
Parent: `feat/personal-codex-control-plane`

## Objective

Classify durable instructions and recurring prompt patterns before expanding the personal Codex configuration.

P1 does not import third-party skills, create custom agents, choose models, or rewrite project contracts. Its output is an evidence-backed ownership map for later phases.

Machine-readable source: [p1-classification.json](p1-classification.json).

## Classification rule

Every instruction gets one primary owner:

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

Promotion to `GLOBAL` requires all of:

1. cross-repository recurrence or an explicit durable user preference;
2. broad applicability beyond one architecture/domain/phase;
3. low risk of conflicting with repository-local instructions;
4. a currently supported Codex mechanism;
5. a clear reason that AGENTS is a better owner than a skill/profile/agent.

**Repetition alone is not sufficient.**

This corrects the main weakness in the P0 reasoning: several projects can repeat the same practice because they are all research-heavy. That does not make the practice appropriate for every coding session.

## Evidence boundaries

The audit used immutable blob identities where GitHub exposed them for:

- CipherLoop `AGENTS.md` and `meta_loop.py`;
- SHAD0W `AGENTS.md`;
- TEMPER `AGENTS.md`;
- evidence-strategy-skills `AGENTS.md`, skill-design, evaluation, and portability standards;
- BuildBlock `AGENTS.md`;
- LUCIDITY's legacy orchestration skill.

The historical `codex_dumped_cache.json` is treated as a runtime snapshot, not a public contract.

Conversation-only prompts are **not canonical P1 evidence** because they lack a stable repository artifact/version. Recurring chat patterns can be added later only after being intentionally captured with provenance.

## Assumptions found and corrected

### 1. Repeated does not mean global

Incorrect pattern:

```text
appears in several repos
→ global AGENTS rule
```

Corrected pattern:

```text
recurs
→ identify why it recurs
→ test broad applicability
→ check conflict risk
→ select owner layer
→ promote only if AGENTS is the narrowest durable owner
```

Result: research-freeze rules, handoff schemas, security-verification procedures, and structured-evidence requirements remain skill/repo candidates rather than global mandates.

### 2. A source can be current but still have the wrong owner

Example: TEMPER's frozen dataset/split/seed rules are strong instructions, but they belong to an experiment-discipline workflow, not ordinary application development.

### 3. Runtime/system prompts are observations, not configuration APIs

The LUCIDITY dump contains useful evidence about initiative, tools, approval handling, and skills. It also contains model names, internal tool identifiers, context thresholds, and host behavior that can change.

P1 therefore records those as `RUNTIME_OBSERVATION` or `STALE` instead of copying them into the global contract.

### 4. Persona prompts do not prove a useful workflow

CipherLoop's `meta_loop.py` uses a "Senior Staff Engineer Architect" system prompt to produce specs for Codex. That demonstrates a repository experiment, not evidence that a persona should become a global agent or skill.

Its `TASK_COMPLETE` self-judgment is especially weak as a completion criterion because the architect infers success from terminal text instead of independently establishing the requested outcome.

### 5. Supported does not mean justified

Current Codex supports profiles, custom subagents, `AGENTS.override.md`, memory, MCP, and skills. Availability alone is not a reason to configure them.

P1 keeps untested mechanisms deferred.

### 6. Account separation does not imply capability equivalence

The Pro and credits accounts are isolated through `CODEX_HOME`, but P1 has no evidence that their model catalogs, credits, rate limits, or service tiers are equivalent.

Model routing remains deferred.

### 7. Global skills and CODEX_HOME are different scopes

Current Codex documentation places user-global skills at `$HOME/.agents/skills` while global AGENTS/config/auth state are resolved through `CODEX_HOME`.

P0 already corrected the installer. P1 treats shared personal skills and account-local configuration as separate ownership surfaces.

## High-confidence global rules

The audit supports the existing global contract:

- inspect relevant instructions/code/tests/git state before substantial changes;
- search before assuming absence;
- preserve existing user/agent work;
- keep unrelated work out of scope;
- separate observed/sourced facts from inference and unresolved questions;
- prefer the smallest coherent change;
- require evidence before new abstraction/infrastructure;
- verify proportionally and never claim an unrun check passed;
- preserve negative/null research results when doing research.

One missing rule is promoted by P1:

> Never commit credentials, tokens, private keys, or other secrets.

That rule recurs across SHAD0W, evidence-strategy-skills, and BuildBlock and has broad applicability with low conflict risk.

## Strong skill candidates

P1 does **not** implement these yet. It establishes candidates for P3.

### experiment-discipline

Sources: TEMPER + evidence-strategy-skills.

Candidate behaviors:

- freeze experimental conditions;
- avoid thesis-confirming optimization;
- preserve failures/null results;
- separate development/calibration/test;
- record provenance and limitations.

### skill-development

Sources: evidence-strategy-skills + current Codex skill documentation.

Candidate behaviors:

- define user job and exclusions;
- progressive disclosure;
- positive/negative/ambiguous activation cases;
- separate activation from effectiveness;
- record package/runtime provenance;
- preserve rejected skills.

### session-handoff

Source: TEMPER.

Candidate artifact:

- changed;
- verified;
- unverified;
- commands;
- active hypothesis;
- next bounded action.

This should activate only for substantial or long-running work.

### evidence-handoff / verification-reporting

Sources: SHAD0W + TEMPER + evidence-strategy-skills.

Candidate behavior: preserve enough structured evidence to reconstruct consequential decisions without treating conversation history as the durable record.

### security-research-hygiene

CipherLoop's exact source/sink/code-slice threshold stays repo-local, but its underlying evidence/precondition discipline is a credible reusable security skill candidate.

## Explicit non-promotions

These do not belong in the global personal config:

- CipherLoop sandbox/network/POSIX-path invariants;
- SHAD0W trading/risk/broker authority;
- BuildBlock P0 product/non-goal rules;
- TEMPER dataset/split/calibration specifics;
- evidence-strategy-skills execution-plan path convention;
- CipherLoop's `/compact` advice;
- LUCIDITY's Astra/multi-agent runtime pins;
- LUCIDITY's UI design system inside orchestration;
- internal tool names/context thresholds from the runtime dump;
- mandatory LUCIDITY Authorization Envelopes for ordinary Codex use;
- CipherLoop's architect persona and `TASK_COMPLETE` self-verdict.

## Current Codex documentation check

The public docs currently support the architecture assumptions P1 relies on:

- global and nested `AGENTS.md` are layered and closer project instructions take precedence;
- `AGENTS.override.md` can override instructions at a scope;
- profiles are separate `$CODEX_HOME/<name>.config.toml` overlays;
- custom subagents have bounded role-specific configuration;
- personal skills use `$HOME/.agents/skills`, repository skills use `.agents/skills`;
- progressive disclosure loads skill metadata before full instructions/resources.

P1 does not duplicate those host semantics into personal instructions unless a personal preference changes the default.

## Immediate configuration changes justified by P1

1. Add the cross-repo secret-handling rule to `codex/AGENTS.md`.
2. Remove the explicit `[agents] enabled = true` stanza from `base.toml`. Current Codex defaults it to true, so the stanza is redundant and falsely implies P0 made an intentional multi-agent policy decision.
3. Add machine-readable inventory validation to CI.
4. Mark P1 complete in the roadmap only after the inventory validates.

## What remains unknown

- whether the Pro and credits accounts expose the same models or rate/credit economics;
- whether research/review/readonly profiles measurably improve workflow;
- whether custom agents beat a single-agent baseline for your actual repos;
- whether memories improve continuity without creating stale or hidden context problems;
- whether `AGENTS.override.md` solves a recurring need for temporary personal overrides;
- which candidate skills produce measurable activation/effectiveness gains.

Those are later experiments, not assumptions to encode now.
