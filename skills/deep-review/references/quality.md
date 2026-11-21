# Quality pass

The change should fit how the codebase already works and be as simple as it can be without changing behavior: fewer functions, branches, layers, types, and lines for a reader to hold. Propose moves that delete code, not ones that rearrange or compress it.

Be ambitious about large simplifications, but don't assume one exists. Look for a reframing that makes whole branches, helpers, modes, or layers disappear: reusing an abstraction the codebase already has, moving ownership of state so the conditionals around it vanish, collapsing duplicate paths. When the change is already direct, say so; a marginal finding costs more than it saves.

## Inline single-use code

Inline a function called from one place, a variable read once right after it is assigned, and a type used once. Keep a single-use function only when it:

- is exported or part of a module's public surface;
- is a UI component or hook (a render boundary, and in React a Rules-of-Hooks one);
- is called directly by a test;
- is recursive, or must keep a stable reference (a listener added and later removed);
- is decorated (`@lru_cache`, `@retry`), since inlining drops the decorator.

Readability is not an exception: a well-named function called once is still a jump. If inlining makes the caller hard to follow, the caller needs restructuring, and that is the finding.

## Delete, don't compress

Counts: dead code, unused parameters, unimported exports, unreachable branches; checks for states the types or every caller already rule out (trace it); annotations inference already gives; wrappers that add a layer but no behavior; early returns that remove nesting; logic the change repeats or the codebase already has (point to where it should live); tests that only re-check what types or schemas guarantee; duplicate branches merged, or a conditional chain replaced by a lookup or typed model when that removes branches.

Doesn't count: nested ternaries, long chains, `&&`/`||` as control flow, comma operators, several statements on one line. They cut lines by making each one harder to read.

## Fit

A job the codebase already does one way, done another way here, is a Design finding, even though fixing it changes behavior. Report it even when the new way works, unless the change gives a reason that holds: each extra way of doing a job is one more thing every later change has to keep in step, and reusing the existing mechanism unchanged usually gives the smaller change. Name the precedent and what the difference costs. When the codebase does the job more than one way, say which way the change should follow and why.

## Structure

- **Special cases bolted on**: new flags, nullable modes, or one-off branches in an unrelated flow. Propose the shape where the case is no longer special: its own module, a dispatcher, different ownership of the state.
- **Wrong layer**: feature logic in a shared module, implementation details leaking through an API, a bespoke helper where a canonical one exists.
- **Loose boundaries**: needless optionality, casts, a catch-all type (`any`, `unknown`, `interface{}`) where a precise one fits, a silent fallback papering over an unclear invariant.
- **Half-applied or needlessly sequential work**: related updates that can be left half-done, independent async work run in sequence. Flag only when the fix also simplifies.
- **Files**: never flag length; inlining lengthens some files on purpose. Suggest a split only when a file mixes concerns that change for different reasons.

## Comments

Report the comments the change adds, plus existing ones it made untrue, as one grouped finding. A naming or structure problem a removed comment was covering for is its own finding. Error or log text naming a symbol the change removed or renamed is untrue too: report it as its own finding, "rename to: <text>", which keeps behavior unless something matches on the text, such as a test or a log alert.

Remove a comment that narrates the code; restates a visible name, type, or signature; explains routine code or framework idioms; describes history (what changed, why it was refactored, which task added it); labels code already grouped clearly; gives a reason a competent reader would infer; or restates a fact defined elsewhere, which only goes stale. When unsure, remove it.

Keep one, trimmed to the fact, only when it states what the code cannot: an invariant nothing enforces ("caller holds the lock"), a non-obvious reason (a platform bug, an upstream quirk, a measured tradeoff, a deliberate deviation), or a warning that stops a sensible-looking edit from breaking something.

Never touch comments a tool or runtime reads: directives (`@ts-expect-error`, `eslint-disable`, `'use client'`, `//go:build`, `/*#__PURE__*/`, and the like), docstrings and doc comments that become help text or doctests, and JSDoc types where the project type-checks JS. Nor license headers, generated-file banners, `TODO`/`FIXME` for work not yet done, or prose in Markdown and other docs.

## Each finding

Name the payoff: which functions, branches, types, or lines go, or for a Design finding, what the difference costs. No concrete payoff, no finding.

Verify: a quality fix keeps outputs, side effects, errors, and order of effects the same, and really leaves less code. A Design finding holds when the precedent exists, does the same job, and no reason to differ holds up when checked.
