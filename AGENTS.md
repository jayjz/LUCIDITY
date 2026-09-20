# LUCIDITY development contract

## Mission

LUCIDITY is the version-controlled source of truth for Jay's personal Codex workflow. Configure Codex through supported extension points instead of copying private or transient runtime instructions.

## Source precedence

For durable behavior, prefer:

1. current official Codex documentation;
2. reproducible behavior observed with the installed Codex version;
3. this repository's architecture and tests;
4. dated runtime snapshots and prompt research.

Do not promote an internal runtime observation to a durable contract without verification.

## Working method

Before substantial changes:

1. inspect the relevant files and git state;
2. search before assuming a capability or convention does not exist;
3. identify which layer owns the behavior: global instruction, repo instruction, skill, profile, agent, MCP, or runtime observation;
4. make the smallest coherent change;
5. verify the affected behavior;
6. report what remains unverified.

Preserve existing user work. Do not reset, clean, force-push, rewrite history, or overwrite credentials.

## Evidence

Do not claim commands, tests, model behavior, account capabilities, or documentation were verified unless actually observed.

Keep these distinct:

- observed fact
- sourced fact
- inference
- assumption
- unresolved question

Preserve negative and null results. Do not weaken an evaluation to make a configuration appear successful.

## Architecture

Keep durable personal behavior in `codex/AGENTS.md`, persistent Codex settings in `codex/config/`, repeatable procedures in `skills/`, specialized delegated roles in `codex/agents/`, and dated runtime observations in `research/runtime-snapshots/`.

Credentials, `auth.json`, sessions, logs, caches, and secrets stay outside Git.

Project-specific domain rules belong in the project repository, not the global configuration.

## Scope discipline

Do not add a skill, custom agent, MCP server, profile, or abstraction without a recurring workflow or measured need.

Do not hard-code a model name, context size, internal tool identifier, or experimental runtime behavior into the durable core unless current public Codex documentation supports it and the repository records why the pin is required.

## Verification

Prefer focused validation first. Broaden verification when a change affects shared configuration, installation behavior, or multiple repositories.

Configuration changes should be tested against a disposable `CODEX_HOME` before being recommended for active accounts.
