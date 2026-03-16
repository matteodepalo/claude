# Claude Code Configuration

Personal Claude Code configuration, templates, and scripts. This repo serves as a backup of `~/.claude/` settings that can be restored on a new machine.

## Restore on New Machine

```bash
git clone <repo-url> ~/Projects/claude
./scripts/restore.sh
```

This restores settings, agents, commands, and global instructions to `~/.claude/`. Plugins auto-install on first Claude Code run.

## Backup Changes

Run `/sync` in Claude Code to backup any changes from `~/.claude/` to this repo.

## Structure

```
├── settings/
│   └── settings.json      # Plugins, permissions, preferences
├── agents/                 # Custom agent definitions
├── .claude/commands/       # Custom slash commands (like /sync)
├── scripts/
│   └── restore.sh         # Restore config to new machine
├── CLAUDE.md              # Global instructions for all projects
├── mobile-apps/           # Template for React Native/Expo projects
│   ├── AGENTS.md
│   └── .mcp.json          # MCP servers (mobile-mcp)
└── web-apps/              # Template for React Router/Remix projects
    ├── AGENTS.md
    └── .mcp.json          # MCP servers (playwright)
```

## Templates

Copy the relevant template folder contents to your project:

- **mobile-apps/** - React Native/Expo mobile apps
- **web-apps/** - React Router (Remix) web apps
