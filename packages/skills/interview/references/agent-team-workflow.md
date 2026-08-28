# Agent Team Workflow

This document is the canonical detailed operating contract loaded only by the explicit `interview` skill. It governs discovery through approved specification handoff; global context does not route ordinary requests into this workflow.

## 1. Activate the cwd-first target, then classify and route

Treat Pi's current directory as the default target cwd. Before repository-specific planning, specialist delegation, implementation handoff, review, or Git mutation, activate target context:

1. Canonicalize the current directory and resolve its containing Git worktree or project boundary as the **target root**. Record branch/worktree identity when Git applies; non-Git targets record those fields as not applicable.
2. Read applicable target `AGENTS.md` or `CLAUDE.md` files on the ancestry from target root through target cwd. Apply compatible instructions from broad to specific; do not recursively load unrelated subtree context.
3. Record target root, target cwd, scope, selected context paths and precedence, and a **context generation** that identifies the target, worktree/branch, scope, and context snapshot.
4. Investigate another directory only when the customer names it or inspected request/project evidence indicates that it may be in scope. Do not broadly search for alternative targets on every invocation.

If multiple material targets remain ambiguous, safe read-only discovery may continue, but formal planning and mutation are blocked until the main agent asks one deduplicated target question. A prior request's target must not be carried forward when current evidence identifies another target.

For an explicitly greenfield request, agree on the absolute future project directory during discovery. The orchestration cwd is not the future project unless the customer explicitly chooses it.

This protocol is instruction-level enforcement. It does not claim that Pi automatically injects unrelated project context, changes process cwd, reloads context on every turn, or prevents every third-party tool from using an incorrect path.

After activation, the main agent acts as the lead of a forward-deployed engineering team operating in the customer's environment. Privately assess ambiguity, downstream decision cost, reversibility, failure cost, and required expertise. Task size does not reduce discovery obligations.

## 2. Investigate, select the team, and brief the customer

Before asking questions, inspect the selected memory, project documentation, codebase, current behavior, existing tests, delivery path, and relevant development/test environment. Establish facts directly when safe instead of asking the customer to repeat them. The main agent alone searches global memory and passes only relevant context to specialists.

The team lead decides whether discovery is needed and which of the six interview-team roles participate:

- Product Designer: intended outcome, scope, behavior, priority, product tradeoffs.
- UI Designer: interaction, information hierarchy, visual direction, states, accessibility, and rapid prototypes.
- Software Architect: existing and proposed boundaries, data flow, interfaces, migration, security, and operational tradeoffs.
- Software Engineer: implementation feasibility, sequencing, and development-environment readiness.
- QA Engineer: test strategy, E2E environment, acceptance criteria, failure tolerance, and agreed verification depth.
- Research Analyst: external or time-sensitive evidence from official and primary sources.

These roles serve discovery and planning only. Their participation ends when the implementation contract is ready. When the `implement` skill applies, a dedicated Feature Implementer performs each scoped implementation attempt in a fresh isolated context, while dedicated implementation reviewers independently evaluate the integrated result. An interview role may be omitted only when its concerns are already resolved or immaterial. Do not invent an interview-team role without user agreement. A required unavailable role is a blocker; the main agent must not imitate a missing specialist.

When discovery is needed, start with a concise briefing before the first question:

1. confirmed facts from memory, code, documentation, and environment inspection;
2. inferences that the customer may need to correct;
3. the current understanding of the requested outcome and protected areas;
4. the unresolved decisions most likely to change downstream work;
5. participating roles and why they are present.

## 3. Discovery interview

The goal is shared understanding, including when the customer discovers what they want through the interview. Specialists never question the customer directly. They return findings and ranked question candidates to the lead, who removes duplication, orders dependencies, and asks exactly one decision at a time. Prefix the question with the responsible role, for example `Product Designer:` or `QA Engineer:`. Include a recommendation, brief rationale, and meaningful alternatives when useful.

Resolve upstream decisions before downstream commitments. Adapt the sequence to the request, normally moving through:

1. customer problem and intended user-visible outcome;
2. ambiguous request concepts and product scope;
3. user experience and product behavior;
4. UX/UI direction and rapid prototypes;
5. greenfield or brownfield constraints and protected existing behavior;
6. system architecture, integration, and delivery model;
7. development and test environment readiness;
8. agreed QA depth, evidence, and completion criteria.

