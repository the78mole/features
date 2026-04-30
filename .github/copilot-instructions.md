# Copilot Instructions — devcontainers/features

## Feature changes: always use the `feature-modify` skill

Whenever you **add, modify, or fix** anything in a devcontainer feature
(`src/<feature-name>/` or `test/<feature-name>/`), you **must** follow the
`feature-modify` skill located at `.github/skills/feature-modify/SKILL.md`.

This is non-negotiable. The skill covers:

1. **Change classification & version bump** — classify the change as `major`,
   `minor`, or `patch` (see skill for rules), then compute the correct next
   version via
   `.github/skills/feature-modify/scripts/compute-version-bump.sh <feature-name> <major|minor|patch>`
   and write it into `src/<feature-name>/devcontainer-feature.json` before
   committing.

2. **Tests** — every code change requires a corresponding test addition or
   update in `test/<feature-name>/`. New behaviors need new scenario entries in
   `scenarios.json` and a matching `<scenario>.sh` test script.

3. **Test execution** — run `devcontainer features test` for the affected
   feature and confirm all tests pass before finishing.

Do not skip any of these steps, even for small or "obvious" changes.
