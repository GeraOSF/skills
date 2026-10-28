# skills

My agent skills, kept here so every machine runs the same versions.

- `deep-review`: correctness, security, and quality review with independently verified findings.

## Install

```sh
npx skills add GeraOSF/skills -g
```

Update later with `npx skills update -g`.

## Edit

Where you edit skills, link the clone instead of installing a copy, so changes land in the repo:

```sh
git clone https://github.com/GeraOSF/skills ~/code/general/skills
ln -s ~/code/general/skills/skills/deep-review ~/.agents/skills/deep-review
ln -s ../../.agents/skills/deep-review ~/.claude/skills/deep-review
```