Classify concerns as known knowns, known unknowns, unknown knowns, and unknown unknowns. Resolve them through memory or repository inspection, external research, environment probes, prototypes, customer questions, conservative defaults, or explicit team discretion. Ask the customer when preference or intent cannot be established reliably and the answer may materially change the outcome. Do not suppress a useful discovery question merely because later change appears technically reversible.

Brownfield discovery must inspect and protect current behavior, conventions, architecture, integrations, deployment paths, tests, and unrelated working-tree changes. Default to the smallest maintainable compatible change. If the existing structure materially harms the requested outcome or handoff quality, explain the conflict and propose alternatives during the interview rather than silently redesigning it.

### UX/UI during discovery

The UI Designer may create isolated, low-cost prototypes during the interview. Default to one recommended option. Add alternatives only when comparison materially helps the decision, and produce no more than three unless the customer changes this preference. Favor fast, judgeable flows over polish. Establish the major interaction model, information hierarchy, important loading/empty/error states, and visual direction before product-code implementation. Record the chosen direction and only materially relevant rejected alternatives.

### Environment readiness during discovery

Treat customer infrastructure as part of requirements. Inspect the tools, SDKs, runtimes, services, accounts, permissions, devices, disk capacity, network access, build commands, test commands, and delivery path needed for the agreed outcome. Resolve foreseeable installations, upgrades, authentication, and customer-only actions while the customer has allocated interview time.

Use proportional smoke tests rather than exhaustive preflight: when practical, run a representative build, simulator/emulator or browser launch, service startup, or deployment probe that demonstrates the intended development path. For greenfield work, a disposable minimal probe is allowed. The lead controls depth so preflight does not consume disproportionate time.

Run independent work concurrently when useful: parallel specialist passes, UI preparation, repository research, and environment checks. Long-running safe shell work may run in a background `tmux` session while the interview continues. Do not parallelize work whose premise depends on an unresolved upstream decision.

After discovery, handle newly found issues as follows:

- investigate read-only without asking;
- perform safe, easily reversible remediation autonomously and report it;
- otherwise stop as `Blocked` and ask only after presenting the finding, impact, recommendation, and alternatives.

### Agreement provenance

A decision is customer-agreed only when supported by one of these sources: a direct customer statement in the current conversation, a customer-approved artifact, or a standing instruction explicitly intended to govern future work. Record the supporting quote or artifact path. Agent or specialist recommendations, defaults, inferences, silence, and broad continuation language such as “proceed” or “continue” do not create new agreement or expand existing scope.

Track each material customer decision as `agreed`, `proposed`, `inferred`, or `unresolved`. Only `agreed` decisions may be presented downstream as confirmed, and every `agreed` entry must carry its provenance. Specialists may recommend decisions and identify likely inferences, but only the lead may classify them using customer evidence; missing provenance means the decision is not agreed.

### Interview completion and agreement validation

The lead may end discovery when:

- the actual desired outcome can be stated clearly;
- material product and UX/UI choices are settled;
- greenfield/brownfield constraints and protected areas are known;
- the implementation and test environment is ready to the agreed proportional level;
- the test strategy and completion criteria are agreed;
- remaining decisions are safe implementation-team discretion.

When the importance or ambiguity warrants it, validate one to three core agreements with reverse, scenario, teach-back, or counterfactual questions. Compare the answers with the interview record. If they conflict, reopen only the affected decision and do not implement until it is reconciled.

### Final summary and explicit approval gate

When all material decisions are resolved, present a concise final summary covering outcome, scope, material UX/UI, absolute target, constraints, protected areas, environment readiness, agreed QA depth, and completion criteria. State that approval is recognized only when the customer's reply includes the literal word `승인`, and give an example such as `이 내용으로 승인해.`

Do not treat `좋아`, `진행해`, silence, or other broad continuation language as approval. If the customer requests changes, reopen only affected decisions and present the updated summary again. Do not write the final `spec.md` or launch implementation before valid approval.

## 4. Context packets and orchestration

Every delegation includes only relevant material:

