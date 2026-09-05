---
name: implement
description: Implement an approved spec, keep durable implementation notes, and iterate until independent implementation and behavior reviews establish completion or the work is blocked.
targets: ["claudecode", "codexcli"]
claudecode:
  disable-model-invocation: true
codexcli:
  interface:
    display_name: "Implement"
    short_description: "Implement an approved spec with review loops and run tracking."
    default_prompt: "Use $implement to build the approved specification and iterate until both reviews pass."
  policy:
    allow_implicit_invocation: false
---

# Implement

Run this skill only when the user explicitly invokes it with the path of an approved `spec.md`. Reject any other entry document.

## 1. Entry contract

Read the specification completely, then every linked document in its stated order. The specification is the highest-priority contract. Confirm before editing:

- `State: ready` and `Approval: yes` with provenance. Never implement draft, blocked, or unapproved work.
- The absolute target root and cwd exist and match the intended project, not merely the session's startup directory. Worktree and branch match when Git applies.
- Applicable `CLAUDE.md` / `AGENTS.md` files from target root through cwd are reread and consistent with the specification.
- Linked documents exist and do not conflict with the specification.
- No unresolved blocker, security risk, data-loss risk, or high-impact unknown remains.
- Existing dirty changes are identified and will not be reset, overwritten, staged, or committed.

If target metadata is stale, locate the right target and ask before changing the contract. If context drift materially changes requirements, architecture, protected areas, safety, or acceptance criteria, stop for reconciliation rather than silently refreshing the contract.

## 2. Implementation notes

Before product edits, create or extend `implementation-notes.md` beside the specification without erasing history:

```md
# Implementation Notes

Status: Implementing
Current Feature: 1
Current Attempt: 1

## Features
## Decisions
## New Unknowns
## Specification Deviations
## Files Changed
## Verification
## Failure Evidence
## Residual Risks
```

Update it at every feature boundary and after every review so a fresh session could resume from the notes alone. Minor local deviations may proceed conservatively and must be recorded. A deviation that changes user-visible outcomes, requirements, protected areas, architecture, security posture, or data-loss risk stops the work: set `Status: Blocked` and state the next action.

## 3. Features and implementation mode

Divide the approved work into features when that improves feedback or context control. Each feature is a coherent, independently verifiable outcome that crosses UI, API, data, and infrastructure layers as needed; never a layer-only batch. Simple work stays one feature. Record each feature, its dependencies, approved criteria, focused verification, and state in the notes.

Implement directly by default. Delegate a feature to a fresh `feature-implementer` subagent, using `references/feature-implementer.md` as its instructions, when:

- the work spans many features or phases and isolating each attempt's context keeps the orchestration session lean, or
- a feature is being retried after a failed attempt, where a fresh context re-evaluates the failure instead of repeating it, or
- reviewers returned `Blocking` or `Required` findings and the corrective pass benefits from an independent read of the diff.

A delegated attempt receives a packet: feature ID and attempt number, dependencies, scoped paths, approved criteria, focused verification commands, target root and branch, protected areas and dirty baseline, absolute paths of the specification, linked documents, and notes, and, for retries, concise failure evidence and root-cause analysis. It may not edit the specification or notes, touch unrelated files, change Git state, run destructive or live operations, delegate further, or invoke this skill. Record its result in the notes immediately; do not rely on the subagent response as memory.

A feature has at most three attempts. If the same material issue appears twice, write a root-cause analysis in the notes before the final attempt. Stop earlier when another attempt would repeat an ineffective strategy, raise risk disproportionately, require a contract change, or lack a credible path to success. Do not start a new feature while the current one has an unexplained material failure.

## 4. Customer re-contact

Internal implementation details are team discretion: do not ask the customer to choose class structure, file layout, routine refactoring, or test mechanics. After discovery, re-contact the customer only when:

- the agreed user-visible outcome or scope must change;
- a new material data, security, privacy, permission, public-exposure, or cost impact appears;
- a protected existing-system boundary must move;
- an expensive-to-reverse choice depends on customer preference;
- customer-only action or authorization is unavoidable.

