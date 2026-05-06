# Test fixtures

Pre-rendered `terraform show -json` output used by the policy self-tests in CI.

| File | Purpose | Expected `conftest test` outcome |
|---|---|---|
| `passing_plan.json` | Hand-crafted plan with all six policies satisfied | exit 0, no violations |
| `violating_plan.json` | Hand-crafted plan that triggers every policy at least once | exit non-zero, ≥ 5 violations |

The fixtures are intentionally **not** generated from real Terraform — that would couple the tests to provider versions and resource defaults. They're flat JSON exercising the exact branches each policy evaluates.

When you add a new policy under `../../policies/`, add a passing case to `passing_plan.json` and a failing case to `violating_plan.json`. CI will assert both.
