---
name: implement
description: Implement an approved spec through fresh-context feature attempts, record durable implementation notes, and iterate until independent implementation and behavior reviews establish completion or the work is blocked.
---

# Implement

## Entry contract

Run this skill only when the user explicitly invokes it through the current agent host's skill mechanism with a user-supplied approved spec. Reject every other entry document.

Read the specification completely, then read every linked document in its explicit stated order. The specification remains the highest-priority contract. Confirm:

- specification state is `ready` and approval is recorded as `yes` with provenance (never implement `blocked`, draft, or unapproved work),
- the specification's absolute target root and target cwd exist and match the intended project rather than the orchestration session's startup directory,
- canonical worktree and current branch match the specification when Git applies,
- applicable project instruction files, such as `AGENTS.md` or `CLAUDE.md`, from target root through target cwd are reread and match the specification's selected context and scope,
- linked documents exist and do not conflict with the specification or its declared priority and reading order,
- no unresolved blocker, security risk, data-loss risk, or high-impact unknown remains,
- existing dirty changes are identified and will not be reset, overwritten, staged, or committed accidentally.

Record the revalidated target root, target cwd, worktree/branch, selected context paths, scope, and context generation in implementation/review packets. Bind commands and subagents to the validated target root and use explicit paths for narrower scopes; the orchestration session's startup directory is never authoritative.

If target or repository metadata is stale, locate it and ask before changing the approved contract. If applicable context drift materially changes requirements, architecture, protected areas, safety, or acceptance criteria, stop for reconciliation rather than silently refreshing the approved contract. For greenfield work, use the absolute project directory approved in the specification; never substitute the orchestration cwd.

## Implementation notes

Before product edits, create or initialize `implementation-notes.md` beside the specification without erasing prior history. Include:

```md
# Implementation Notes

Status: Implementing
Iteration: 1
Current Feature: 1
Current Attempt: 1

## Features
## Decisions
## New Unknowns
## Specification Deviations
## Files Changed
## Verification
## Failure Evidence
## Repeated-Issue Analysis
## Residual Risks
```

Record decisions, newly discovered unknowns, deviations, files, and verification throughout. Minor local deviations may proceed conservatively and must be recorded. Stop for approval if a deviation changes user-visible outcomes, requirements, protected areas, architecture, security posture, or data-loss risk. Mark `Status: Blocked` and explain the next action.

## Fresh-context feature loop

Before product edits, divide the approved work into independent features when that improves feedback or context control. Each feature must produce a coherent result that can be exercised and verified on its own, crossing UI, API, data, infrastructure, or other layers as needed; do not define features as layer-only batches. Use the fewest features that preserve coherent outcomes and useful feedback. Simple work may remain one feature, while complex work has no fixed feature limit. When many features are needed, group them under named execution phases in the notes for navigation and resumption rather than combining unrelated outcomes to satisfy a numeric cap. Record each feature, its dependencies, approved criteria, focused verification, and completion state in the notes.

The lead orchestrates but does not make product or test edits. Every feature attempt, including the first attempt and each retry, must be a separate single invocation of the shared-scope `feature-implementer` subagent through the current agent host's native delegation mechanism, with `cwd` set to the validated target root. Never resume or chain from an earlier feature-attempt session, pass prior conversational output as hidden context, or treat main-context compaction as equivalent isolation. The fresh subagent invocation itself is the isolation boundary.

Before each attempt, the lead writes all durable state needed for independent resumption to `implementation-notes.md`. Give the feature implementer a packet containing:

- feature ID, attempt number, dependencies, scoped paths, approved criteria, and focused verification commands;
- target root/cwd, repository/worktree/branch, selected context paths and generation, protected areas, and dirty baseline;
- absolute specification, linked-document, and notes paths plus the current diff scope;
- for retries only, concise failure evidence and any recorded root-cause analysis;
- allowed mutations and explicit prohibitions on specification/notes edits, unrelated files, Git state changes, commits, destructive/live operations, delegation, and invoking this skill.

For each feature:

