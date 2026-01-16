#!/bin/bash
# Ralph - Autonomous PRD Implementation Loop for Claude Code
# Based on https://github.com/snarktank/ralph
#
# Usage: ./ralph.sh [max_iterations]
# Default: 10 iterations

set -e

# Configuration
MAX_ITERATIONS=${1:-10}
DELAY_BETWEEN_ITERATIONS=2
PROGRESS_FILE="progress.txt"
PRD_FILE="prd.json"
ARCHIVE_DIR="archive"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# The prompt passed to Claude for each iteration
RALPH_PROMPT='# Ralph - Implement Next PRD Story

You are an autonomous coding agent. Implement the next incomplete user story from `prd.json`.

## Your Task

1. **Read the PRD** at `prd.json` in the project root
2. **Read progress** from `progress.txt` (check Codebase Patterns section first)
3. **Verify branch**: Ensure you are on the correct branch from PRD `branchName`
4. **Pick story**: Select the **highest priority** user story where `passes: false`
5. **Implement**: Complete that single user story
6. **Quality checks**: Run typecheck, lint, test - whatever the project requires
7. **Update AGENTS.md**: If you discover reusable patterns, add them
8. **Commit**: If checks pass, commit ALL changes with message: `feat: [Story ID] - [Story Title]`
9. **Update PRD**: Set `passes: true` for the completed story in `prd.json`
10. **Log progress**: Append to `progress.txt`

## Progress Report Format

APPEND to progress.txt (never replace):

```
## [Date/Time] - [Story ID]
- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
---
```

## Consolidate Patterns

If you discover a **reusable pattern**, add it to `## Codebase Patterns` at the TOP of progress.txt:

```
## Codebase Patterns
- Pattern: description
```

## Quality Requirements

- ALL commits must pass quality checks (typecheck, lint, test)
- Do NOT commit broken code
- Keep changes focused and minimal
- Follow existing code patterns

## Visual Verification (Required for UI Stories)

For UI changes, use test-runner agent with MCP tools to verify visually.

## Stop Condition

After completing a user story, check if ALL stories have `passes: true`.

**If ALL complete:**
```
RALPH COMPLETE - All stories implemented and passing!
```

**If stories remain:**
```
RALPH CONTINUE - [N] stories remaining
```

## Important

- Work on ONE story per iteration
- Commit after each story
- Keep CI green
- Read Codebase Patterns before starting'

CONSOLIDATE_PROMPT='# Consolidate Learnings to AGENTS.md

Review `progress.txt` and extract any **valuable, reusable patterns** worth persisting to `AGENTS.md`.

## What to Look For

1. **Codebase patterns** - Recurring code structures, naming conventions, file organization
2. **Gotchas** - Non-obvious issues that caused problems and how to avoid them
3. **Testing patterns** - How to test specific features in this codebase
4. **Integration notes** - How external services (Square, Fly.io, etc.) are used

## What NOT to Add

- Story-specific implementation details
- Temporary workarounds
- Patterns already documented in AGENTS.md
- Obvious or trivial information

## Your Task

1. Read `progress.txt` (especially the Codebase Patterns section)
2. Read current `AGENTS.md`
3. Identify patterns from progress.txt that are:
   - Reusable across future work
   - Not already in AGENTS.md
   - Worth remembering long-term
4. If any valuable patterns exist, append them to the appropriate section in `AGENTS.md`
5. If no patterns worth adding, just say "No new patterns to consolidate"

Keep additions concise and actionable. Format consistently with existing AGENTS.md style.'

log() {
    echo -e "${BLUE}[ralph]${NC} $1"
}

error() {
    echo -e "${RED}[ralph]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[ralph]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[ralph]${NC} $1"
}

# Check requirements
check_requirements() {
    if ! command -v claude &> /dev/null; then
        error "claude CLI not found. Please install Claude Code first."
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        error "jq not found. Please install jq: brew install jq"
        exit 1
    fi

    if [ ! -f "$PRD_FILE" ]; then
        error "No $PRD_FILE found. Create one with the prd-to-json skill first."
        exit 1
    fi
}

# Get branch name from PRD
get_prd_branch() {
    jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo ""
}

# Get last recorded branch
get_last_branch() {
    if [ -f ".ralph-branch" ]; then
        cat ".ralph-branch"
    else
        echo ""
    fi
}

