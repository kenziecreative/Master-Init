---
phase: 06-audit-gap-closure
plan: "01"
subsystem: documentation
tags: [readme, architecture, two-system, v2]

requires: []
provides:
  - "README.md accurately describes v2 two-system architecture"
  - "All stale 5-layer model references removed"
  - "Directory tree matches actual scaffold file structure"
  - "Adaptive behavior table reflects universal session hooks"
affects: [all-phases, onboarding, public-docs]

tech-stack:
  added: []
  patterns:
    - "README documents two-system architecture (instruction + learning) as primary concept"

key-files:
  created: []
  modified:
    - README.md

key-decisions:
  - "README rewritten from scratch rather than patched — too many interlocking stale references to safely patch incrementally"

patterns-established:
  - "README structure: intro, plugin structure tree, what it does, where it fits, skills, what it scaffolds (instruction system + learning system), security agents, hooks, adaptive behavior table, extending"

requirements-completed:
  - INT-01

duration: 1min
completed: 2026-03-28
---

# Phase 6 Plan 01: README v2 Rewrite Summary

**README.md rewritten for v2 two-system architecture, replacing 5-layer model, stale file listings, and outdated adaptive behavior table with accurate v2 content**

## Performance

- **Duration:** 1 min
- **Started:** 2026-03-28T12:49:13Z
- **Completed:** 2026-03-28T12:50:49Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Replaced 5-layer model description with two-system architecture (instruction + learning)
- Updated directory tree to match actual v2 scaffold structure (added hook-utils.sh, post-compact-orientation.sh, session-start.sh, session-end.sh; removed LEARNINGS.md.tmpl and scaffold/settings.json)
- Added /handoff and /resume skill descriptions alongside /sanity-check
- Listed all 7 v2 hooks with correct event triggers and descriptions
- Replaced 3-row adaptive behavior table with 4-row table covering all project type combinations, with universal session hooks for all rows
- Updated Extending section to reference scaffold/templates/settings.json.tmpl (not scaffold/settings.json)
- Removed all stale references: LEARNINGS.md, 5-layer, Layer 1/2/3/4/5 terminology

## Task Commits

Each task was committed atomically:

1. **Task 1: Rewrite README.md for v2 two-system architecture** - `28866b5` (feat)

**Plan metadata:** (to be added in final commit)

## Files Created/Modified
- `README.md` - Rewritten to accurately describe v2 two-system architecture

## Decisions Made
- README rewritten from scratch rather than patched. The stale content was deeply interwoven (5-layer model appeared in the opening, the scaffold tree, the "What It Scaffolds" section heading, the table, and the adaptive behavior table). Patch-in-place would have required touching nearly every section anyway.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- INT-01 closed: README.md now accurately describes v2 architecture
- Remaining audit gap plans (06-02 through 06-07) are ready to execute independently
- No blockers introduced

---
*Phase: 06-audit-gap-closure*
*Completed: 2026-03-28*

## Self-Check: PASSED

- README.md: FOUND
- 06-01-SUMMARY.md: FOUND
- Commit 28866b5: FOUND
