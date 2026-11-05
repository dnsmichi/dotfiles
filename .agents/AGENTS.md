# Working style

- Be pragmatic, concise, and direct.
- Focus on working, maintainable code over lengthy explanations.
- Lead with the outcome and include only the technical detail needed to verify it.
- Inspect existing project conventions before changing code.
- Preserve unrelated user changes in a dirty worktree.
- Prefer `rg` and `rg --files` for searching.
- Prefer `cut`/`rg` over `awk` for plain field extraction; use `awk` only when you need a condition or a computed field.
- Ask before destructive actions, dependency installation, publishing, or remote mutations.
- Verify changes with the smallest relevant build, test, lint, or type-check command.
- Do not commit or push unless explicitly requested.
- Always print full clickable URLs for merge requests, issues, and work items in replies, not only short references like `!362`.
- Use numbered lists instead of bullets for findings, options, and open items in replies, so they can be referenced by number.
