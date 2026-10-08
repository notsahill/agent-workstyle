# Agent Workstyle

Two Agent Skills that make coding agents follow a user-driven workflow in any repository:

- `decision-first-code` presents nontrivial implementation choices, recommends an option, waits for a decision, and then makes the smallest coherent verified change.
- `lens-pr-review` asks for a review lens and returns only evidence-backed, actionable findings.

The skill folders follow the open Agent Skills format and are shared unchanged by Codex and Claude Code.

## Install

Install globally for both tools using symlinks to this checkout:

```sh
./scripts/install.sh
```

Inspect or remove only links created by this repository:

```sh
./scripts/install.sh status
./scripts/install.sh uninstall --dry-run
./scripts/install.sh uninstall
```

The installer fails safely if any target name already exists. It never replaces a file, directory, or unrelated symlink.

Codex discovers the skills under `~/.agents/skills/` and can invoke them explicitly as `$decision-first-code` and `$lens-pr-review`. Claude Code discovers them under `~/.claude/skills/` and invokes them as `/decision-first-code` and `/lens-pr-review`. Both tools may also select them automatically from matching requests.

For Claude plugin development, this repository can instead be loaded with `claude --plugin-dir /path/to/agent-workstyle`. Do not enable that plugin and the personal Claude symlinks simultaneously, because the same skills would be loaded twice.

## Validate

```sh
./scripts/validate.sh
```

This runs the Codex skill validator when available, strict Claude plugin validation, and isolated installer tests. Behavioral fixtures live in `evals/scenarios.md`.

