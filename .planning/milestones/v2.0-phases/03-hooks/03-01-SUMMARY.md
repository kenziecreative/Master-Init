---
phase: 03-hooks
plan: 01
subsystem: infra
tags: [bash, hooks, shell-scripts, compaction, error-handling]

# Dependency graph
requires:
  - phase: 02-settings
    provides: settings.json.tmpl with hook registration patterns
  - phase: 01-foundation
    provides: scaffold directory structure and STATE.md template

provides:
  - hook-utils.sh sourceable library with log_error, is_git_project, read_state_field
  - pre-compact-check.sh upgraded to active STATE.md snapshot save before compaction
  - post-compact-orientation.sh reads STATE.md and outputs orientation after compaction
affects: [03-02, 03-03, 03-04, all remaining phase-03 plans that source hook-utils.sh]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Source pattern: all hooks source hook-utils.sh via `source $(dirname $0)/hook-utils.sh`"
    - "ERR trap pattern: `trap 'log_error hook-name $BASH_COMMAND; exit 0' ERR` in every hook"
    - "Non-git graceful degradation: is_git_project() check before any git operation"
    - "read_state_field() uses awk to extract markdown section content between ## headings"

key-files:
  created:
    - scaffold/hooks/hook-utils.sh
    - scaffold/hooks/post-compact-orientation.sh
  modified:
    - scaffold/hooks/pre-compact-check.sh

key-decisions:
  - "hook-utils.sh is not executable — sourced as library, not run directly"
  - "PROJECT_DIR fallback is pwd (not git rev-parse) so non-git projects resolve correctly"
  - "read_state_field uses awk (not sed) for clean section extraction between ## headings"
  - "pre-compact-check.sh inserts snapshot before knzinit version marker or appends to EOF"
  - "post-compact-orientation outputs cat heredoc for clean multi-line formatting"

patterns-established:
  - "All hooks must source hook-utils.sh as first action after shebang"
  - "All hooks must set ERR trap immediately after sourcing hook-utils.sh"
  - "All hooks must exit 0 always (non-blocking)"
  - "Git operations only inside is_git_project() guard"

requirements-completed: [HOOK-01, HOOK-02, HOOK-06, HOOK-07]

# Metrics
duration: 1min
completed: 2026-03-27
---

# Phase 3 Plan 01: Hook Utility Library and Compaction Recovery Chain Summary

**Shared hook-utils.sh library with log_error/is_git_project/read_state_field plus active PreCompact STATE.md snapshot and PostCompact orientation output**

## Performance

- **Duration:** 1 min
- **Started:** 2026-03-27T21:58:30Z
- **Completed:** 2026-03-27T21:59:54Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Created hook-utils.sh sourceable library establishing the error handling and STATE.md parsing foundation all Phase 3 hooks will use
- Upgraded pre-compact-check.sh from warning-only to active snapshot save: captures timestamp, modified files, and last 3 commits before compaction
- Created post-compact-orientation.sh that reads Current Position, Last Activity, Open Items, and Session Continuity from STATE.md and outputs a structured orientation block after compaction
- Non-git graceful degradation implemented throughout via is_git_project() guard

## Task Commits

Each task was committed atomically:

1. **Task 1: Create hook-utils.sh shared utility library** - `1098806` (feat)
2. **Task 2: Upgrade PreCompact hook and create PostCompact orientation hook** - `2f7d1f7` (feat)

**Plan metadata:** (docs commit — pending)

## Files Created/Modified
- `scaffold/hooks/hook-utils.sh` - Sourceable library: log_error(), is_git_project(), read_state_field()
- `scaffold/hooks/pre-compact-check.sh` - Rewritten: active STATE.md snapshot save before compaction
- `scaffold/hooks/post-compact-orientation.sh` - New: reads STATE.md fields, outputs orientation after compaction

## Decisions Made
- `hook-utils.sh` is not executable (chmod -x) since it is sourced as a library, not invoked directly
- PROJECT_DIR fallback uses `pwd` instead of `git rev-parse --show-toplevel` so non-git projects resolve correctly without errors
- `read_state_field()` uses awk instead of sed for cleaner section boundary detection between `## ` headings
- Snapshot insertion in pre-compact-check.sh uses awk to insert before the `<!-- knzinit` version marker when present, falling back to appending at EOF — preserves the version marker as the last line
- post-compact-orientation.sh uses a `cat <<ORIENTATION` heredoc for clean multi-line output formatting

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- hook-utils.sh is complete and ready for all remaining Phase 3 hooks to source
- ERR trap pattern and non-git guard pattern are established for consistent use
- The compaction recovery chain (PreCompact + PostCompact) is complete and ready to register in settings.json
- Phase 3 plans 02, 03, and 04 can proceed — all will source hook-utils.sh

---
*Phase: 03-hooks*
*Completed: 2026-03-27*
