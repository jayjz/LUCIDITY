# LUCIDITY

LUCIDITY is a version-controlled personal Codex control plane.

It stores durable operating instructions, reusable skills, configuration profiles, account launch helpers, and research evidence about Codex behavior. Authentication, sessions, logs, caches, and other mutable account state stay outside Git.

## Architecture

```text
LUCIDITY
├── AGENTS.md                 repository development contract
├── ARCHITECTURE.md           durable ownership boundaries
├── ROADMAP.md                phased implementation plan
├── codex/
│   ├── AGENTS.md             installable global Codex instructions
│   └── config/
│       ├── base.toml
│       ├── research.config.toml
│       ├── review.config.toml
│       └── readonly.config.toml
├── skills/                   source for personal user-global skills
├── scripts/
│   ├── install.sh            dry-run-first installer
│   ├── codex-account         isolated account launcher
│   └── doctor.sh             static configuration checks
├── toolkit/                  legacy orchestration research
├── schemas/                  legacy orchestration schemas
└── research/runtime-snapshots/
```

Installed state is split across two documented Codex surfaces:

```text
CODEX_HOME
├── AGENTS.md
├── config.toml
├── *.config.toml
└── auth/session/log state

$HOME/.agents/skills
└── personal user-global skills
```

## Two-account setup

Keep each ChatGPT/Codex account in a separate `CODEX_HOME`:

```text
~/.codex-pro
~/.codex-credits
```

Both accounts share the same user-global skill library at `$HOME/.agents/skills` when they run as the same OS user.

Dry-run installation first:

```bash
bash scripts/install.sh --home "$HOME/.codex-pro"
bash scripts/install.sh --home "$HOME/.codex-credits"
```

Apply after reviewing the diff:

```bash
bash scripts/install.sh --home "$HOME/.codex-pro" --apply
bash scripts/install.sh --home "$HOME/.codex-credits" --apply
```

Then authenticate each home independently using Codex's normal login flow.

Launch a specific account home with:

```bash
bash scripts/codex-account pro
bash scripts/codex-account credits
```

All additional Codex arguments are forwarded:

```bash
bash scripts/codex-account pro --profile research
bash scripts/codex-account credits --profile review
```

The launcher supports custom locations through `LUCIDITY_CODEX_PRO_HOME` and `LUCIDITY_CODEX_CREDITS_HOME`.

## Profiles

Profiles are task modes, not accounts.

Current model-agnostic profiles:

- `research`: workspace write access with live web search.
- `review`: read-only sandbox with cached web search.
- `readonly`: conservative read-only sandbox.

No model is pinned yet. Model routing will be added only after the available catalog is observed independently for each account.

## Global behavior

`codex/AGENTS.md` contains only cross-project behavior:

- inspect before changing;
- preserve existing work;
- separate evidence from inference;
- prefer bounded changes;
- verify proportionally;
- preserve negative/null research results;
- defer domain-specific rules to the closest project `AGENTS.md`.

Project rules remain in their own repositories.

## Validation

Run:

```bash
bash scripts/doctor.sh
```

The doctor checks that configuration TOML parses, obvious credential material is not tracked in managed configuration, the global instruction file exists, and the Codex executable/version can be observed when installed.

For installation testing, isolate both destinations:

```bash
tmp_root="$(mktemp -d)"
bash scripts/install.sh \
  --home "$tmp_root/codex-home" \
  --skills-dir "$tmp_root/skills" \
  --apply

CODEX_HOME="$tmp_root/codex-home" codex --ask-for-approval never \
  "Summarize the current instructions."
```

## Legacy orchestration toolkit

The original LUCIDITY work remains under `toolkit/`, `schemas/`, `skills/lucidity-orchestration/`, and the historical `codex_dumped_cache.json`.

That material is research evidence from an earlier Codex runtime. It is not automatically a durable public configuration contract.

The roadmap preserves it until the instruction audit classifies each part as:

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

See [ROADMAP.md](ROADMAP.md) for the migration sequence and [ARCHITECTURE.md](ARCHITECTURE.md) for ownership rules.
