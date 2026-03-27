#!/bin/bash
# SessionEnd hook: fires when Claude Code ends a session (all 6 stop matchers).
# Appends a structured log entry to .planning/session-log.md.
# Session log is capped at 100 data rows — oldest entries trimmed when exceeded.

source "$(dirname "$0")/hook-utils.sh"
trap 'log_error "session-end" "$BASH_COMMAND failed (line $LINENO)"; exit 0' ERR

# If .planning/ does not exist, this is not a scaffolded project — nothing to log.
if [ ! -d "$PROJECT_DIR/.planning" ]; then
  exit 0
fi

MATCHER="${1:-unknown}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_LOG="$PROJECT_DIR/.planning/session-log.md"

# Attempt to calculate duration by checking the most recent session start timestamp.
# We look for the last "SESSION START" entry in the log (rows with a recent timestamp)
# but keep it simple — "unknown" is acceptable.
DURATION="unknown"
if [ -f "$SESSION_LOG" ]; then
  # Get the timestamp from the most recent log row (last | row after the header rows).
  LAST_ROW=$(grep '^|' "$SESSION_LOG" | grep -v '^| Timestamp' | grep -v '^|---' | tail -1)
  if [ -n "$LAST_ROW" ]; then
    # Extract the timestamp field (second column between pipes).
    LAST_TS=$(echo "$LAST_ROW" | awk -F'|' '{print $2}' | tr -d ' ')
    if [ -n "$LAST_TS" ] && command -v date >/dev/null 2>&1; then
      # macOS date: use -j -f; Linux date: use -d
      if date --version >/dev/null 2>&1; then
        # GNU date
        LAST_EPOCH=$(date -d "$LAST_TS" +%s 2>/dev/null || echo "")
      else
        # BSD/macOS date
        LAST_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_TS" +%s 2>/dev/null || echo "")
      fi
      NOW_EPOCH=$(date +%s)
      if [ -n "$LAST_EPOCH" ] && [ "$NOW_EPOCH" -gt "$LAST_EPOCH" ] 2>/dev/null; then
        ELAPSED=$(( NOW_EPOCH - LAST_EPOCH ))
        MINS=$(( ELAPSED / 60 ))
        SECS=$(( ELAPSED % 60 ))
        DURATION="${MINS}m${SECS}s"
      fi
    fi
  fi
fi

# Create the log file with header if it does not exist.
if [ ! -f "$SESSION_LOG" ]; then
  cat > "$SESSION_LOG" << 'EOF'
# Session Log

| Timestamp | Type | Duration |
|-----------|------|----------|
EOF
fi

# Append new row.
echo "| $TIMESTAMP | $MATCHER | $DURATION |" >> "$SESSION_LOG"

# Cap at 100 data rows. Count rows that start with | but are not header or separator.
DATA_ROWS=$(grep '^|' "$SESSION_LOG" | grep -v '^| Timestamp' | grep -v '^|---' | wc -l | tr -d ' ')

if [ "$DATA_ROWS" -gt 100 ]; then
  EXCESS=$(( DATA_ROWS - 100 ))
  # Build a new file: keep the header lines, then keep only the last 100 data rows.
  HEADER=$(head -4 "$SESSION_LOG")
  TRIMMED_ROWS=$(grep '^|' "$SESSION_LOG" | grep -v '^| Timestamp' | grep -v '^|---' | tail -100)
  {
    echo "$HEADER"
    echo "$TRIMMED_ROWS"
  } > "$SESSION_LOG"
fi

exit 0