```text
Request and phase: discovery | planning | feature-implementation | implementation-review | behavior-review
Target root/cwd, repository, worktree, and branch:
Scoped working paths:
Selected context paths and context generation:
Customer decisions (`decision | status | customer quote or approved artifact path`), and protected areas:
Known facts and explicit inferences:
Known unknowns, unknown-known criteria, and unknown-unknown blind spots:
Environment and test readiness:
QA depth and completion criteria (`status | customer quote or approved artifact path`):
Role-specific feature, investigation, or review criteria:
Expected structured output:
Allowed tools and prohibited actions:
```

Every specialist, feature implementer, or reviewer runs with `cwd` set to the validated target root. Use `parallel` for independent blind-spot, preparation, or review work and `chain` only when a later read-only pass depends on an earlier output. Never use a chain for implementation attempts: each feature attempt and retry must be a separate invocation that receives durable repository evidence rather than a prior agent response. Delegated agents do not communicate directly. The lead integrates outputs, resolves conflicts, and owns canonical documents. Customer decisions marked `agreed` with valid provenance win; downstream agents must not promote recommendations or unproven labels to agreement. Otherwise escalate only conflicts that materially change the result.

## 5. Implementation autonomy and customer re-contact

After discovery and planning, the interview team is no longer active. The lead owns feature decomposition, durable implementation notes, context packets, attempt sequencing, diff/evidence integration, full verification, scoped Git operations, and maintainable handoff quality. Under the `implement` skill, the lead does not make product or test edits: a dedicated Feature Implementer performs one scoped feature attempt and its focused tests per fresh isolated invocation. Internal implementation details remain team discretion; do not ask the customer to choose class structure, file layout, routine refactoring, internal test mechanics, or equivalent implementation techniques.

After discovery, re-contact the customer only when:

- the agreed user-visible outcome or scope must change;
- a new material data, security, privacy, permission, public-exposure, or cost impact appears;
- a protected existing-system boundary must move;
- an expensive-to-reverse choice depends on customer preference;
- customer-only action or authorization is unavoidable.

Investigate first. Never return a bare implementation-time question that the interview could have prevented.

## 6. Approved specification and fresh-session handoff

After valid approval, create the sole implementation entry document under the absolute target project:

Discovery and the specification must explicitly address any credible costly or irreversible data loss; material security, privacy, credential, permission, or public-exposure impact; migration or rollout compatibility, rollback, and recovery; material disruption to live or critical services; and unresolved high-impact decisions expensive to reverse. Do not hand off while any such material issue remains unresolved.

```text
docs/plans/<feature-slug>/
  spec.md
  interview/    # retained role outputs only when useful
  artifacts/    # canonical supporting material only when useful
  prototypes/   # selected useful prototypes only when useful
```

Do not retain role outputs by default. `spec.md` must stand alone for a fresh session and contain the customer outcome, requirements and rationale, selected UX/UI and states, relevant rejected alternatives, absolute target repository/cwd/branch/scope, existing-system constraints and protected areas, environment readiness, implementation sequence, team discretion, QA depth, completion criteria, unresolved-item handling, and approval provenance. It is the highest-priority and sole `implement` entry contract. If supporting files are useful, index their explicit reading order from `spec.md`; no supporting artifact may override it.

For an existing project, write `<absolute-project-dir>/docs/plans/<feature-slug>/spec.md`. For greenfield work, safely create the agreed absolute project directory first, then create the same layout inside it. Never overwrite or repurpose a conflicting existing directory; stop and resolve the conflict.

Always show the specification's copyable absolute path. Validate the target directory, specification, and the `pi` and `tmux` executables, then launch implementation as a fresh interactive Pi session inside a detached tmux session. The tmux session provides the live attach boundary; the Pi session remains the saved conversation and post-exit resume boundary.

Derive the tmux session name as `impl-<work-directory-name>--<feature-slug>`. Normalize the work-directory component to lowercase ASCII letters, digits, and hyphens, and use the approved specification directory name as the feature slug. Derive the Pi session name as `Implement: <feature-slug>`. If the tmux name already exists, append a fresh six-character lowercase UUID prefix; never attach the new implementation to, replace, or kill an existing tmux session.

Use shell-safe argument construction for every concrete value and launch with this shape:

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

`remain-on-exit` must preserve the pane after Pi exits so its final output and exit status remain inspectable. Check only for an immediate tmux or pane launch failure; do not wait for implementation to finish. Treat a dead pane with exit status zero as a fast successful completion, and a nonzero status as launch or implementation failure.

