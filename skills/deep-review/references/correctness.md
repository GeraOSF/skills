# Correctness and security pass

Find what the change breaks or exposes, including breakage it causes elsewhere. Leave alone problems in code it doesn't touch.

Trace instead of assuming: follow callers, consumers of changed types, serialized and persisted formats, and configuration. That includes consumers outside the repo: a renamed or repurposed event, property, metric, log field, or API field breaks saved queries, dashboards, alerts, and clients the code never mentions. Settle anything you can check before reporting it: when you can read the other side of a boundary, in the repo or through a session tool, check it instead of writing "fine if X handles it".

## What to look for

- **Bugs**: logic errors, missed edge cases, contracts changed under callers that still rely on them, races, swallowed or mishandled errors, data written in one shape and read in another.
- **Security**: untrusted input reaching queries, commands, prompts, or file paths; missing auth or ownership checks; secrets in code, logs, or client bundles; trusting client-supplied state; resource use a caller can make unbounded; new or bumped direct dependencies with a lookalike name, an install script, or a known advisory.
- **Broken local setup**: changes to how or where secrets and env vars are read, renamed or newly required variables, changed ports, new manual steps. A new dependency counts only if it needs a step outside the normal workflow, like a manual install; a new alternative way to run something doesn't.
- **Feature leaks**: where features sit behind flags or internal-only checks, nothing gated may leak, including indirectly through a shared component, a default, or a route.

If the change clearly means to break something (a feature, flag, or safeguard) and its scope is contained, don't report it, unless the author seems unaware of the full impact or the change looks malicious.

## Fixes

A fix is a change too: trace what it would break. When more than one fix would work, check what depends on each before choosing; if you can't, give both and say what decides. Don't rest a choice on "may" or "probably" about something you could look up.

## Labels

**high**: breaks real behavior or exposes something on a normal path (data loss, a security hole, a crash users will hit). **medium**: breaks an edge case or a less common path. **low**: a minor defect. Label honestly; inflated labels teach the user to ignore the review.

A risk you can't settle (runtime timing, a third-party service you can't query) is reported as unconfirmed only if it would be high if real, saying exactly what couldn't be checked. Anything else is confirmed or dropped.

## PR targets

Finish your own review first, for fresh eyes. Then read the PR's discussion and inline comments for findings from BugBot, CodeRabbit, Greptile, or other reviewers: add the valid ones you missed with their source, and merge the ones you also found.
