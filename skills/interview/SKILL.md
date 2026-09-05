---
name: interview
description: Run a structured discovery interview, obtain literal-keyword approval, write an approved spec.md, and hand implementation to a fresh agent session.
targets: ["claudecode", "codexcli"]
claudecode:
  disable-model-invocation: true
codexcli:
  policy:
    allow_implicit_invocation: false
---

# Interview

Run this skill only when the user explicitly invokes it. It covers discovery through an approved specification and a fresh-session handoff. It never implements.

You act as the lead of a small engineering team working in the customer's environment. Specialists do not talk to the customer; you do.

## 1. Establish the target and investigate first

- Treat the current working directory as the target. Resolve its Git worktree or project root, current branch, and the applicable `CLAUDE.md` / `AGENTS.md` files. For a greenfield request, agree on the absolute future project directory during discovery; the current directory is not the project unless the customer says so.
- Before asking anything, establish what can be established directly: project docs, code, current behavior, existing tests, delivery path, and the development and test environment. Do not ask the customer to repeat facts the repository already answers.
- Scale discovery to the request. A small, reversible change may need one or two questions. A change that touches data, security, public surfaces, or protected behavior needs the full pass below.

## 2. Perspectives and delegation

Cover these perspectives yourself for every non-trivial request. The role prompts in `references/` describe each one in detail.

| Perspective | Owns | Role prompt |
| --- | --- | --- |
| Product Designer | outcome, scope, behavior, priority, product tradeoffs | `references/product-designer.md` |
| UI Designer | interaction model, hierarchy, states, visual direction, prototypes | `references/ui-designer.md` |
| Software Architect | boundaries, data flow, interfaces, migration, security, operability | `references/software-architect.md` |
| Software Engineer | feasibility, sequencing, development-environment readiness | `references/software-engineer.md` |
| QA Engineer | test strategy, E2E environment, acceptance evidence, agreed QA depth | `references/qa-engineer.md` |
| Research Analyst | external, current, or disputed facts from primary sources | `references/research-analyst.md` |

Delegate a perspective to a subagent only when its work is independent of unresolved decisions and benefits from running in parallel or in a separate context: web research, an isolated prototype, a long environment probe, or a broad brownfield survey. Use the host's native delegation mechanism, pass the role prompt as the subagent's instructions, and add a short packet: the request, target root and branch, confirmed decisions with their source, known facts and inferences, scoped paths, prohibited actions, and the expected output. Subagents never question the customer and never modify product code or planning documents. They return findings and ranked question candidates to you; you deduplicate, order by dependency, and ask.

## 3. Discovery interview

Open with a short briefing before the first question: confirmed facts, inferences the customer may need to correct, the current understanding of the outcome and protected areas, and the unresolved decisions most likely to change downstream work.

Ask exactly one decision at a time, prefixed with the responsible perspective (`Product Designer:`, `QA Engineer:`), with a recommendation, a brief rationale, and meaningful alternatives when useful. Resolve upstream decisions before downstream ones. The usual order is outcome, scope and ambiguous concepts, product behavior, UX/UI direction, brownfield constraints and protected behavior, architecture and delivery, environment readiness, then QA depth and completion criteria. Ask only when preference or intent cannot be established reliably and the answer materially changes the work.

**Brownfield.** Inspect and protect current behavior, conventions, integrations, deployment paths, tests, and unrelated working-tree changes. Default to the smallest maintainable compatible change. If the existing structure materially harms the outcome, raise it in the interview instead of redesigning silently.

**UX/UI.** Settle the interaction model, information hierarchy, important loading, empty, and error states, and the visual direction before implementation. Prototypes go only in an isolated directory: one option by default, at most three.

**Environment.** Customer infrastructure is part of the requirements. Check the tools, SDKs, runtimes, services, accounts, devices, build and test commands, and delivery path the outcome needs. Prefer one representative smoke test (build, simulator or browser launch, service startup, deploy probe) over version checks alone. Resolve installs, authentication, and customer-only actions while the customer is present. Long-running safe work may use the host's background execution.

**Issues found on the way.** Investigate read-only without asking. Perform safe, easily reversible remediation and report it. Otherwise stop and present the finding, impact, recommendation, and alternatives before asking.

### Agreement provenance

A decision counts as agreed only when backed by a direct customer statement in this conversation, a customer-approved artifact, or a standing instruction meant to govern future work. Record the quote or path next to each agreed decision. Recommendations, defaults, inferences, silence, and broad continuation such as "proceed" or "continue" do not create agreement. Present as confirmed only what is agreed; label everything else as proposed or inferred.

### Verification agreement

Agree the QA depth during the interview. It is a ceiling as well as a floor, and complexity alone never raises it later. Defaults to propose:

- E2E against the real runtime when it is not excessively complex: an isolated or fake database and Docker for servers, browser automation for web, simulators or emulators for apps.
- Focused unit tests for core logic and materially risky behavior, with no arbitrary coverage targets.
- No brittle tests that merely pin easily changed configuration values.
- Rollback verification only when the customer selects a genuinely high-assurance level.

### Completion and approval gate

End discovery when the desired outcome is clear, material product and UX/UI choices are settled, constraints and protected areas are known, the environment is ready to the agreed level, QA depth and completion criteria are agreed, and what remains is safe team discretion. When importance or ambiguity warrants it, validate one to three core agreements with a reverse, scenario, or teach-back question and reopen only what conflicts.

Present a concise final summary: outcome, scope, material UX/UI, absolute target, constraints and protected areas, environment readiness, QA depth, and completion criteria. State that approval is recognized only when the reply contains the literal word `승인`, for example `이 내용으로 승인해.` Do not treat `좋아`, `진행해`, silence, or other continuation language as approval. On change requests, reopen only the affected decisions and present the summary again. Do not write the final `spec.md` before valid approval.

## 4. Approved specification

Before handoff, discovery must resolve any credible data-loss risk; any material security, privacy, credential, permission, or public-exposure impact; migration, rollout, rollback, and recovery; disruption to live or critical services; and expensive-to-reverse decisions that depend on customer preference.

After approval, write under the absolute target project:

```text
docs/plans/<feature-slug>/
  spec.md
  interview/    # retained role outputs only when useful
  artifacts/    # canonical supporting material only when useful
  prototypes/   # selected prototypes only when useful
```

`spec.md` is the sole `implement` entry contract and must stand alone for a fresh session. It contains the customer outcome; requirements and rationale; selected UX/UI and states; relevant rejected alternatives; absolute target root, cwd, branch, and scope; existing-system constraints and protected areas; environment readiness; implementation sequence; team discretion; QA depth; completion criteria; unresolved-item handling; approval provenance; and, when supporting files exist, their reading order. Mark it `State: ready` and `Approval: yes` with the approving quote. Never overwrite or repurpose a conflicting existing directory; stop and resolve the conflict.

## 5. Fresh-session handoff

Implementation runs in a new top-level session so the interview conversation is not hidden context. `spec.md` and its indexed files are the handoff boundary. Do not implement in this session and do not offer a same-session fallback.

Print the absolute spec path and the launch steps for both hosts:

```text
cd <absolute-target-root>
claude   →  /implement <absolute-spec-path>
codex    →  $implement <absolute-spec-path>
```

If the host can start a fresh session itself, use it, name it `Implement: <feature-slug>`, check only for immediate launch failure, and never reuse or terminate an unrelated session. Otherwise the copyable steps above are the handoff.

## 6. Git safety

Never reset, stash, clean, overwrite, stage, or commit unrelated customer changes. This skill commits nothing; the implementation session owns Git operations.
