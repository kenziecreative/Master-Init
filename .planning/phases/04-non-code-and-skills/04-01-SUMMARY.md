---
phase: 04-non-code-and-skills
plan: 01
subsystem: templates, skills
tags: [non-code, templates, sanity-check, conditional-sections]
dependency_graph:
  requires: []
  provides: [non-code-template-support, adaptive-sanity-check]
  affects: [scaffold/templates/CLAUDE.md.tmpl, scaffold/templates/STATE.md.tmpl, scaffold/skills/sanity-check/SKILL.md]
tech_stack:
  added: []
  patterns: [conditional-comment-markers, KNZINIT_PROJECT_TYPE-adaptive-behavior]
key_files:
  created: []
  modified:
    - scaffold/templates/CLAUDE.md.tmpl
    - scaffold/templates/STATE.md.tmpl
    - scaffold/skills/sanity-check/SKILL.md
decisions:
  - "Conditional markers (<!-- IF noncode --> / <!-- IF code/unknown --> / <!-- ENDIF -->) are orchestrator instructions, not HTML output — SKILL.md strips them and includes only the matching variant"
  - "Session Discipline block placed between Key Files and the structural section so it appears in non-code projects as a behavioral reminder before the workflow sections"
  - "LEARNINGS.md replaced with auto memory (MEMORY.md) throughout sanity-check to align with v2 two-system architecture"
metrics:
  duration: ~5 min
  completed_date: 2026-03-27
  tasks_completed: 2
  files_modified: 3
---

# Phase 4 Plan 1: Non-code Template and Sanity-Check Adaptation Summary

Non-code conditional sections added to CLAUDE.md.tmpl and STATE.md.tmpl using IF/ENDIF orchestrator markers, and sanity-check SKILL.md made adaptive via KNZINIT_PROJECT_TYPE detection with Deliverable Currency checks replacing Code Health for non-code projects.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Add non-code conditional sections to CLAUDE.md.tmpl and STATE.md.tmpl | 1608002 | scaffold/templates/CLAUDE.md.tmpl, scaffold/templates/STATE.md.tmpl |
| 2 | Make sanity-check adaptive and fix LEARNINGS.md reference | 9a1c849 | scaffold/skills/sanity-check/SKILL.md |

## What Was Built

**CLAUDE.md.tmpl** gained three non-code conditional blocks wrapped in `<!-- IF noncode -->` / `<!-- ENDIF -->` markers:
- Session Discipline — reminder to update STATE.md as substitute for git commit save points
- Work Stages — placeholder for documenting deliverable lifecycle stages
- Session Patterns — placeholder for describing typical session workflow

The existing Project Structure section was wrapped in `<!-- IF code/unknown -->` / `<!-- ENDIF -->` so it only appears for code projects.

**STATE.md.tmpl** Open Items section now has two conditional variants: the original code-oriented items under `<!-- IF code/unknown -->`, and a non-code variant under `<!-- IF noncode -->` with four domain-appropriate items (scope, deliverables/quality bar, recurring decisions, session workflow).

**sanity-check/SKILL.md** was rewritten to be adaptive:
- Section 1 renamed from "Code Health" to "Project Health" with KNZINIT_PROJECT_TYPE detection logic
- Code project checks preserved unchanged under the code/unknown/missing branch
- Non-code branch added with Deliverable Currency, Work Stages accuracy, and Stale references checks
- LEARNINGS.md reference in Documentation Currency replaced with Auto memory (MEMORY.md)
- Summary table updated: "Code Health" row renamed to "Project Health"

## Decisions Made

1. Conditional markers (`<!-- IF noncode -->`, `<!-- IF code/unknown -->`, `<!-- ENDIF -->`) serve as orchestrator instructions — the SKILL.md for init will strip them and include only the matching variant. They follow the Phase 2 pattern of single-template + conditional adaptation.

2. Session Discipline placed between Key Files and structural sections so non-code users see the behavioral reminder immediately before the workflow-defining sections (Work Stages, Session Patterns).

3. LEARNINGS.md replaced with auto memory (MEMORY.md) to fully align with the v2 two-system architecture decision made in Phase 1 (LEARNINGS.md.tmpl was deleted in Phase 1).

## Deviations from Plan

None - plan executed exactly as written.

## Verification

All success criteria passed:
- `grep` confirms Work Stages, Session Patterns, Session Discipline in CLAUDE.md.tmpl
- `grep` confirms non-code Open Items (recurring decisions) in STATE.md.tmpl
- `grep` confirms Deliverable Currency and KNZINIT_PROJECT_TYPE in sanity-check SKILL.md
- `grep` confirms LEARNINGS.md is absent from sanity-check SKILL.md
- Version markers (`<!-- knzinit v{{VERSION}} -->`) preserved in both templates

## Self-Check: PASSED

Files exist:
- scaffold/templates/CLAUDE.md.tmpl - FOUND
- scaffold/templates/STATE.md.tmpl - FOUND
- scaffold/skills/sanity-check/SKILL.md - FOUND

Commits exist:
- 1608002 - feat(04-01): add non-code conditional sections
- 9a1c849 - feat(04-01): make sanity-check adaptive
