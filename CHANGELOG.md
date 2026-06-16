# Changelog

All notable changes to this policy pack are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the pack follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases are cut automatically by `release-please` on merge to `main`,
driven by Conventional Commit prefixes (`feat:` → minor — new policy or new
rule, `fix:`/`docs:`/`chore:` → patch, `feat!:` or `BREAKING CHANGE:`
footer → major — only when an existing pass case becomes a fail).

> **Audit-trail note.** Because this pack is consumed by every Devotica CI run,
> every release that changes a rule's verdict should be documented here with
> the consumer-facing impact ("plans that previously passed will now fail
> if ...").

## [1.0.1](https://github.com/devotica-labs/terraform-policies/compare/v1.0.0...v1.0.1) (2026-06-16)


### Bug Fixes

* **ci:** replace dead instrumenta/conftest-action in conftest-pass job ([#3](https://github.com/devotica-labs/terraform-policies/issues/3)) ([d821e5a](https://github.com/devotica-labs/terraform-policies/commit/d821e5a9c3e3274fd574bb4b0ccfa4530a605ba2))
* **ci:** replace dead instrumenta/conftest-action in conftest-pass job ([#4](https://github.com/devotica-labs/terraform-policies/issues/4)) ([3a307f6](https://github.com/devotica-labs/terraform-policies/commit/3a307f6b82a662a02ad4eb0448cfed8310df4568))

## [Unreleased]

### Added
- Apache-2.0 NOTICE file (pairs with LICENSE).
- Contributor Covenant v2.1 CODE_OF_CONDUCT.md.
- Initial CHANGELOG.md following Keep a Changelog. From now on every
  Conventional Commit on main will land an entry under [Unreleased] and be
  rolled into the next release-please tag.
- `.github/pull_request_template.md` matching the module-repo template,
  with an explicit "Consumer-facing impact" callout for rule changes.
- `.github/workflows/release.yml` — release-please for cutting versioned
  tags and updating the floating `v1` tag consumers pin.

## 1.0.0 — pre-CHANGELOG baseline

The `v1.0.0` and `v1` tags exist but were cut before this CHANGELOG was
introduced. Refer to the git history (`git log v1.0.0`) for the contents
of the initial release.