1. Revalidate the target and record the feature and attempt in notes.
2. Invoke a fresh `feature-implementer` to inspect relevant behavior, make one coherent scoped change, and run the delegated focused verification.
3. Inspect the resulting diff and evidence; immediately record changed files, decisions, exact commands/results, failures, and the next action in notes rather than relying on the subagent response as memory.
4. Mark the feature complete only when its focused criteria pass, then start the next dependency-ready feature with another fresh invocation.

Do not start a new feature while the current one has an unexplained material failure. A feature has at most three attempts: one initial attempt and two fresh-context retries. If the same material issue appears twice, record root-cause analysis before the final attempt. Stop earlier when another attempt would repeat an ineffective strategy, increase risk disproportionately, require a contract change, or lack a credible path to success. A missing or failed required feature implementer is a blocker; the lead must not impersonate it.

Run the full integration or E2E suite primarily once after all features pass and before mandatory review, then once after any integrated corrective pass. Run it at another point only when the approved specification requires it or focused verification cannot establish a material criterion.

## Build and verify

1. Inspect before choosing an approach.
2. Make only scoped changes required by the specification.
3. Run the specification's verification plus focused checks.
4. Match verification depth to impact, reversibility, and credible failure cost. Test materially distinct failure classes that could invalidate an approved core outcome or safety claim. Once core acceptance, runtime health, data preservation, and any approved representative migration/rollback pass succeed, treat additional hypothetical failure injection and rollback variants as hardening unless a concrete material failure mechanism remains.
5. Update notes with exact commands and results.
6. Do not rerun an already-passing expensive verification against the same code state. After a correction, run focused checks for the affected area first; run the full integration verification exactly once after the corrective pass.
7. Do not stage or commit unrelated dirty changes.

## Tool and context discipline

Keep model turns and retained context proportional to the work:

- Follow a narrowing discovery funnel instead of recursively reading the repository:
  1. Establish the relevant structure with `rg --files` first because it is fast and ignore-aware. Constrain it by approved directories, globs, and file types. Use `find` for shallow directory topology, path metadata, or files intentionally outside ignore rules; exclude dependency, build, cache, and VCS directories.
  2. When a symbol, route, filename, configuration key, or literal is known, use `rg` as the default content search. Search definitions and references, then narrow by path and type. Use `grep` only as a fallback, for a single known file, or to filter streamed command output.
  3. When the exact name or location is unknown in unfamiliar brownfield code, use `semble search` with a concrete behavior or responsibility query and an explicit target path. Keep result and snippet counts small. After finding a strong anchor, use `semble find-related` only when analogous implementations or neighboring behavior would materially clarify the change.
  4. Treat Semble output and search snippets as candidates, never as edit evidence. Confirm selected definitions, callers, boundaries, configuration, and adjacent tests with direct file reads and exact `rg` or `grep` searches before choosing an approach or editing.
  5. Stop broad discovery once the implementation path, affected callers and boundaries, existing conventions, and relevant tests are sufficiently established. Expand only to resolve a concrete unknown or credible impact.
- Batch independent structure searches, exact searches, targeted reads, and environment probes in parallel. Read narrowly after search rather than loading unrelated whole files.
- Batch all known changes to one file into one coherent edit operation when the host supports it. Create repeated fixtures, manifests, or boilerplate with a deterministic generator when that is clearer and safer than many individual writes. Use structural rewrite tools only for genuinely repeated syntax-aware changes.
- Redirect long build and test output to a temporary log or durable specification artifact. Return only the exit status, pass/fail counts, first actionable failure, relevant file/line locations, and roughly the final 30–80 useful lines. Do not place complete successful logs in context.
- At a feature boundary, make notes sufficient for a fresh implementer with no conversation history. Main-context compaction may still reduce orchestration context, but it never replaces the required fresh subagent invocation for every feature attempt.
- Do not resume implementation, review, or verification after `Pass`/`Complete` without a code change, an observed failure, a concrete material risk, or an explicit user request.

## Mandatory independent review loop

