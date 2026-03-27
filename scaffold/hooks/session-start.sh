#!/bin/bash
# SessionStart hook: fires when Claude Code starts a new session.
# Outputs orientation from STATE.md to ground the agent at session start.
# Matcher values: startup, resume, clear, compact
# Note: "compact" is a no-op — PostCompact handles post-compaction orientation
# to avoid duplicate output when both hooks fire.

source "$(dirname "$0")/hook-utils.sh"
trap 'log_error "session-start" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR

MATCHER="${1:-}"

# compact: PostCompact already provides orientation after compaction.
# Running SessionStart here would duplicate that output, so skip.
if [ "$MATCHER" = "compact" ]; then
  exit 0
fi

# If STATE.md does not exist, this is an uninitialized project — nothing to show.
if [ ! -f "$PROJECT_DIR/.planning/STATE.md" ]; then
  exit 0
fi

# Extract orientation fields from STATE.md using hook-utils read_state_field().
CURRENT_POSITION=$(read_state_field "Current Position" 2>/dev/null || echo "")
LAST_ACTIVITY=$(read_state_field "Last Activity" 2>/dev/null || echo "")
SESSION_CONTINUITY=$(read_state_field "Session Continuity" 2>/dev/null || echo "")

# Output structured orientation block.
echo "=== SESSION START ==="
echo "Position: ${CURRENT_POSITION:-unavailable}"
echo "Last activity: ${LAST_ACTIVITY:-unavailable}"
echo ""
echo "What to know:"
if [ -n "$SESSION_CONTINUITY" ]; then
  echo "$SESSION_CONTINUITY"
else
  echo "(no session continuity data)"
fi
echo "===================="

exit 0
