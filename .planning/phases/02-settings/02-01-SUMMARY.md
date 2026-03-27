---
phase: 02-settings
plan: 01
subsystem: scaffolding
tags: [settings, permissions, json-schema, project-type, knzinit]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: SKILL.md orchestrator and scaffold template infrastructure used as base for expansion
provides:
  - scaffold/templates/settings.json.tmpl with full platform coverage ($schema, deny rules, allow rules, env block, plansDirectory, hooks)
  - SKILL.md Step 4 with per-section merge-not-overwrite logic and non-code conditional adaptation
affects:
  - 03-compaction
  - 04-recovery
  - any downstream work that installs or generates settings.json via knzinit

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "settings.json template as single source of truth — template contains all sections, SKILL.md adapts conditionally"
    - "Merge-not-overwrite for all settings sections (hooks, deny, allow, env, scalar keys)"
    - "Project-type normalized values: code | noncode | unknown (no spaces, no hyphens)"

key-files:
  created:
    - scaffold/templates/settings.json.tmpl
  modified:
    - skills/knzinit/SKILL.md
  deleted:
    - scaffold/settings.json

key-decisions:
  - "Single template file contains all sections (code/unsure variant); SKILL.md strips allow[] and adds behavior flags for non-code — avoids maintaining two separate templates"
  - "Merge-not-overwrite for every section: hooks append, deny/allow union, env adds-only, scalar keys set-if-absent"
  - "Normalized env.KNZINIT_PROJECT_TYPE values are code/noncode/unknown (no spaces or hyphens) for programmatic use"
  - "Non-code projects get both includeGitInstructions:false and keep-coding-instructions:false; Step 6 report notes how to re-enable git instructions"

patterns-established:
  - "settings.json.tmpl lives in scaffold/templates/ alongside other .tmpl files — consistent with established pattern"
  - "Template contains {{VERSION}} placeholder; SKILL.md substitutes at scaffold time from resolve-root.sh"

requirements-completed: [SETT-01, SETT-02, SETT-03, SETT-04, SETT-05, SETT-06]

# Metrics
duration: 2min
completed: 2026-03-27
---

# Phase 2 Plan 01: Settings Summary

**Full settings.json template with $schema, 7-pattern security deny rules, 10-command allow rules, env metadata, and plansDirectory — plus SKILL.md merge-not-overwrite logic with non-code conditional adaptation**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-27T20:20:14Z
- **Completed:** 2026-03-27T20:21:50Z
- **Tasks:** 2
- **Files modified:** 3 (1 created, 1 modified, 1 deleted)

## Accomplishments

- Created `scaffold/templates/settings.json.tmpl` — full settings template with $schema, permissions.deny (7 secrets patterns), permissions.allow (10 build/test commands), env block (KNZINIT_PROJECT_TYPE + KNZINIT_VERSION placeholder), plansDirectory, and preserved hooks structure
- Removed `scaffold/settings.json` — hooks-only file fully replaced by the new template
- Expanded SKILL.md Step 4 — per-section merge-not-overwrite logic for hooks, deny, allow, env, and scalar keys; plus non-code conditional adaptation (removes allow[], adds includeGitInstructions:false and keep-coding-instructions:false) and version substitution guidance
- Added Step 6 non-code report note advising users how to re-enable git instructions if needed

## Task Commits

Each task was committed atomically:

1. **Task 1: Create expanded settings.json.tmpl and remove old scaffold/settings.json** - `a40c60f` (feat)
2. **Task 2: Update SKILL.md Step 4 with expanded merge logic and non-code conditional adaptation** - `9ef6f30` (feat)

**Plan metadata:** (docs commit — pending)

## Files Created/Modified

- `scaffold/templates/settings.json.tmpl` - Full settings template covering all SETT requirements; the canonical template for knzinit's settings generation
- `skills/knzinit/SKILL.md` - Updated Step 3B path reference, expanded Step 4 merge logic, added Step 6 non-code report note
- `scaffold/settings.json` - Deleted (superseded by template)

## Decisions Made

- Single template contains all sections (code variant); SKILL.md conditionally adapts for non-code rather than maintaining two templates
- Merge-not-overwrite strategy applied section-by-section: hooks append, permissions arrays union, env adds-only, scalar keys set-if-absent
- Normalized project type values (`code`, `noncode`, `unknown`) for use as env var values — no spaces or hyphens
- Both `includeGitInstructions:false` and `keep-coding-instructions:false` for non-code (matched SETT-03 + SETT-04 decision from context phase)

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Settings phase complete. All SETT-01 through SETT-06 requirements addressed.
- Phase 3 (compaction) and Phase 4 (recovery) can proceed — both may reference settings.json structure; the env block (KNZINIT_PROJECT_TYPE, KNZINIT_VERSION) is now available for conditional logic in hooks.
- No blockers.

---
*Phase: 02-settings*
*Completed: 2026-03-27*
