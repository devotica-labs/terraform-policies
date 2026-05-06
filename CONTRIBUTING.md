# Contributing

Issues are welcome from anyone. Pull requests at this time are accepted only from members of the Devotica engineering team while the catalog stabilises.

## For Devotica engineers

### Workflow

1. Fork or create a branch
2. `pre-commit install` (uses canonical hooks from terraform-shared-config)
3. Author your policy and matching fixtures (see README → "Adding a new policy")
4. Run locally: `opa fmt`, `opa check`, `conftest test` against both fixtures
5. Open a PR — CI re-runs all three checks

### Conventional commits

We use Conventional Commits. release-please consumes them to compute the next version.

```
feat(policies): add policy 07 — no-unencrypted-secrets-manager
fix(05): correct waiver-tag detection on aws_vpc_security_group_ingress_rule
docs: clarify waiver convention in README
```

### Policy author checklist

Before opening a PR, every new policy file must:

- [ ] Begin with a comment block explaining what it catches and why (cite Foundation Plan section if applicable)
- [ ] Use `package main` (so consumers don't need to namespace each rule)
- [ ] Use the `deny contains msg if { ... }` style with `sprintf` formatting
- [ ] Include the policy ID and resource address in the message text
- [ ] Reuse helpers from `policies/helpers.rego` instead of re-deriving plan unwrapping
- [ ] Have at least one passing case in `tests/fixtures/passing_plan.json`
- [ ] Have at least one failing case in `tests/fixtures/violating_plan.json`
- [ ] Be referenced in the README policy table

### Waivers

Don't add a per-rule kill switch. If a policy needs a waiver mechanism, use the `DevoticaWaiver` tag pattern (see policies 04 and 05). Waivers must have a non-empty reason and are reviewed at code-review time.

### Releases

`release-please` opens a Release PR automatically when commits land on `main`. Approve and merge to cut a tag. Consumers update their `@vX.Y.Z` pins on their next regular maintenance.

## Reporting security issues

Don't open a public issue. Email `security@devotica.com` with `[terraform-policies]` in the subject. We follow a 90-day responsible disclosure policy.
