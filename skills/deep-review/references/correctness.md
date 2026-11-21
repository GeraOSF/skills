# Correctness pass

Find what the change breaks or slows down, including breakage it causes elsewhere.

First write the questions this change raises under each item in "What to look for", then answer them. Report findings, not the questions.

Trace instead of assuming: follow callers, consumers of changed types, serialized and persisted formats, and configuration. That includes consumers outside the repo: a renamed or repurposed event, property, metric, log field, or API field breaks saved queries, dashboards, alerts, and clients the code never mentions. Settle anything you can check before reporting it: when you can read the other side of a boundary, in the repo or through a session tool, check it instead of writing "fine if X handles it".

Then report every candidate you can tie to a concrete failure (this input or state, then this wrong result), including ones you only half believe. A verifier checks each finding, so a weak one costs a check while a dropped one is a bug nobody looks at again. Drop only what you checked and found wrong.

## What to look for

- **Bugs**: logic errors, missed edge cases, contracts changed under callers that still rely on them, races, swallowed or mishandled errors, data written in one shape and read in another.
- **Removed behavior**: for each deleted or rewritten block, name what it guaranteed (a check, a side effect, an error path, a default) and find where the new code still provides it.
- **Incomplete sets**: when the change adds, renames, or removes a member of a set (a permission, event, route, enum value, message key, config option), find every place that lists or handles the whole set, such as switches, maps, schemas, tests, and locale files, and check each one.
- **Performance**: work or spend that a normal path repeats, or that grows with data, users, or time, including calls billed by use.
- **Tests**: each test the change adds or edits can fail: it exercises what its name claims, not a stand-in, and doesn't depend on the clock, run order, or the network.
- **Docs**: statements in docs the change edits or makes untrue. Report them as one grouped finding, each with what the code does.
- **Broken local setup**: changes to how or where secrets and env vars are read, renamed or newly required variables, changed ports, new manual steps. A new dependency counts only if it needs a step outside the normal workflow, like a manual install; a new alternative way to run something doesn't.
- **Feature leaks**: where features sit behind flags or internal-only checks, nothing gated may leak, including indirectly through a shared component, a default, or a route.

If the change clearly means to break something (a feature, flag, or safeguard) and its scope is contained, don't report it, unless the author seems unaware of the full impact or the change looks malicious.

## Fixes

A fix is a change too: trace what it would break. When more than one fix would work, check what depends on each before choosing; if you can't, give both and say what decides.

## Labels

**high**: breaks real behavior or exposes something on a normal path (data loss, a security hole, a crash or slowdown users will hit). **medium**: breaks an edge case or a less common path. **low**: a minor defect. Label honestly; inflated labels teach the user to ignore the review.

A candidate you can't settle (runtime timing, a third-party service you can't query) goes under unconfirmed risks.
