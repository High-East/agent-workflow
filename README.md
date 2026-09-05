# agents

My agent setup: an agent-independent workflow for structured discovery, implementation, independent review, and post-implementation debriefing, synced to Claude Code and Codex. Other agent-related configuration (status line, memory tooling) will live here too.

The repository is the source of truth for global context and skills. [Rulesync](https://github.com/dyoshikawa/rulesync) generates the host-specific files consumed by Claude Code and Codex.

## Workflow

```text
explicitly invoke `interview`
  → approved docs/plans/<feature-slug>/spec.md
  → fresh top-level agent session
  → explicitly invoke `implement` with <absolute-spec-path>
  → isolated feature implementation attempts
  → implementation and behavior reviews
  → optionally invoke `debrief`
```

The workflow contains six discovery roles, one feature implementer, and two independent reviewers. Role prompts live under each skill's `references/` directory; skills spawn them through the host's native delegation mechanism, so no host-level subagent files are installed.

## Repository layout

```text
rules/                          Agent-neutral instructions and global context
skills/                         Reusable workflow skills
skills/interview/references/    Discovery role prompts
skills/implement/references/    Feature implementer and reviewer role prompts
rulesync.jsonc                  Claude Code and Codex generation config
package.json                    Pinned Rulesync commands and version
```

Edit `rules/` and `skills/` directly. `rulesync.jsonc` sets `inputRoots` to the repository root, so Rulesync consumes these directories without an adapter tree or duplicate source files.

Each `SKILL.md` carries its full workflow. Files under a skill's `references/` directory are role prompts that the skill hands to subagents when it delegates; they are not required reading for the skill itself.

## Install or update on a computer

Requirements:

- Node.js 22 or later and npm
- Claude Code, Codex, or both

Clone the repository, then run:

```sh
npm ci
npm run sync:dry-run
npm run sync
```

`sync:dry-run` shows the user-level files that would change. `sync` generates both feature groups for both hosts:

| Source | Claude Code | Codex |
| --- | --- | --- |
| `rules/` | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| `skills/` | `~/.claude/skills/` | `~/.agents/skills/` |

Run the same commands after pulling repository updates. `npm run sync:check` exits unsuccessfully when the installed files differ from the repository sources.

Rulesync is pinned exactly in `package.json` and `package-lock.json`. Upgrade it deliberately, review its release notes, regenerate in a temporary directory, and commit the version change only after both host outputs validate.

## Source conventions

- Shared instruction bodies remain agent-independent.
- Rulesync-only routing metadata stays in YAML frontmatter.
- Host-specific settings use `claudecode` and `codexcli` frontmatter blocks.
- Workflow skills are explicit-only on both hosts.
- Generated host files are deployment artifacts and are not committed here.

`delete` is disabled in `rulesync.jsonc`, so synchronization does not sweep unrelated files from host configuration directories. A generated file with the same name is still managed by this repository; always inspect `sync:dry-run` before the first installation or after renaming an item.

## Privacy model

This repository contains only reusable workflow instructions and synchronization configuration. Personal memory, generated memory indexes, credentials, authentication and session state, machine-specific paths, and private project context must remain outside the repository.

## License

No license has been selected yet. Public visibility alone does not grant permission to copy, modify, or redistribute the contents.