Investigate first, then present the finding, impact, recommendation, and alternatives with the question.

## 5. Build and verify

1. Inspect the relevant code and tests before choosing an approach. When available, a concept-search tool such as Semble may locate candidates in unfamiliar brownfield code; confirm every candidate with direct reads before editing.
2. Make only the scoped changes the specification requires. Preserve protected behavior and unrelated dirty changes.
3. Run the specification's verification plus focused checks for the affected area. Run the full integration or E2E suite once after all features pass and once after any corrective pass; run it elsewhere only when the specification requires it or focused checks cannot establish a material criterion.
4. Match verification depth to the agreed QA level. It is a ceiling as well as a floor: once core acceptance, runtime health, data preservation, and any agreed migration or rollback pass succeed, further failure injection and rollback variants are hardening, not requirements.
5. Do not rerun an already-passing expensive verification against the same code state.
6. Redirect long build and test output to a log and keep only the exit status, pass/fail counts, the first actionable failure, and the relevant tail in context. Record exact commands and results in the notes.

## 6. Independent review

After all features pass and the integration verification succeeds, run two read-only reviewers in parallel through the host's native delegation mechanism, using the host's read-only agent type where one exists (Claude Code `Explore`, Codex `explorer` or a read-only sandbox):

- **Implementation Reviewer** (`references/implementation-reviewer.md`): specification compliance, completeness, diff safety, brownfield compatibility, maintainability, concrete code-level risk.
- **Behavior Reviewer** (`references/behavior-reviewer.md`): acceptance criteria, agreed tests, E2E and runtime behavior, regressions, failure states, data preservation.

Each receives the specification, linked documents, notes, the relevant diff, commands and results, target root and branch, scoped paths, the agreed QA depth, and explicit prohibited actions. Reviewers never modify files, Git state, dependencies, or external services, and never introduce acceptance criteria, reopen discovery decisions, or expand scope.

Save each review verbatim as `reviews/NNN-implementation-reviewer.md` and `reviews/NNN-behavior-reviewer.md` beside the specification.

**Findings.** Every finding is `Blocking`, `Required`, `Follow-up`, or `Observation`. `Blocking` and `Required` need an observed defect or a concrete, credible mechanism that materially undermines approved behavior, security, data integrity, migration completeness, recoverability, runtime operability, or implementation completeness, naming the affected criterion and why existing evidence does not establish it. Hardening, broader coverage, hypothetical edge cases, reproducibility, and evidence formatting are `Follow-up`. "Not exhaustively reviewed or tested" is never `Required`. Follow-up and Observation-only reviews permit completion.

**Corrective pass.** Merge all substantiated `Blocking` and `Required` findings from both reviewers into one corrective pass; do not run a separate fix loop per reviewer. After it and the final integration verification, rerun only a reviewer whose finding caused a change or whose evidence the change invalidated. Any product-code change is presumed to affect the behavior review unless the notes record why observable behavior and its evidence are unchanged. One corrective pass is the default budget; three is the absolute ceiling, and exceeding one needs an identified unresolved material defect or user authorization. Evidence-only findings get at most one corrective pass and cannot reopen a completed review without new evidence.

**Stop immediately** on an observed or concretely substantiated security or data-loss concern, an incomplete migration, unrecoverable live state, or a material requirement or architecture change. After a destructive migration, production cutover, or deletion gate completes, pause automatic iteration and report before any further live mutation.

## 7. Completion

The work is complete when the approved user-visible outcome and core acceptance criteria are satisfied, required verification passes, and no unresolved material security, data-loss, migration, recoverability, or operability risk remains. Identical `OK` verdicts are not required; non-material findings become residual risks or follow-ups.

Set the notes to `Status: Complete` with final verification, review links, residual risks, and deferred follow-ups. Report briefly: changed files, verification, material review findings, risks, and how the customer can try the result. Offer the `debrief` skill; never run it automatically.

Follow the applicable global and project Git instructions. Commit only the completed scoped change after required verification passes, and never include unrelated dirty work.
