## Summary
<!-- What does this PR do? Which policy (or fixture) does it touch? -->

## Type of change
- [ ] `feat:` new policy or new rule (minor bump)
- [ ] `fix:` rule-logic fix that doesn't change the consumer-facing pass/fail surface (patch bump)
- [ ] `feat!:` consumer-facing rule change — plans that previously passed now fail, OR previously failed now pass (major bump)
- [ ] `docs:` documentation only
- [ ] `chore:` tooling / CI / deps

## Consumer-facing impact
<!--
  REQUIRED for feat:, feat!:, and any fix: that changes verdicts.
  Describe in one or two sentences what changes for consumers when they pull
  the next release.
    "Plans that include an aws_s3_bucket without server-side encryption
     configured will now fail. Existing modules already configure it, so this
     should be a no-op for the catalog."
-->

## Checklist
- [ ] `conftest verify` passes against fixtures/passing_plan.json
- [ ] `conftest test` against fixtures/violating_plan.json produces only the rule(s) this PR is about
- [ ] PR title follows Conventional Commits
- [ ] CHANGELOG [Unreleased] section updated for any verdict-changing rule

## Breaking changes
<!-- For feat!: only. List every consumer-visible verdict flip. -->
