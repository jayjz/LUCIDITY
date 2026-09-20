#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install.sh --home PATH [--skills-dir PATH] [--apply]

Default mode is a dry run. --apply writes only LUCIDITY-managed files.

--home controls CODEX_HOME configuration/account state.
--skills-dir defaults to $HOME/.agents/skills, the documented user-global
Codex skill location.

The installer never copies, deletes, or modifies auth.json, sessions, logs,
history, caches, or other account state.
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_home=""
target_skills="${HOME}/.agents/skills"
apply=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      target_home="$2"
      shift 2
      ;;
    --skills-dir)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      target_skills="$2"
      shift 2
      ;;
    --apply)
      apply=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$target_home" ]] || { echo "--home is required" >&2; exit 2; }
[[ -n "$target_skills" ]] || { echo "--skills-dir must not be empty" >&2; exit 2; }

src_agents="$repo_root/codex/AGENTS.md"
src_config="$repo_root/codex/config/base.toml"
src_config_dir="$repo_root/codex/config"
src_skills="$repo_root/skills"

for required in "$src_agents" "$src_config" "$src_config_dir" "$src_skills"; do
  [[ -e "$required" ]] || { echo "missing source: $required" >&2; exit 1; }
done

show_file_action() {
  local src="$1"
  local dst="$2"
  if [[ ! -e "$dst" ]]; then
    echo "ADD       $dst"
  elif cmp -s "$src" "$dst"; then
    echo "UNCHANGED $dst"
  else
    echo "UPDATE    $dst"
    diff -u "$dst" "$src" || true
  fi
}

show_tree_action() {
  local src="$1"
  local dst="$2"
  if [[ ! -d "$dst" ]]; then
    echo "ADD TREE  $dst"
  elif diff -qr "$src" "$dst" >/dev/null; then
    echo "UNCHANGED $dst"
  else
    echo "UPDATE    $dst"
    diff -qr "$dst" "$src" || true
  fi
}

echo "Target CODEX_HOME: $target_home"
echo "Target user skills: $target_skills"
show_file_action "$src_agents" "$target_home/AGENTS.md"
show_file_action "$src_config" "$target_home/config.toml"

for profile in "$src_config_dir"/*.config.toml; do
  [[ -e "$profile" ]] || continue
  show_file_action "$profile" "$target_home/$(basename "$profile")"
done

show_tree_action "$src_skills" "$target_skills"
echo "PRESERVE  $target_home/auth.json"
echo "PRESERVE  runtime sessions/logs/state"

if [[ "$apply" -eq 0 ]]; then
  echo
  echo "Dry run only. Re-run with --apply to install."
  exit 0
fi

mkdir -p "$target_home"
install -m 0644 "$src_agents" "$target_home/AGENTS.md"
install -m 0644 "$src_config" "$target_home/config.toml"

for profile in "$src_config_dir"/*.config.toml; do
  [[ -e "$profile" ]] || continue
  install -m 0644 "$profile" "$target_home/$(basename "$profile")"
done

mkdir -p "$target_skills"
cp -a "$src_skills/." "$target_skills/"

echo "Installed LUCIDITY-managed Codex config into $target_home"
echo "Installed LUCIDITY personal skills into $target_skills"
