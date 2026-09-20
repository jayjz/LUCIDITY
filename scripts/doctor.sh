#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

pass() { echo "PASS  $*"; }
fail() { echo "FAIL  $*" >&2; status=1; }
warn() { echo "WARN  $*"; }

command -v git >/dev/null 2>&1 && pass "git available" || fail "git missing"
command -v python3 >/dev/null 2>&1 && pass "python3 available" || fail "python3 missing"

if command -v codex >/dev/null 2>&1; then
  pass "codex available: $(command -v codex)"
  codex --version || warn "unable to read Codex version"
else
  warn "codex is not on PATH"
fi

python3 - "$repo_root" <<'PY' || exit_code=$?
import pathlib, sys, tomllib
root = pathlib.Path(sys.argv[1])
files = [root / "codex/config/base.toml", *sorted((root / "codex/config").glob("*.config.toml"))]
for path in files:
    with path.open("rb") as f:
        tomllib.load(f)
    print(f"PASS  TOML parses: {path.relative_to(root)}")
PY
exit_code="${exit_code:-0}"
if [[ "$exit_code" -ne 0 ]]; then
  fail "one or more TOML files failed to parse"
fi

if git -C "$repo_root" ls-files | grep -Eq '(^|/)(auth\.json|[^/]*\.auth\.json)$'; then
  fail "credential-shaped auth file is tracked"
else
  pass "no auth.json file is tracked"
fi

if [[ -f "$repo_root/codex/AGENTS.md" ]]; then
  bytes="$(wc -c < "$repo_root/codex/AGENTS.md")"
  pass "global AGENTS.md present (${bytes} bytes)"
else
  fail "codex/AGENTS.md missing"
fi

if grep -RInE '(BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|sk-[A-Za-z0-9_-]{20,})' "$repo_root/codex" "$repo_root/skills" 2>/dev/null; then
  fail "possible secret material found in managed configuration"
else
  pass "no obvious secret pattern found in managed configuration"
fi

exit "$status"
