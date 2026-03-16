Sync Claude Code configuration and update templates based on actual projects.

## Part 1: Sync from ~/.claude/

The source of truth is `~/.claude/`. Copy all files from there to this repository.

1. Sync agents: Compare files in `~/.claude/agents/` with `agents/` in this repo, copy any that are newer or different
2. Sync commands: Compare files in `~/.claude/commands/` with `.claude/commands/` in this repo, copy any that are newer or different
3. Sync skills: Compare directories in `~/.claude/skills/` with `skills/` in this repo, copy any that are newer or different (each skill is a directory with a SKILL.md file)
4. Sync user settings: Copy `~/.claude/settings.json` to `settings/settings.json` in this repo (this includes enabled plugins, MCP servers, and other user preferences)
5. Sync global instructions: If `~/.claude/CLAUDE.md` exists, copy it to `CLAUDE.md` in this repo root. If it doesn't exist but `CLAUDE.md` exists in the repo, copy it TO `~/.claude/CLAUDE.md`

## Part 1.5: Sync plugins

Sync plugin configuration from `~/.claude/plugins/` to `plugins/` in this repo:

1. Copy `~/.claude/plugins/installed_plugins.json` to `plugins/installed_plugins.json`
2. Copy `~/.claude/plugins/known_marketplaces.json` to `plugins/known_marketplaces.json`
3. Do NOT copy the `cache/` directory (it contains large downloaded plugin files that shouldn't be in git)
4. The `enabledPlugins` in `settings.json` (synced in Part 1 step 4) controls which plugins are active — this step captures which plugins are installed and their versions

## Part 2: Update templates from ~/Projects

Scan all projects in `~/Projects` that have a AGENTS.md file:

1. Identify each project's type:
   - Mobile (React Native/Expo): Look for `app.json`, `expo` in package.json
   - Web (React Router/Remix): Look for `react-router` or `@remix-run` in package.json

2. For each project type, analyze the AGENTS.md files and extract common patterns:
   - Common sections and structure
   - Shared commands (dev, build, test)
   - Common rules and workflows
   - MCP tools usage patterns

3. Update the templates in this repo:
   - `mobile-apps/AGENTS.md` - Update with common patterns from mobile projects
   - `web-apps/AGENTS.md` - Update with common patterns from web projects

4. Keep templates generic (no project-specific details) but include all common sections and patterns found across projects of that type.

## Part 2.5: Sync project MCP servers to templates

For each project type, check for MCP server configurations in the projects:

1. Check for `.mcp.json` files in projects of each type (mobile and web)
2. Extract the `mcpServers` configuration from each project
3. Identify common MCP servers used across projects of the same type
4. Update the template `.mcp.json` files:
   - `mobile-apps/.mcp.json` - Include common MCP servers for mobile projects (e.g., mobile-mcp)
   - `web-apps/.mcp.json` - Include common MCP servers for web projects
5. Keep only MCP servers that are commonly used or essential for that project type

## Part 3: Finish

1. Report what was synced and updated
2. If changes were made, commit and push to GitHub with a descriptive message
