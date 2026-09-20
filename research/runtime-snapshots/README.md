# Runtime snapshots

This directory is for dated observations of Codex runtime behavior that are useful for research but are not public configuration contracts.

Each snapshot should record:

- observation date;
- Codex client version;
- account/profile context when relevant;
- source of the observation;
- what was directly observed;
- what remains inferred or unknown.

Private prompts, credentials, access tokens, private user data, or secrets must not be committed.

The historical `codex_dumped_cache.json` at the repository root predates this architecture. Treat it as legacy research evidence until it is reviewed and migrated; do not use it as the canonical source for durable configuration.
