# agent-workflow

A reusable, agent-independent workflow for structured discovery, isolated implementation, independent review, and post-implementation debriefing.

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
packages/context/AGENTS.md                  Agent-neutral global-context template
packages/skills/interview/                  Discovery, approval, and handoff
packages/skills/implement/                  Implementation and review loop
packages/skills/debrief/                    Explanation and understanding check
packages/team/                              Agent-neutral role contracts
scripts/install-pi.sh                       Non-destructive Pi symlink installer
```

The shared skill and role instruction bodies describe host capabilities instead of vendor-specific commands, tool names, or configuration paths. Runtime-specific installation and metadata belong in host adapters.

## Current Pi adapter requirements

- [Pi coding agent](https://github.com/earendil-works/pi)
- `tmux`
- `uuidgen`
- Pi's official `subagent` example extension

The installer locates the extension through `npm root -g` or the standard Homebrew global npm location. Set `AGENT_WORKFLOW_PI_SUBAGENT_SOURCE` to override detection.

## Install for Pi

Inspect the installer, then run:

```sh
./scripts/install-pi.sh
```

It links the three skills into `~/.pi/agent/skills/`, the nine roles into `~/.pi/agent/agents/`, and Pi's official subagent extension into `~/.pi/agent/extensions/subagent/`. It refuses to replace an existing foreign file or link.

The global context template is intentionally not installed automatically. Review and merge it into your own context instead:

```sh
mkdir -p ~/.pi/agent
cp -n packages/context/AGENTS.md ~/.pi/agent/AGENTS.md
```

Do not commit a machine-generated memory index, credentials, private project context, session data, or absolute personal paths to a public fork.

## Use with Pi

Start Pi from the project you want to change and invoke:

```text
/skill:interview
```

After literal-keyword approval, the interview skill writes the approved specification and requests a host-native handoff to a fresh top-level agent session. The current Pi installer links the reusable assets; multi-host synchronization and concrete handoff adapters are intentionally separate work. Run `/skill:debrief` after completion when you want an explanation and adaptive knowledge check.

## Privacy model

This repository contains only reusable workflow instructions and runtime adapters. Personal memory, generated memory indexes, credentials, agent authentication and session state, and machine-specific configuration must remain outside the repository.

## License

No license has been selected yet. Public visibility alone does not grant permission to copy, modify, or redistribute the contents.
