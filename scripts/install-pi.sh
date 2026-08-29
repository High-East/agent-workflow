#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
pi_root="${PI_AGENT_HOME:-$HOME/.pi/agent}"

link_item() {
  local source=$1
  local target=$2

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      printf 'ok      %s\n' "$target"
      return
    fi
    printf 'refusing to replace foreign link: %s -> %s\n' "$target" "$current" >&2
    exit 1
  fi
  if [[ -e "$target" ]]; then
    printf 'refusing to replace existing path: %s\n' "$target" >&2
    exit 1
  fi

  ln -s "$source" "$target"
  printf 'linked  %s -> %s\n' "$target" "$source"
}

for command in pi tmux uuidgen; do
  command -v "$command" >/dev/null 2>&1 || {
    printf 'missing required command: %s\n' "$command" >&2
    exit 1
  }
done

subagent_source="${AGENT_WORKFLOW_PI_SUBAGENT_SOURCE:-}"
if [[ -z "$subagent_source" ]] && command -v npm >/dev/null 2>&1; then
  npm_candidate="$(npm root -g 2>/dev/null)/@earendil-works/pi-coding-agent/examples/extensions/subagent"
  [[ -d "$npm_candidate" ]] && subagent_source="$npm_candidate"
fi
if [[ -z "$subagent_source" ]]; then
  homebrew_candidate="/opt/homebrew/lib/node_modules/@earendil-works/pi-coding-agent/examples/extensions/subagent"
  [[ -d "$homebrew_candidate" ]] && subagent_source="$homebrew_candidate"
fi
if [[ -z "$subagent_source" || ! -f "$subagent_source/index.ts" || ! -f "$subagent_source/agents.ts" ]]; then
  printf 'cannot locate Pi subagent extension; set AGENT_WORKFLOW_PI_SUBAGENT_SOURCE\n' >&2
  exit 1
fi
subagent_source="$(cd "$subagent_source" && pwd -P)"

mkdir -p "$pi_root/skills" "$pi_root/agents" "$pi_root/extensions/subagent"

for skill in interview implement debrief; do
  source="$repo_root/packages/skills/$skill"
  [[ -f "$source/SKILL.md" ]] || {
    printf 'missing skill source: %s\n' "$source/SKILL.md" >&2
    exit 1
  }
  link_item "$source" "$pi_root/skills/$skill"
done

for role_source in "$repo_root"/packages/team/*.md; do
  link_item "$role_source" "$pi_root/agents/$(basename "$role_source")"
done

for extension_file in index.ts agents.ts; do
  link_item "$subagent_source/$extension_file" "$pi_root/extensions/subagent/$extension_file"
done

printf '\nInstalled reusable workflow assets.\n'
printf 'Global context was not changed; review packages/context/AGENTS.md manually.\n'
