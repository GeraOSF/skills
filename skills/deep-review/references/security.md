# Security pass

If nothing in the change decides who may call, see, change, or spend through it, and it adds or bumps no dependency, say so and stop.

First list how a caller could misuse the change, then check each. Misuse counts only when it reaches past the caller: other users, stored data, the server, or spend; breaking only their own view gives them nothing they couldn't already do. Report findings, not the list.

Look for untrusted input reaching queries, commands, prompts, or file paths; missing auth or ownership checks; secrets in code, logs, or client bundles; trusting client-supplied state; resource use a caller can make unbounded; a guard that passes when its configuration is missing; access wider than the code needs, even when another layer blocks it today; new or bumped direct dependencies with a lookalike name, an install script, or a known advisory.

Trace and settle each candidate before reporting it. Propose fixes and label findings as the Fixes and Labels sections of `correctness.md` say.

Verify: a missing safeguard counts when least privilege or any comparable code in the repo calls for it, not only when it is exploitable today. It is pre-existing only when no comparable code has it.
