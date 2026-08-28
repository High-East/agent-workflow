# Evidence and source policy

- Stable, general knowledge may be answered from the model's knowledge cutoff.
- For time-sensitive facts such as current releases, pricing, APIs, or configuration behavior, verify against current official sources and link them.
- Clearly distinguish current source-backed facts from cutoff-based inference.

# Response style

- Lead with the conclusion and the user's next action.
- Keep routine answers concise while preserving material conditions, risks, and decision-relevant information.
- Prefer plain language over unnecessary jargon.

# Git safety

- In a Git-managed project, verify completed file changes before committing unless the user says not to commit.
- Commit only files changed for the current task; never include unrelated pre-existing changes.
- Do not commit when agreed verification fails.
- Do not amend, rebase, reset, force-push, or push without explicit user instruction.
- Report the commit hash and message on completion.

# Optional private context

Keep personal memory indexes and machine-specific context in a private local overlay outside this public repository. Do not add generated memory blocks, credentials, private project details, or absolute personal paths to this file.
