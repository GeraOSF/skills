# Quality pass

The change should be as simple as it can be without changing behavior: fewer functions, branches, layers, types, and lines for a reader to hold. Propose moves that delete code, not ones that rearrange or compress it.

Be ambitious about large simplifications, but don't assume one exists. Look for a reframing that makes whole branches, helpers, modes, or layers disappear: reusing an abstraction the codebase already has, moving ownership of state so the conditionals around it vanish, collapsing duplicate paths. When the change is already direct, say so; a marginal finding costs more than it saves.

## Inline single-use code

Inline a function called from one place, a variable read once right after it is assigned, and a type used once. Keep a single-use function only when it:

- is exported or part of a module's public surface;
- is a React component or hook (a render and Rules-of-Hooks boundary);
- is called directly by a test;
- is recursive, or must keep a stable reference (a listener added and later removed).

Readability is not an exception: a well-named function called once is still a jump. If inlining makes the caller hard to follow, the caller needs restructuring, and that is the finding.

## Delete, don't compress

Counts: dead code, unused parameters, unimported exports, unreachable branches; checks for states the types or every caller already rule out (trace it); annotations inference already gives; wrappers that add a layer but no behavior; early returns that remove nesting; logic the codebase already has (point to the existing helper); duplicate branches merged, or a conditional chain replaced by a lookup or typed model when that removes branches.

Doesn't count: nested ternaries, long chains, `&&`/`||` as control flow, comma operators, several statements on one line. They cut lines by making each one harder to read.

## Structure

- **Special cases bolted on**: new flags, nullable modes, or one-off branches in an unrelated flow. Propose the shape where the case is no longer special: its own module, a dispatcher, different ownership of the state.
- **Wrong layer**: feature logic in a shared module, implementation details leaking through an API, a bespoke helper where a canonical one exists.
- **Loose boundaries**: needless optionality, casts, `any` or `unknown` where a precise type fits, a silent fallback papering over an unclear invariant.
- **Half-applied or needlessly sequential work**: related updates that can be left half-done, independent async work run in sequence. Flag only when the fix also simplifies.
- **Files**: never flag length; inlining lengthens some files on purpose. Suggest a split only when a file mixes concerns that change for different reasons.

## Comments

Report the comments the change adds, plus existing ones it made untrue, as one grouped finding listing each with "remove" or "trim to: <text>". A naming or structure problem a removed comment was covering for is its own finding. Error or log text naming a symbol the change removed or renamed is untrue too: report it as its own finding, "rename to: <text>", which keeps behavior unless something matches on the text, such as a test or a log alert.

Remove a comment that narrates the code; restates a visible name, type, or signature; explains routine code or framework idioms; describes history (what changed, why it was refactored, which task added it); labels code already grouped clearly; gives a reason a competent reader would infer; or restates a fact defined elsewhere, which only goes stale. When unsure, remove it.

Keep one, trimmed to the fact, only when it states what the code cannot: an invariant nothing enforces ("caller holds the lock"), a non-obvious reason (a platform bug, an upstream quirk, a measured tradeoff, a deliberate deviation), or a warning that stops a sensible-looking edit from breaking something.

Never touch tool directives (`@ts-expect-error`, `eslint-disable`, `'use client'`, and the like), license headers and generated-file banners, `TODO`/`FIXME` for work not yet done, or prose in Markdown and other docs.

## Each finding

Name the payoff: which functions, branches, types, or lines go. No concrete payoff, no finding. Confirm the fix keeps outputs, side effects, errors, and order of effects the same.
