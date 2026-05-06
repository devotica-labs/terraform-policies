# Security policy

## Reporting a vulnerability

Email `security@devotica.com` with `[terraform-policies]` in the subject line. Include:

- A description of the issue
- Steps to reproduce (a tfplan.json fragment that bypasses a rule, or vice-versa)
- Affected version / commit SHA
- Your assessment of impact

You will receive an acknowledgement within 2 business days. We follow a 90-day responsible disclosure policy.

## What's in scope

- Bypasses of any of the documented policies (a Terraform plan that should be rejected but isn't)
- False positives that would cause legitimate fintech-compliant code to be rejected
- Vulnerabilities in the Rego policies themselves

## What's out of scope

- Bugs in upstream OPA / conftest — please report those upstream
- Bugs in consumer terraform-shared-config workflows — those go to that repo's `SECURITY.md`

## Supported versions

The latest minor version of each major series receives security updates.
