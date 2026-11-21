# Copy pass

Check the user-facing text the change adds or edits, and its translations: labels, headings, buttons, messages, errors, empty states, emails, and notifications. Text the product gives a model at runtime, such as a prompt or a tool description, counts too. Leave developer-facing text, such as logs, to the other passes.

Read each string where users meet it: the component or template around it, the state it appears in, and what sits next to it. Then compare it with the product's existing text: the glossary, if the repo has one (the repo rules usually point to it), and the existing strings, searched for the term and its synonyms.

## What to look for

- **Wrong meaning**: text that says something the code doesn't do (a "Save" button that also publishes), or a message that doesn't tell users what happened or what to do next.
- **Inconsistent terms**: a new word for something the product already names, or an existing word used for something else. The glossary wins, then the most common existing usage.
- **Translations**: each locale says what the source text says, in phrasing native to that language and in the register the rest of the locale uses, such as formal or informal address. A literal translation that reads oddly counts, and so does a term translated differently than elsewhere in the locale. A missing key counts unless the repo falls back to another locale on purpose.
- **Placeholders and plurals**: every locale keeps the source's placeholders and markup and has the plural forms its language needs, in the i18n library's syntax. Sentences built by joining fragments count, since other languages need a different word order.

## Each finding

Quote the current text and give the replacement in every locale it touches, with the reason in a few words: the glossary term it conflicts with, the meaning it gets wrong. Taste alone is not a finding.

Verify: a copy fix says what the code does, uses the glossary's and existing strings' terms, and keeps every locale's placeholders and plural forms.
