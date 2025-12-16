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
  feature-architect.md
settings/         # User-level Claude Code settings
  settings.json   # Synced from ~/.claude/settings.json (plugins, MCP servers, preferences)
mobile-apps/      # Template for React Native/Expo projects
  CLAUDE.md
  .claude/
    settings.json # Project MCP servers (e.g., ios-simulator)
web-apps/         # Template for React Router/Remix projects
  CLAUDE.md
  .claude/
    settings.json # Project MCP servers (e.g., playwright)
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| feature-architect | opus | BEFORE any change: analyze codebase, identify refactoring opportunities, create implementation plan |
| code-change-reviewer | opus | AFTER any change: review for bugs, logic errors, and issues |
| test-runner | sonnet | Investigate issues/bugs: run tests, analyze failures, diagnose problems |
| codebase-researcher | opus | Research codebase patterns, architecture, and implementation details |
| releaser | sonnet | Handle deployments and releases |

Agents are generic and read project-specific details from each project's CLAUDE.md file.

## Syncing Agents

**Important**: Whenever you modify any agent file in `agents/`, you MUST also copy it to `~/.claude/agents/` so Claude Code uses the updated version:

```bash
cp agents/*.md ~/.claude/agents/
```

This must be done every time an agent is changed, before committing.

## MCP Servers

MCP (Model Context Protocol) servers are synced at two levels:

### User-level MCP Servers
User-level settings (including MCP servers) are stored in `~/.claude/settings.json` and synced to `settings/settings.json` in this repo.

### Project-level MCP Servers
Project templates include `.claude/settings.json` with recommended MCP servers for each project type:
- **Mobile apps**: `ios-simulator` for visual testing on iOS simulator
- **Web apps**: `playwright` for browser automation and testing

When creating a new project from a template, copy both the `CLAUDE.md` and the `.claude/` directory.

## Projects

Projects to curate CLAUDE.md files for are located in `~/Projects`:

- `~/Projects/retirement-planner` - React Native retirement planning app
- `~/Projects/nippard-tracker` - React Native workout tracker with Supabase
- `~/Projects/ricariko` - React Router bakery storefront

## Creating a New Project

1. Copy the appropriate template directory (`mobile-apps/` or `web-apps/`) contents to your new project:
   - `CLAUDE.md` - Project instructions
   - `.claude/settings.json` - MCP server configuration
2. Fill in project-specific details (overview, key files, environment setup)
3. The Agent Usage section and MCP servers are already configured

## Commands

- `/sync` - Sync agents, commands, and settings from `~/.claude/`, sync project MCP servers to templates, and update templates based on common patterns found in `~/Projects`

## Workflow

After making any changes to this repository, always push to GitHub:

```bash
git add .
git commit -m "Description of changes"
git push
```
