---
name: debrief
description: Explain a completed implementation from its specification, artifacts, notes, reviews, and diff, then check understanding with one adaptive question at a time.
disable-model-invocation: true
---

# Debrief

Use the current implementation conversation or a user-supplied approved `spec.md`. Read the specification and its explicitly indexed supporting documents in order, then useful interview outputs, canonical artifacts, prototypes, `implementation-notes.md`, reviews, and relevant Git diff/commits. Do not confuse implementation completion with user understanding.

Create or update `debrief.md` beside the specification:

```md
# Debrief

Understanding: Incomplete

## Why This Changed
## How It Works
## Important Code Paths
## Specification vs. Implementation
## Tradeoffs and Residual Risks
## Review Materials
## Quiz Log
```

Explain the user-visible behavior and reasoning, not merely a file list. Link the specification, indexed supporting documents, prototypes, notes, reviews, and important code paths with relative links where practical. Clearly identify deviations from the approved specification.

Then ask exactly one question at a time about the most important concept or tradeoff. Wait for the answer. Evaluate it, explain missing or incorrect parts, and choose an adaptive follow-up. Record questions, summarized answers, and evaluations in `Quiz Log`.

Set understanding independently to:

- `Passed`: the user demonstrates the key behavior, rationale, and major tradeoff.
- `Incomplete`: the session stops before sufficient understanding or important misconceptions remain.
- `Skipped`: the user declines the quiz.

Never mark implementation incomplete merely because understanding is incomplete, and never run implementation changes from this skill.