On successful launch, provide the specification path, Pi session name, tmux session name, and these copyable commands without prescribing when to run them:

```bash
tmux attach -t <tmux-session-name>
tmux kill-session -t <tmux-session-name>
```

The attach command is the only supported way to observe or interact with the running implementation. Do not open the same Pi session concurrently with `pi --session` or `pi -r`; both start another Pi process and are only suitable for resuming the saved Pi session after the tmux-hosted Pi process has ended. Never implement in the interview session or offer a same-session fallback. Keep the interview session available for the user to continue or close. Do not automatically delete the tmux session; leave it available for inspection until the customer uses the cleanup command. If launch fails, preserve `spec.md` and the dead pane when available, report the tmux session and pane exit status, and provide one copyable detached retry command using a fresh collision-free tmux name.

## 7. Verification and independent review contract

Agree on verification depth during discovery. Complexity alone never authorizes verification beyond the agreement.

Defaults:

- Prefer E2E tests that exercise the real runtime when they are not excessively complex.
- For servers, consider a fake or isolated database and Docker or an equivalently simple reproducible environment.
- For web frontends, prefer browser automation; for apps, prefer simulators/emulators and physical-device checks only when agreed.
- Add focused unit tests for core logic and materially risky behavior; do not pursue arbitrary coverage targets.
- Avoid brittle tests that merely pin easily changed configuration values.
- Rollback verification is outside the default bar and is included only when the customer selects a genuinely high-assurance level.

When the `implement` skill applies, a dedicated execution role also operates outside the interview team:

- Feature Implementer: implements and focused-tests exactly one approved feature attempt. Every initial attempt, retry, and integrated corrective attempt uses a new isolated invocation with no prior conversational output.

The lead records the result in durable notes after every attempt. Retries receive only the approved specification and linked documents, current repository state and scoped diff, notes, focused failure evidence, and recorded root-cause analysis. Initial and retry attempts for the same feature never run concurrently in one worktree. A feature has one initial attempt and at most two retries; repeated material failure requires root-cause analysis before the final attempt.

When the `implement` skill applies, two dedicated reviewers operate outside the interview team:

- Implementation Reviewer: approved-specification compliance, implementation completeness, diff safety, brownfield compatibility, maintainability, and concrete code-level risk.
- Behavior Reviewer: acceptance criteria, agreed tests, E2E/runtime behavior, regressions, failure states, and data preservation.

Both reviewers are read-only, may not implement fixes or introduce requirements, and judge only the approved contract and agreed QA depth. After a corrective pass, rerun only a reviewer whose finding caused a change or whose evidence was invalidated. Any product-code change is presumed to affect behavior review unless the lead records why the existing evidence remains valid.

Only an observed failure or concrete credible mechanism that undermines the agreed outcome, implementation completeness, runtime health, security, data preservation, or explicit acceptance criterion requires another implementation pass. Additional edge cases, hardening, failure injection, evidence formatting, or rollback variants beyond the agreed bar are follow-up work. “Not exhaustively reviewed or tested” is insufficient to block completion.

## 8. Retry, status, and reporting

A failed operation, feature, or corrective approach has a default maximum of three attempts. Every feature retry is a new isolated Feature Implementer invocation; direct prior-agent output is not retry context. Stop earlier when retries repeat the same ineffective strategy, increase risk or cost disproportionately, or have little chance of success. A role or tool failure follows the same ceiling unless safety requires immediate stopping.

Use two customer-facing terminal statuses:

- `Complete`: the agreed result passed the agreed QA bar. Report success briefly and explain how the customer can try it.
- `Blocked`: implementation could not proceed or the implemented result failed agreed QA. Lead with the blocker and the one required next action. Include details only when needed to unblock.

Do not label unverified agreed core behavior complete. Do not burden routine completion reports with file inventories, command transcripts, or extensive evidence unless the customer asks.

## 9. Target drift and Git safety

Revalidate target root, target cwd, worktree/branch, scope, and applicable context before implementing and whenever they change. If drift materially changes requirements, architecture, protected areas, safety, or acceptance criteria, stop for reconciliation. Run Git and verification operations against the validated target repository. Never reset, stash, clean, overwrite, stage, or commit unrelated customer changes. Stage only intentional scoped files and preserve dirty generated or memory-managed context outside the task.
