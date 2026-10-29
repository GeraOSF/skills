# Correctness and security pass

Find what the change breaks, exposes, or slows down, including breakage it causes elsewhere. Leave alone problems in code it doesn't touch.

Trace instead of assuming: follow callers, consumers of changed types, serialized and persisted formats, and configuration. That includes consumers outside the repo: a renamed or repurposed event, property, metric, log field, or API field breaks saved queries, dashboards, alerts, and clients the code never mentions. Settle anything you can check before reporting it: when you can read the other side of a boundary, in the repo or through a session tool, check it instead of writing "fine if X handles it".

Then report every candidate you can tie to a concrete failure (this input or state, then this wrong result), including ones you only half believe. A verifier checks each finding, so a weak one costs a check while a dropped one is a bug nobody looks at again. Drop only what you checked and found wrong.

## What to look for

- **Bugs**: logic errors, missed edge cases, contracts changed under callers that still rely on them, races, swallowed or mishandled errors, data written in one shape and read in another.
- **Security**: untrusted input reaching queries, commands, prompts, or file paths; missing auth or ownership checks; secrets in code, logs, or client bundles; trusting client-supplied state; resource use a caller can make unbounded; new or bumped direct dependencies with a lookalike name, an install script, or a known advisory.
- **Removed behavior**: for each deleted or rewritten block, name what it guaranteed (a check, a side effect, an error path, a default) and find where the new code still provides it.
- **Incomplete sets**: when the change adds, renames, or removes a member of a set (a permission, event, route, enum value, message key, config option), find every place that lists or handles the whole set, such as switches, maps, schemas, tests, and locale files, and check each one.
- **Performance**: work a normal path now repeats or grows: a query or request per item where one would do, a heavy dependency in code every user loads, such as a public page's bundle, blocking or repeated work on a hot path.
- **Broken local setup**: changes to how or where secrets and env vars are read, renamed or newly required variables, changed ports, new manual steps. A new dependency counts only if it needs a step outside the normal workflow, like a manual install; a new alternative way to run something doesn't.
- **Feature leaks**: where features sit behind flags or internal-only checks, nothing gated may leak, including indirectly through a shared component, a default, or a route.

If the change clearly means to break something (a feature, flag, or safeguard) and its scope is contained, don't report it, unless the author seems unaware of the full impact or the change looks malicious.

## Fixes

A fix is a change too: trace what it would break. When more than one fix would work, check what depends on each before choosing; if you can't, give both and say what decides. Don't rest a choice on "may" or "probably" about something you could look up.

## Labels

**high**: breaks real behavior or exposes something on a normal path (data loss, a security hole, a crash or slowdown users will hit). **medium**: breaks an edge case or a less common path. **low**: a minor defect. Label honestly; inflated labels teach the user to ignore the review.

A candidate you can't settle (runtime timing, a third-party service you can't query) goes under unconfirmed risks, saying exactly what you couldn't check and what would settle it, such as a command to run or a login the user must grant.

## PR targets

Finish your own review first, for fresh eyes. Then read the PR's discussion and inline comments for findings from BugBot, CodeRabbit, Greptile, or other reviewers: add the valid ones you missed with their source, and merge the ones you also found.
