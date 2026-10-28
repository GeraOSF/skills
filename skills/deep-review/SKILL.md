---
name: deep-review
description: Review code for correctness, security, and quality, verify each finding with a fresh reviewer, then apply the fixes the user picks. Run only when the user invokes it by name.
argument-hint: "[target: commit, range, PR number, or path; defaults to uncommitted changes]"
disable-model-invocation: true
---

# Deep Review

Review a change for correctness and security, and for whether it is as simple as it can be without changing behavior. Report only findings that survive an independent check.

## Target

The text after the command names the target: a commit, a range, a PR, or paths. It may also exclude paths or add a focus. With no target, review all uncommitted changes, untracked files included. For a PR, read files at its head. For a path, review the files there as they stand, not a diff, and treat all of it as "the change" below. If there is nothing to review, say so and stop.

## 1. Gather

Note how to get the code under review, the files involved, and where the repo's agent instructions are (`AGENTS.md`, `CLAUDE.md`, and docs they point to for conventions). Reviewers read the code themselves; don't paste it into briefs.

Also note the systems outside the repo that consume what the change emits or stores (analytics events and properties, log and metric names, API fields, persisted data, webhooks), and which of them this session can query read-only, such as through an MCP connector or a CLI.

## 2. Review

Start two subagents in parallel with fresh contexts, one per pass, briefed with:

```
Review a code change. Read <skill dir>/references/<quality|correctness>.md and follow it.
Target: <what>. Get it with: <commands>. Files: <list>.
Repo rules: <paths>. They are review rules too and win where they conflict with the reference; quote the rule a finding rests on.
External consumers: <systems, and how to query them read-only; or "none">.
Scope: code the change adds or modifies. Reach into unchanged code only when the change directly involves it: it duplicates an existing helper, leaves a function with a single caller, or only gets simpler if something it calls is reshaped.
Focus: <anything your instructions add or narrow; omit if none>.
Return findings shaped like the items in the report template below, or "no findings": a clean change is a good result, and each weak finding costs the user a check.
Do not edit files.
<report template>
```

Merge findings both passes share.

## 3. Verify

Start one fresh verifier for all findings. Give it their locations, claims, and fixes, but not the reviewers' reasoning: a verifier that reads the argument tends to agree with it, while one given only the claim must re-derive it, which is what catches a misreading. Brief it with:

```
Try to disprove each finding below; other reviewers wrote them.
Target: <what>. Get it with: <commands>. Repo rules: <paths>. Standards: <skill dir>/references/quality.md and correctness.md.
External consumers: <systems, and how to query them read-only; or "none">.
For each, check that:
- the quoted code exists and does what the finding says;
- the problem is real: trace callers, types, other modules, and the external consumers;
- a correctness problem is reachable and its label fits;
- a quality fix keeps behavior identical (outputs, side effects, errors, order) and really leaves less code;
- the fix compiles against the real APIs, follows the repo rules, and breaks nothing the problem didn't: check what depends on anything it renames, removes, or repurposes, in the repo and in the external consumers.
A "may" or "probably" about something you can look up is unchecked: look it up.
Answer each with one of:
- confirmed. If only the fix is wrong, correct it. If two fixes would work and you can't check which is safe, give both and say what decides.
- rejected, with a one-line reason.
- unconfirmed, only for a correctness finding that would be high if real, saying exactly what could not be checked.
Do not edit files.
```

The comment finding skips verification, since removing a comment cannot change behavior; check yourself that it lists nothing from the quality reference's "Never touch" list.

Subagents use the session's model unless your instructions assign models to the reviewers or the verifier. Without subagents, run both passes yourself, then re-check each finding as if someone else wrote it, and say verification was not independent.

## 4. Report

Fill the template, leaving out empty sections. Number findings straight through so the user can pick by number. Correctness comes first, by label; quality follows, biggest simplification first. If nothing survived, say the change is clean in one line, plus any rejected findings.

```markdown
## Correctness and security

1. **high|medium|low** · `path:line`: <problem, one sentence>
   > <the few lines that matter>

   Breaks: <what, for whom, when>. Fix: <concrete change>.

## Quality

2. `path:line`: <problem, one sentence>
   > <the few lines that matter>

   Fix: <concrete change>. Removes: <e.g. "deletes `formatTurn` and 11 lines">.

3. Comments: remove 4, trim 2.
   - `path:line` remove: <comment>
   - `path:line` trim to: <new text>

## Unconfirmed risks

- `path:line`: <risk>. Could not check: <what>.

## Rejected in verification

- `path:line`: <claim>. <reason>.
```

## 5. Apply

Ask which findings to apply (numbers or "all"), unless your instructions already say. Apply each as verified. When one removes or renames a symbol, search the repo for the old name and update what remains; name any external consumer that still uses it instead of editing it. If code changed, not only comments, run the checks the repo's instructions name, as they say. If an applied fix breaks a check, repair it when the cause is clear or revert it, and say which. End with what was applied and each check's result.
