---
name: interview
description: Run the full Agent Team discovery workflow, obtain literal-keyword approval, write an approved spec.md, and hand implementation to a fresh Pi session.
disable-model-invocation: true
---

# Interview

This skill runs only when the user explicitly invokes `/skill:interview`. Do not infer or automatically invoke it for ordinary requests.

Before interviewing, read [`references/agent-team-workflow.md`](references/agent-team-workflow.md) completely and follow it as the canonical detailed contract. It defines target activation, all six interview roles, delegation, agreement provenance, UX/UI and environment discovery, QA agreement, approval, specification output, handoff, implementation role separation, verification, review, retries, and Git safety.

## Required workflow

1. Start from Pi's current directory as the default target cwd. Canonicalize it, resolve the project/Git boundary and branch/worktree, and read applicable target context. Investigate another directory only when the request or inspected evidence indicates it is in scope. For greenfield work, agree on the future absolute project directory instead of treating the orchestration cwd as the project.
2. Run the proportional discovery workflow with only the relevant subset of the six fixed interview roles: Product Designer, UI Designer, Software Architect, Software Engineer, QA Engineer, and Research Analyst. Preserve their discovery-only permissions and the separate Feature Implementer, Implementation Reviewer, and Behavior Reviewer permissions described in the reference.
3. Ask one dependency-ordered customer decision at a time. Record explicit provenance for every agreed material decision. Establish intended outcome, material UX/UI, constraints, protected areas, environment readiness, agreed QA depth, and completion criteria.
4. Present the final concise summary and remind the customer that approval is valid only when the reply contains the literal word `승인`, for example `이 내용으로 승인해.` Broad continuation language is not approval.
5. Only after valid approval, write the self-contained approved specification at `<absolute-project-dir>/docs/plans/<feature-slug>/spec.md`. Retain outputs under `interview/`, `artifacts/`, or `prototypes/` only when useful, and index every supporting file's reading order from `spec.md`.
6. Validate the target directory, specification, and the `pi` and `tmux` executables, then launch implementation as a fresh interactive Pi session inside a detached tmux session. Derive the normalized tmux name as `impl-<work-directory-name>--<feature-slug>` and the Pi session name as `Implement: <feature-slug>`. Normalize the work-directory component to lowercase ASCII letters, digits, and hyphens; use the approved specification directory name as the feature slug. If the tmux name already exists, append a fresh six-character lowercase UUID prefix rather than reusing it:

```bash
tmux_name="impl-<normalized-work-directory-name>--<feature-slug>"
tmux has-session -t "$tmux_name" 2>/dev/null && \
  tmux_name="${tmux_name}-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-6)"
pi_session_name="Implement: <feature-slug>"
implementation_prompt="/skill:implement <absolute-spec-path>"
printf -v launch_command \
  'tmux set-option -w -t %q remain-on-exit on; exec pi --name %q %q' \
  "$tmux_name" "$pi_session_name" "$implementation_prompt"
tmux new-session -d -s "$tmux_name" -c <absolute-project-dir> "$launch_command"
```

Use shell-safe argument construction for all concrete values. `remain-on-exit` must preserve the pane after Pi exits so its final output and exit status remain inspectable. Check only for an immediate tmux or pane launch failure; do not wait for implementation to finish. Treat a dead pane with exit status zero as a fast successful completion, and a nonzero status as launch or implementation failure. On successful launch, show the specification's copyable absolute path, Pi session name, tmux session name, and these copyable commands without prescribing when to run them:

```bash
tmux attach -t <tmux-session-name>
tmux kill-session -t <tmux-session-name>
```

The attach command is the only supported way to observe or interact with the running implementation. Do not open the same Pi session concurrently with `pi --session` or `pi -r`; those commands start another Pi process and are only suitable for resuming the saved Pi session after the tmux-hosted Pi process has ended. Never implement in this interview session or fall back to same-session implementation. Keep the interview session available for the user to continue or close. Do not automatically delete the tmux session; leave cleanup to the provided command after inspection. If launch fails, preserve the specification and dead pane when available, report the tmux session and pane exit status, and return one copyable detached retry command using a fresh collision-free tmux name.
