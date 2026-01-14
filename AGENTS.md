# Claude Code Configuration Repository

This repository contains personal Claude Code configuration, including custom agents, skills, and AGENTS.md templates.

## Purpose

- Version control Claude Code customizations
- Sync agent definitions to `~/.claude/agents/`
- Sync skill definitions to `~/.claude/skills/`
- Provide reusable templates for new projects

## Structure

```
CLAUDE.md         # Global instructions (synced to ~/.claude/CLAUDE.md)
agents/           # Custom subagent definitions
  test-runner.md
  releaser.md
  codebase-researcher.md
  code-change-reviewer.md
  feature-architect.md
skills/           # Custom skills (auto-triggered based on description)
  prd/SKILL.md           # PRD generator
  prd-to-json/SKILL.md   # Convert PRD to JSON format
scripts/          # Automation scripts
  ralph.sh               # Autonomous PRD implementation loop
settings/         # User-level Claude Code settings
  settings.json   # Synced from ~/.claude/settings.json (plugins, MCP servers, preferences)
mobile-apps/      # Template for React Native/Expo projects
  AGENTS.md
  .mcp.json       # Project MCP servers (mobile-mcp for iOS projects)
web-apps/         # Template for React Router/Remix projects
  AGENTS.md
  .mcp.json       # Project MCP servers (e.g., playwright)
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| feature-architect | opus | BEFORE any change: analyze codebase, identify refactoring opportunities, create implementation plan |
| code-change-reviewer | opus | AFTER any change: review for bugs, logic errors, and issues |
| test-runner | sonnet | Investigate issues/bugs: run tests, analyze failures, diagnose problems |
| codebase-researcher | opus | Research codebase patterns, architecture, and implementation details |
| releaser | sonnet | Handle deployments and releases |

Agents are generic and read project-specific details from each project's AGENTS.md file.

## Skills

| Skill | Purpose |
|-------|---------|
| prd | Generate detailed PRDs with user stories and acceptance criteria |
| prd-to-json | Convert markdown PRD to JSON format for ralph |

Skills are auto-triggered based on their description matching your request. Claude loads skill descriptions at startup and activates the relevant skill when needed.

## Scripts

### Ralph - Autonomous PRD Implementation

Ralph is a bash script that runs Claude Code in a loop to implement PRD stories autonomously.

**Usage:**
```bash
# Copy to your project
cp scripts/ralph.sh /path/to/your/project/

# Run with default 10 iterations
./ralph.sh

# Run with custom iteration count
./ralph.sh 20
```

**Requirements:**
- `claude` CLI installed
- `jq` installed (`brew install jq`)
- `prd.json` in project root

### Ralph Workflow

1. Ask Claude to "create a PRD" or "generate requirements" → triggers `prd` skill
2. Ask Claude to "convert the PRD to JSON" → triggers `prd-to-json` skill
3. Run `./ralph.sh` to start autonomous implementation loop

**What ralph.sh does:**
- Reads `prd.json` and checks out the feature branch
- Picks the highest priority incomplete story
- Runs Claude Code with the ralph prompt
- Tracks progress in `progress.txt`
- Archives previous runs when switching branches
- Exits when all stories pass or max iterations reached

## Syncing Configuration

**Important**: Whenever you modify agents, skills, or global instructions, you MUST also copy them to `~/.claude/` so Claude Code uses the updated versions:

```bash
# Sync global instructions
cp CLAUDE.md ~/.claude/CLAUDE.md

# Sync agents
cp agents/*.md ~/.claude/agents/

# Sync skills
cp -r skills/* ~/.claude/skills/
```

This must be done every time configuration is changed, before committing.

## MCP Servers

MCP (Model Context Protocol) servers are configured at multiple levels:

### User-level MCP Servers
User-level settings (including MCP servers) are stored in `~/.claude/settings.json` and synced to `settings/settings.json` in this repo.

### Project-level MCP Servers
Project templates use `.mcp.json` at the project root for project-specific MCP servers:
- **Mobile apps**: `mobile-mcp` for iOS simulator automation and testing
- **Web apps**: `playwright` for browser automation and testing

The `.mcp.json` file is designed to be committed to version control and shared with the team. Claude Code reads it directly from the project root.

## Projects

Projects to curate AGENTS.md files for are located in `~/Projects`:

- `~/Projects/retirement-planner` - React Native retirement planning app
- `~/Projects/nippard-tracker` - React Native workout tracker with Supabase
- `~/Projects/ricariko` - React Router bakery storefront

## Creating a New Project

1. Copy the appropriate template directory (`mobile-apps/` or `web-apps/`) contents to your new project:
   - `AGENTS.md` - Project instructions
   - `.mcp.json` - MCP server configuration
2. Fill in project-specific details (overview, key files, environment setup)
3. The Agent Usage section and MCP servers are already configured

## Commands

- `/sync` - Sync agents, skills, commands, and settings from `~/.claude/`, sync project MCP servers to templates, and update templates based on common patterns found in `~/Projects`

## Workflow

After making any changes to this repository, always push to GitHub:

```bash
git add .
git commit -m "Description of changes"
git push
```
