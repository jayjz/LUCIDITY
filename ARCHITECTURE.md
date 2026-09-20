# LUCIDITY architecture

## Purpose

LUCIDITY is a reproducible personal Codex control plane.

The repository stores durable workflow policy and installable configuration. Codex account credentials and mutable runtime state remain outside the repository.

## Configuration layers

```text
LUCIDITY source
    |
    +-- codex/AGENTS.md       durable global behavior
    +-- codex/config/         user configuration and profiles
    +-- codex/agents/         specialized Codex subagents
    +-- skills/               personal reusable workflows
    +-- scripts/              install, diff, doctor, launch
    +-- research/             dated runtime evidence
    |
    +--> CODEX_HOME
    |      +-- AGENTS.md
    |      +-- config.toml
    |      +-- <profile>.config.toml
    |      +-- auth/session/log state
    |
    +--> $HOME/.agents/skills
           +-- user-global skills
```

## Ownership rules

### Global AGENTS

`codex/AGENTS.md` contains behavior that should apply across repositories: inspect first, preserve work, separate evidence from inference, use the smallest justified change, verify claims, and preserve negative results.

Keep it concise enough to be useful on every task.

### Repository AGENTS

Project repositories own domain-specific constraints and current phase rules.

Examples include CipherLoop sandbox isolation, SHAD0W trading authority, TEMPER experiment methodology, and BuildBlock product boundaries.

LUCIDITY must not duplicate those constraints globally.

### Skills

A skill owns a repeatable procedure with a clear trigger and non-trigger. Use progressive disclosure: keep the entrypoint focused and load references or scripts only when needed.

Codex discovers user-global skills from `$HOME/.agents/skills`. Repository skills belong under the applicable repository's `.agents/skills` tree.

LUCIDITY's `skills/` directory is the version-controlled source used to install the personal user-global skill set. Both Codex accounts share that skill set when they run under the same OS user.

### Profiles

Profiles select task operating modes such as research, review, or read-only behavior. Profiles do not represent user accounts.

### Accounts

Separate accounts use separate `CODEX_HOME` directories so configuration, authentication, sessions, logs, and account state cannot collide.

Initial convention:

```text
~/.codex-pro
~/.codex-credits
```

LUCIDITY may install the same policy and profiles into both homes, but it must never copy or version `auth.json`.

Changing `CODEX_HOME` does not create a separate user-global skill directory. Account-specific skill sets are not part of the initial design.

### Custom agents

Custom agents are specialized delegated roles. Add one only when the role benefits from distinct instructions, tools, permissions, or model configuration and can be evaluated independently.

### Runtime research

Internal prompt dumps, model-specific tool names, context limits, and experimental features are evidence snapshots, not durable API contracts.

Store them under `research/runtime-snapshots/` with date/version metadata.

## Design constraints

1. Prefer public Codex extension points over prompt replication.
2. Keep account identity and task profile orthogonal.
3. Never version credentials.
4. Keep model routing replaceable.
5. Make installation diff-first and non-destructive.
6. Evaluate activation and effectiveness of reusable skills.
7. Record configuration provenance: LUCIDITY commit, Codex version, account home, and relevant profile.