# Archive previous run
archive_previous_run() {
    local old_branch="$1"
    local date_str=$(date +%Y%m%d-%H%M%S)
    local archive_path="$ARCHIVE_DIR/${date_str}-${old_branch//\//-}"

    warn "Branch changed from '$old_branch'. Archiving previous run..."

    mkdir -p "$archive_path"

    [ -f "$PRD_FILE" ] && cp "$PRD_FILE" "$archive_path/"
    [ -f "$PROGRESS_FILE" ] && mv "$PROGRESS_FILE" "$archive_path/"

    log "Archived to: $archive_path"
}

# Initialize progress file
init_progress() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo "## Codebase Patterns" > "$PROGRESS_FILE"
        echo "" >> "$PROGRESS_FILE"
        echo "---" >> "$PROGRESS_FILE"
        echo "" >> "$PROGRESS_FILE"
    fi

    echo "" >> "$PROGRESS_FILE"
    echo "# Ralph Session: $(date)" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
}

# Count remaining stories
count_remaining_stories() {
    jq '[.userStories[] | select(.passes == false)] | length' "$PRD_FILE" 2>/dev/null || echo "?"
}

# Consolidate learnings from progress.txt to AGENTS.md
consolidate_learnings() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        log "No progress file to consolidate"
        return 0
    fi

    log "Consolidating learnings to AGENTS.md..."

    if claude -p "$CONSOLIDATE_PROMPT" --print 2>&1; then
        success "Learnings consolidated"
    else
        warn "Failed to consolidate learnings"
    fi
}

# Check if all stories are complete
all_stories_complete() {
    local remaining=$(count_remaining_stories)
    [ "$remaining" = "0" ]
}

# Run a single iteration
run_iteration() {
    local iteration=$1
    local remaining=$(count_remaining_stories)

    log "Iteration $iteration/$MAX_ITERATIONS (${remaining} stories remaining)"

    # Create a temp file for output
    local output_file=$(mktemp)

    # Run claude with the ralph prompt
    # Using --print to get output and -p to pass the prompt
    if claude -p "$RALPH_PROMPT" --print 2>&1 | tee "$output_file"; then
        # Check for completion signal
        if grep -q "RALPH COMPLETE" "$output_file"; then
            success "All stories completed!"
            rm "$output_file"
            return 1  # Signal to stop
        fi

        if grep -q "RALPH CONTINUE" "$output_file"; then
            log "Story completed, continuing..."
        fi
    else
        warn "Claude exited with error, continuing to next iteration..."
    fi

    rm "$output_file"
    return 0  # Continue
}

# Main execution
main() {
    log "Starting Ralph - Autonomous PRD Implementation"
    log "Max iterations: $MAX_ITERATIONS"

    check_requirements

    # Handle branch changes
    local current_branch=$(get_prd_branch)
    local last_branch=$(get_last_branch)

    if [ -n "$last_branch" ] && [ "$last_branch" != "$current_branch" ]; then
        archive_previous_run "$last_branch"
    fi

    # Save current branch
    echo "$current_branch" > ".ralph-branch"

    # Checkout or create the branch
    if [ -n "$current_branch" ]; then
        if git show-ref --verify --quiet "refs/heads/$current_branch" 2>/dev/null; then
            log "Checking out existing branch: $current_branch"
            git checkout "$current_branch"
        else
            log "Creating new branch: $current_branch"
            git checkout -b "$current_branch"
        fi
    fi

    init_progress

    # Check if already complete
    if all_stories_complete; then
        success "All stories already complete!"
        exit 0
    fi

    # Run iterations
    for ((i=1; i<=MAX_ITERATIONS; i++)); do
        if ! run_iteration $i; then
            break
        fi

        # Check completion after each iteration
        if all_stories_complete; then
            success "All stories completed after $i iterations!"
            break
        fi

        if [ $i -lt $MAX_ITERATIONS ]; then
            log "Waiting ${DELAY_BETWEEN_ITERATIONS}s before next iteration..."
            sleep $DELAY_BETWEEN_ITERATIONS
        fi
    done

    # Consolidate learnings to AGENTS.md
    consolidate_learnings

    # Final status
    local remaining=$(count_remaining_stories)
    if [ "$remaining" = "0" ]; then
        success "Ralph completed successfully! All stories implemented."
    else
        warn "Ralph finished after $MAX_ITERATIONS iterations. $remaining stories remaining."
        warn "Run ralph.sh again to continue."
    fi
}

main "$@"
