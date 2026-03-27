#!/bin/bash
# Post-compact hook: reads STATE.md and outputs an orientation summary after context compaction.
# Runs after Claude finishes compressing the conversation context to restore session context.

# shellcheck source=hook-utils.sh
source "$(dirname "$0")/hook-utils.sh"
trap 'log_error "post-compact-orientation" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR

STATE_FILE="$PROJECT_DIR/.planning/STATE.md"

# No-op if STATE.md does not exist (project not yet scaffolded)
[ ! -f "$STATE_FILE" ] && exit 0

# Read orientation fields from STATE.md
POSITION="$(read_state_field "Current Position" 2>/dev/null || echo "(not set)")"
LAST_ACTIVITY="$(read_state_field "Last Activity" 2>/dev/null || echo "(not set)")"
OPEN_ITEMS="$(read_state_field "Open Items" 2>/dev/null || echo "(not set)")"
SESSION_CONTINUITY="$(read_state_field "Session Continuity" 2>/dev/null || echo "(not set)")"

# Output orientation block
cat <<ORIENTATION

=== POST-COMPACTION ORIENTATION ===
Position: $POSITION
Last activity: $LAST_ACTIVITY

Open items:
$OPEN_ITEMS

Context:
$SESSION_CONTINUITY
================================
ORIENTATION

exit 0