Implementation reviewers are separate from the discovery team. Use the shared-scope reviewer definitions supplied with this workflow through the current agent host's native delegation mechanism, never project-local overrides by default. Both dedicated roles are required and read-only: reviewers must not modify files, Git state, dependencies, external services, or perform the implementation.

1. Ask `implementation-reviewer` to judge approved-specification compliance, implementation completeness, diff safety, brownfield compatibility, maintainability, and concrete code-level risks.
2. Ask `behavior-reviewer` to judge approved acceptance criteria, agreed test results, material runtime behavior, regressions, failure states, and data preservation.
3. Give each reviewer the specification, linked canonical documents, notes, relevant diff, commands/results, target root/cwd, scoped paths, selected context paths and generation, repository/worktree, branch, agreed QA depth, and explicit prohibited actions in a context packet. Run each with `cwd` set to the validated target root.
4. Require each finding to be classified as `Blocking`, `Required`, `Follow-up`, or `Observation`. Reviewers may not introduce new acceptance criteria, revisit discovery decisions, or expand the approved scope.
5. Save verbatim structured reviews under `reviews/NNN-implementation-reviewer.md` and `reviews/NNN-behavior-reviewer.md` beside the specification.
6. Wait for both reviews, then integrate and deduplicate their findings. Combine all substantiated `Blocking` and `Required` findings into one corrective feature packet and invoke a fresh `feature-implementer`; do not let the lead edit product code or start a separate fix loop for each reviewer.
7. The main agent maps findings back to the approved contract. `Blocking` and `Required` apply only to an observed defect or concrete credible mechanism that materially undermines approved behavior, security, data integrity, migration completeness, recoverability, runtime operability, implementation completeness, or the required quality bar. The finding must name the affected approved criterion and explain why existing evidence does not establish it. “Not exhaustively reviewed or tested” is insufficient.
8. Record supplemental failure injection, additional rollback variants, hardening, broader coverage, reproducibility, evidence formatting, and hypothetical edge cases as `Follow-up` once core acceptance and material safety evidence pass. Follow-up/Observation-only reviews permit completion and must not produce `Needs Changes`.
9. Evidence-only findings may receive at most one corrective pass. They cannot reopen a completed review without new evidence of an observed failure, concrete material risk, or unmet explicitly approved core criterion. Do not repeat destructive or live-system verification solely to improve confidence.
10. After the integrated corrective pass and final integration verification, rerun only a reviewer whose finding caused a change or whose prior evidence was invalidated by that change. A still-valid `OK` verdict does not need repetition. Any product-code change is presumed to affect the behavior review unless the lead records why observable behavior and its evidence are unchanged.
11. Use this default execution budget: up to three fresh-context attempts per feature, one parallel review pass, one fresh-context integrated corrective attempt, one final integration verification, and only the affected final re-reviews. Exceed the corrective budget only for an explicitly identified unresolved material safety/outcome defect or with user authorization; three corrective iterations remain an absolute ceiling, not a target.
12. If the same material issue appears twice, analyze its root cause in notes before another fresh-context attempt.
13. Any required reviewer failure, observed or concretely substantiated security/data-loss concern, incomplete migration, unrecoverable live state, or material requirement/architecture change stops immediately.

After a destructive migration, production cutover, quarantine, or deletion gate completes, pause automatic iteration. Reviewers default to read-only inspection, and further live mutation requires a demonstrated material defect. Report achieved outcomes, runtime health, residual risks, and non-blocking follow-ups.

Do not let the main agent impersonate a missing required feature implementer or reviewer.

## Completion

Implementation is complete when the approved user-visible outcome and core acceptance criteria are satisfied, required verification passes, and no unresolved material security, data-loss, migration, recoverability, or operability risk remains. Identical `OK` verdicts are not required; non-material findings become residual risks or follow-up work.

Set notes to `Status: Complete`, including final verification, review links, residual risks, and deferred follow-ups. Summarize changed files, verification, material review findings, and risks. Offer the `debrief` skill, but never run it automatically.

Follow applicable global and project Git instructions. Commit only the completed scoped change after required verification passes; never include unrelated dirty work.
