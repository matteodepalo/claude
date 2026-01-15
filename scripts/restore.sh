#!/bin/bash
# Restore Claude Code configuration to a new machine
# Run this after cloning the repo on a fresh laptop

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[restore]${NC} $1"; }
success() { echo -e "${GREEN}[restore]${NC} $1"; }
warn() { echo -e "${YELLOW}[restore]${NC} $1"; }

log "Restoring Claude Code configuration from repo..."

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"

# Restore settings.json
if [ -f "$REPO_ROOT/settings/settings.json" ]; then
    cp "$REPO_ROOT/settings/settings.json" "$CLAUDE_DIR/settings.json"
    success "Restored settings.json (plugins, permissions)"
fi

# Restore global CLAUDE.md
if [ -f "$REPO_ROOT/CLAUDE.md" ]; then
    cp "$REPO_ROOT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    success "Restored global CLAUDE.md"
fi

# Restore agents
if [ -d "$REPO_ROOT/agents" ]; then
    cp -r "$REPO_ROOT/agents/"* "$CLAUDE_DIR/agents/" 2>/dev/null || true
    success "Restored agents"
fi

# Restore commands
if [ -d "$REPO_ROOT/.claude/commands" ]; then
    cp -r "$REPO_ROOT/.claude/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
    success "Restored commands"
fi

# Restore skills (if any)
if [ -d "$REPO_ROOT/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
    cp -r "$REPO_ROOT/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
    success "Restored skills"
fi

echo ""
success "Configuration restored!"
echo ""
log "Next steps:"
echo "  1. Plugins will auto-install on first Claude Code run"
echo "  2. Run 'claude' in any project to start using"
echo ""
warn "Note: MCP servers (like mobile-mcp, playwright) are per-project"
warn "      and stored in .mcp.json files within each project."
