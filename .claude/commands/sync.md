Sync the agent and command files in this repository with the actual files used by Claude Code.

The source of truth is `~/.claude/`. Copy all files from there to this repository.

Steps:
1. Sync agents: Compare files in `~/.claude/agents/` with `agents/` in this repo, copy any that are newer or different
2. Sync commands: Compare files in `~/.claude/commands/` with `.claude/commands/` in this repo, copy any that are newer or different
3. Report what was synced
4. If changes were made, commit and push to GitHub with a descriptive message
