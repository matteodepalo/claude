# Claude Code Configuration Repository

This repository contains personal Claude Code configuration, including custom agents and CLAUDE.md templates.

## Purpose

- Version control Claude Code customizations
- Sync agent definitions to `~/.claude/agents/`
- Provide reusable templates for new projects

## Structure

```
agents/           # Custom subagent definitions
  test-runner.md
  releaser.md
  codebase-researcher.md
  code-change-reviewer.md
mobile-apps/      # Template for React Native/Expo projects
  CLAUDE.md
web-apps/         # Template for React Router/Remix projects
  CLAUDE.md
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| test-runner | sonnet | Run tests after code changes |
| releaser | sonnet | Handle deployments and releases |
| codebase-researcher | opus | Research codebase before substantial changes |
| code-change-reviewer | opus | Review code for bugs and issues |

Agents are generic and read project-specific details from each project's CLAUDE.md file.

## Syncing Agents

After modifying agents, copy them to `~/.claude/agents/` for Claude Code to use:

```bash
cp agents/*.md ~/.claude/agents/
```

## Projects

Projects to curate CLAUDE.md files for are located in `~/Projects`:

- `~/Projects/retirement-planner` - React Native retirement planning app
- `~/Projects/nippard-tracker` - React Native workout tracker with Supabase
- `~/Projects/ricariko` - React Router bakery storefront

## Creating a New Project

1. Copy the appropriate template (`mobile-apps/CLAUDE.md` or `web-apps/CLAUDE.md`) to your new project
2. Fill in project-specific details (overview, key files, environment setup)
3. The Agent Usage section is already included

## Commands

- `/sync` - Sync agent files from `~/.claude/agents/` to this repository (source of truth is `~/.claude/agents/`)

## Workflow

After making any changes to this repository, always push to GitHub:

```bash
git add .
git commit -m "Description of changes"
git push
```
