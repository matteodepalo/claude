Sync Claude Code configuration and update templates based on actual projects.

## Part 1: Sync from ~/.claude/

The source of truth is `~/.claude/`. Copy all files from there to this repository.

1. Sync agents: Compare files in `~/.claude/agents/` with `agents/` in this repo, copy any that are newer or different
2. Sync commands: Compare files in `~/.claude/commands/` with `.claude/commands/` in this repo, copy any that are newer or different
3. Sync user settings: Copy `~/.claude/settings.json` to `settings/settings.json` in this repo (this includes enabled plugins, MCP servers, and other user preferences)

## Part 2: Update templates from ~/Projects

Scan all projects in `~/Projects` that have a CLAUDE.md file:

1. Identify each project's type:
   - Mobile (React Native/Expo): Look for `app.json`, `expo` in package.json
   - Web (React Router/Remix): Look for `react-router` or `@remix-run` in package.json

2. For each project type, analyze the CLAUDE.md files and extract common patterns:
   - Common sections and structure
   - Shared commands (dev, build, test)
   - Common rules and workflows
   - MCP tools usage patterns

3. Update the templates in this repo:
   - `mobile-apps/CLAUDE.md` - Update with common patterns from mobile projects
   - `web-apps/CLAUDE.md` - Update with common patterns from web projects

4. Keep templates generic (no project-specific details) but include all common sections and patterns found across projects of that type.

## Part 2.5: Sync project MCP servers to templates

For each project type, check for MCP server configurations in the projects:

1. Check for `.claude/settings.json` files in projects of each type (mobile and web)
2. Extract the `mcpServers` configuration from each project
3. Identify common MCP servers used across projects of the same type
4. Update the template `.claude/settings.json` files:
   - `mobile-apps/.claude/settings.json` - Include common MCP servers for mobile projects (e.g., ios-simulator)
   - `web-apps/.claude/settings.json` - Include common MCP servers for web projects (e.g., playwright)
5. Keep only MCP servers that are commonly used or essential for that project type

## Part 3: Sync agents to project CLAUDE.md files

For each project in `~/Projects` that has a CLAUDE.md file with an "Agent Usage" section:

1. Compare the agents listed in the project's CLAUDE.md against all agents in `~/.claude/agents/`
2. For any agent in `~/.claude/agents/` that is NOT listed in the project's Agent Usage section, add it
3. Use this format for new agent entries: `- **agent-name**: <description from agent file>`
4. Insert new agents at the top of the agent list (after the intro text, before existing agents)
5. Do NOT remove any project-specific agents that aren't in `~/.claude/agents/` (they may be custom to that project)

## Part 4: Finish

1. Report what was synced and updated
2. If changes were made, commit and push to GitHub with a descriptive message
