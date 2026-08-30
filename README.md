# agent-workflow

A reusable, agent-independent workflow for structured discovery, isolated implementation, independent review, and post-implementation debriefing.

The repository is the source of truth for global context, skills, and subagents. [Rulesync](https://github.com/dyoshikawa/rulesync) generates the host-specific files consumed by Claude Code and Codex.

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

The workflow contains six discovery roles, one feature implementer, and two independent reviewers.

## Repository layout

```text
rules/                          Agent-neutral instructions and global context
skills/                         Reusable workflow skills
subagents/                      Discovery, implementation, and review roles
rulesync.jsonc                  Claude Code and Codex generation config
package.json                    Pinned Rulesync commands and version
```

Edit `rules/`, `skills/`, and `subagents/` directly. `rulesync.jsonc` sets `inputRoots` to the repository root, so Rulesync consumes these directories without an adapter tree or duplicate source files.

The `interview` skill is self-contained. Its detailed workflow is embedded directly in `skills/interview/SKILL.md`, so invoking the skill does not require another reference-file read.

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

`sync:dry-run` shows the user-level files that would change. `sync` generates all three feature groups for both hosts:

| Source | Claude Code | Codex |
| --- | --- | --- |
| `rules/` | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| `skills/` | `~/.claude/skills/` | `~/.agents/skills/` |
| `subagents/` | `~/.claude/agents/` | `~/.codex/agents/` |

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
