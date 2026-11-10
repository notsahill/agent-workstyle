# Agent Workstyle

Agent Skills that make coding agents follow a user-driven work style by default in any repository:

| Skill | Use it for | What it does |
|---|---|---|
| `decision-first-code` | Implementing, fixing, refactoring | Presents nontrivial choices with pros and cons and a recommendation, waits for a decision, works test-first, announces trivial fixes before making them, asks about larger issues, then ships a verified branch, commits, and pull request with a change walkthrough. |
| `root-cause-debug` | Bugs with an unknown cause | Reproduces the failure, proves the root cause with evidence, presents fix options, and waits for a decision before fixing. |
| `decision-first-plan` | Planning larger work | Settles the key decisions with the user, then writes a step-by-step plan without editing code. |
| `critical-plan-review` | Reviewing a plan, only when asked | Maps the whole project (in parallel subagents where available), then critiques the plan against it with prioritized, evidence-backed findings. |
| `lens-pr-review` | Reviewing a diff or pull request | Asks for a review lens and returns only evidence-backed, actionable findings. |
| `diagram-first-explain` | Explaining how code works | Leads with a diagram of the mechanism, then expands only on what was asked, in as few tokens as possible. |

The skill folders follow the open Agent Skills format and are shared unchanged by Codex and Claude Code.

## Install

Clone the repository somewhere permanent:

```sh
git clone https://github.com/notsahill/agent-workstyle.git
cd agent-workstyle
```

Preview the links, then install globally for both tools using symlinks to this checkout:

```sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

Because the skills are symlinked, edits in this checkout take effect immediately and `git pull` updates them. Moving or deleting the checkout breaks the links; run `./scripts/install.sh uninstall` from the old location first, or remove the dangling links, then run `./scripts/install.sh` again from the new location.

Inspect or remove only links created by this repository:

```sh
./scripts/install.sh status
./scripts/install.sh uninstall --dry-run
./scripts/install.sh uninstall
```

The installer fails safely if any target name already exists. It never replaces a file, directory, or unrelated symlink.

Codex discovers the skills under `~/.agents/skills/` and can invoke them explicitly as `$<skill-name>`, for example `$decision-first-code`. Claude Code discovers them under `~/.claude/skills/` and invokes them as `/<skill-name>`. Both tools may also select them automatically from matching requests. The installer links every folder under `skills/` that contains a `SKILL.md`.

For Claude plugin development, this repository can instead be loaded with `claude --plugin-dir /path/to/agent-workstyle`. Do not enable that plugin and the personal Claude symlinks simultaneously, because the same skills would be loaded twice.

## Precedence over other process skills

Each skill states that it takes precedence over overlapping general-purpose process skills, such as those in the superpowers plugin. Some of those plugins give user instructions priority over skills, so for the strongest guarantee add this line to `~/.claude/CLAUDE.md` (Claude Code) or `~/.codex/AGENTS.md` (Codex):

```md
When an agent-workstyle skill (decision-first-code, root-cause-debug, decision-first-plan, critical-plan-review, lens-pr-review, diagram-first-explain) applies, follow it instead of any overlapping process skill such as brainstorming, systematic-debugging, writing-plans, test-driven-development, or finishing-a-development-branch.
```

## Validate

```sh
./scripts/validate.sh
```

This runs the Codex skill validator when available, strict Claude plugin validation, and isolated installer tests. Behavioral fixtures live in `evals/scenarios.md`.

