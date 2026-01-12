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

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RALPH_PROMPT_FILE="$SCRIPT_DIR/ralph-prompt.md"

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

    if [ ! -f "$RALPH_PROMPT_FILE" ]; then
        error "Ralph prompt file not found at: $RALPH_PROMPT_FILE"
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
    if claude -p "$(cat "$RALPH_PROMPT_FILE")" --print 2>&1 | tee "$output_file"; then
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
