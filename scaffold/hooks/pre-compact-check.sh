#!/bin/bash
# Pre-compact hook: saves a lightweight snapshot to STATE.md before context compaction.
# Runs before Claude compresses the conversation context.

# shellcheck source=hook-utils.sh
source "$(dirname "$0")/hook-utils.sh"
trap 'log_error "pre-compact-check" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR

STATE_FILE="$PROJECT_DIR/.planning/STATE.md"

# No-op if STATE.md does not exist (project not yet scaffolded)
[ ! -f "$STATE_FILE" ] && exit 0

TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Collect modified files and recent commits — only in git projects
if is_git_project; then
  MODIFIED_FILES="$(git -C "$PROJECT_DIR" diff --name-only HEAD 2>/dev/null; git -C "$PROJECT_DIR" diff --cached --name-only 2>/dev/null)"
  if [ -z "$MODIFIED_FILES" ]; then
    MODIFIED_DISPLAY="none"
  else
    MODIFIED_DISPLAY="$(echo "$MODIFIED_FILES" | sed 's/^/  - /')"
  fi

  RECENT_COMMITS="$(git -C "$PROJECT_DIR" log --oneline -3 2>/dev/null)"
  if [ -z "$RECENT_COMMITS" ]; then
    COMMITS_DISPLAY="none"
  else
    COMMITS_DISPLAY="$(echo "$RECENT_COMMITS" | sed 's/^/  - /')"
  fi
else
  MODIFIED_DISPLAY="non-git project — file tracking unavailable"
  COMMITS_DISPLAY="non-git project — commit history unavailable"
fi

# Build snapshot block
SNAPSHOT="
### Pre-Compaction Snapshot (auto-generated)
- **Timestamp:** $TIMESTAMP
- **Modified files:**
$MODIFIED_DISPLAY
- **Recent commits:**
$COMMITS_DISPLAY"

# Append snapshot to STATE.md — insert before version marker if present, else append
if grep -q '<!-- trailhead' "$STATE_FILE"; then
  # Use a temp file to insert before the version marker line
  TMPFILE="$(mktemp)"
  # Write all lines before the marker, then snapshot, then the marker line
  awk -v snap="$SNAPSHOT" '
    /^<!-- trailhead/ { print snap; print; next }
    { print }
  ' "$STATE_FILE" > "$TMPFILE"
  mv "$TMPFILE" "$STATE_FILE"
else
  printf '%s\n' "$SNAPSHOT" >> "$STATE_FILE"
fi

echo "PRE-COMPACT: State snapshot saved to STATE.md"
exit 0
