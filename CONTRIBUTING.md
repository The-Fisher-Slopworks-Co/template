# Contributing to {{PROJECT_NAME}}

Thanks for your interest in improving **{{PROJECT_NAME}}**. This guide covers how
to get set up, what we expect before a pull request, and the licensing rules
every contribution must follow.

## Getting started

```bash
# Replace with this project's real setup commands, e.g.:
# bun install        # or: npm install / cargo build / pip install -e .
# bun run dev        # run from source
```

## Tests — the verification gate

```bash
# Replace with this project's real test command, e.g.:
# bun run check      # typecheck + tests   (or: npm test / cargo test)
```

All tests must pass before a change is merged. Keep changes focused and add tests
for new behavior.

## License & REUSE compliance

This project is licensed under **AGPL-3.0-or-later** and is
[REUSE](https://reuse.software/)-compliant. By submitting a contribution you
agree that it is licensed under **AGPL-3.0-or-later**.

Every file must carry copyright and license information — either an inline
SPDX header (for source code and YAML) or an entry in
[`REUSE.toml`](./REUSE.toml) (for JSON, binaries, and docs that can't hold a
comment). The inline header for source files is two lines:

```text
SPDX-FileCopyrightText: 2026 The Fisher Slopworks Co
SPDX-License-Identifier: AGPL-3.0-or-later
```

(use the comment syntax of the file's language, e.g. `//`, `#`, or `--`).

Before you open a pull request, verify compliance locally:

```bash
reuse lint          # must report "compliant"; CI enforces this on every push
```

## Pull requests

1. Branch from `main`.
2. Keep changes focused; update `CHANGELOG.md` when behavior changes.
3. Make sure the test command and `reuse lint` both pass.
4. Open the PR with a clear description of what changed and why.

## Code of Conduct

This project follows the [Contributor Covenant](./CODE_OF_CONDUCT.md). By
participating you are expected to uphold it.

## Reporting bugs & vulnerabilities

- **Bugs / feature requests:** open a GitHub issue.
- **Security vulnerabilities:** follow [`SECURITY.md`](./SECURITY.md) — please do
  **not** open a public issue for security reports.
