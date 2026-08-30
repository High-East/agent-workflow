---
name: interview
description: Run the full Agent Team discovery workflow, obtain literal-keyword approval, write an approved spec.md, and hand implementation to a fresh agent session.
---

# Interview

Run this skill only when the user explicitly invokes it through the current agent host's skill mechanism. Do not infer or automatically invoke it for ordinary requests.

Before interviewing, read [`references/agent-team-workflow.md`](references/agent-team-workflow.md) completely and follow it as the canonical detailed contract. It defines target activation, all six interview roles, delegation, agreement provenance, UX/UI and environment discovery, QA agreement, approval, specification output, handoff, implementation role separation, verification, review, retries, and Git safety.

## Required workflow

1. Start from the current agent session's working directory as the default target cwd. Canonicalize it, resolve the project/Git boundary and branch/worktree, and read applicable target context. Investigate another directory only when the request or inspected evidence indicates it is in scope. For greenfield work, agree on the future absolute project directory instead of treating the orchestration cwd as the project.
2. Through the current agent host's native delegation mechanism, run the proportional discovery workflow with only the relevant subset of the six fixed interview roles: Product Designer, UI Designer, Software Architect, Software Engineer, QA Engineer, and Research Analyst. Preserve their discovery-only permissions and the separate Feature Implementer, Implementation Reviewer, and Behavior Reviewer permissions described in the reference.
3. Ask one dependency-ordered customer decision at a time. Record explicit provenance for every agreed material decision. Establish intended outcome, material UX/UI, constraints, protected areas, environment readiness, agreed QA depth, and completion criteria.
4. Present the final concise summary and remind the customer that approval is valid only when the reply contains the literal word `승인`, for example `이 내용으로 승인해.` Broad continuation language is not approval.
5. Only after valid approval, write the self-contained approved specification at `<absolute-project-dir>/docs/plans/<feature-slug>/spec.md`. Retain outputs under `interview/`, `artifacts/`, or `prototypes/` only when useful, and index every supporting file's reading order from `spec.md`.
6. Validate the target directory, specification, and the current agent host's fresh-session handoff capability. Launch a fresh top-level agent session rooted at the approved project directory and explicitly invoke the `implement` skill with the specification's absolute path. Use the host's native session naming, observation, resume, and termination controls; use `Implement: <feature-slug>` as the session name when naming is supported. Never implement in this interview session or fall back to same-session implementation. On success, show the specification path, session identity, and any copyable observation or cleanup commands. If the host cannot launch a fresh top-level session programmatically, preserve the specification and return the exact working directory plus a copyable host-native launch command or prompt; report the handoff as blocked until that session starts.
