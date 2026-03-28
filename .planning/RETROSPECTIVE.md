# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v2.0 — Two-System Architecture

**Shipped:** 2026-03-28
**Phases:** 6 | **Plans:** 13

### What Was Built
- Two-system architecture scaffold replacing 5-layer model (CLAUDE.md.tmpl, STATE.md.tmpl, rules templates)
- Complete session lifecycle: 6 hook events (PreCompact, PostCompact, SessionStart x4, SessionEnd, Stop, PreToolUse)
- Project-type-aware settings.json with schema validation, security baselines, merge-not-overwrite logic
- Non-code project support: differentiated templates, interview flow, health checks
- /handoff and /resume skills for structured session continuity
- MCP template generation and decisions archive with overflow warnings
- Full audit gap closure: README rewrite, SKILL.md fixes, template polish

### What Worked
- Phase-based execution with clear dependency ordering kept work focused and composable
- Single settings.json.tmpl with conditional adaptation (vs maintaining two templates) reduced complexity significantly
- Audit-then-fix pattern (Phase 6 closing audit gaps) caught 9 integration issues that would have shipped as doc bugs
- 3-source cross-reference in milestone audit (VERIFICATION.md + SUMMARY frontmatter + REQUIREMENTS.md) gave high confidence in 28/28 requirement coverage
- Merge-not-overwrite pattern for settings prevented destructive overwrites — good foundational decision

### What Was Inefficient
- STATE.md performance metrics section was never updated during execution — the velocity data format was wrong from the start and accumulated stale entries
- Nyquist validation was skipped entirely across all 6 phases — VALIDATION.md files never created
- Some SUMMARY.md files missing `requirements_completed` frontmatter (Phase 4) — inconsistent tracking across plans

### Patterns Established
- Conditional comment markers (`<!-- IF noncode -->` / `<!-- ENDIF -->`) as orchestrator-strippable instructions in templates
- hook-utils.sh as sourceable library (not executable) with log_error, is_git_project, read_state_field
- resolve-root.sh walk-up pattern: env var → dynamic walk-up → known-dir fallback
- Session lifecycle chain: PreCompact save → PostCompact orient → SessionStart orient → SessionEnd log
- "Recover after" compaction strategy instead of "prevent" — pragmatic acceptance of platform behavior

### Key Lessons
1. Audit before ship catches real issues — Phase 6 (audit gap closure) found and fixed 9 doc/template inconsistencies that the main phases missed
2. Single-template-with-conditionals beats multi-template — conditional markers are more maintainable than duplicate files even though they're slightly harder to read
3. README should be rewritten from scratch when the underlying model changes — incremental patching of the 5-layer→two-system transition would have left ghost references
4. Non-code project support requires different content, not simpler content — the interview, templates, and health checks all needed substantive variants, not just fewer features

### Cost Observations
- Sessions: ~13 (one per plan execution + planning sessions)
- Notable: 3-day turnaround for 28 requirements across 6 phases — high throughput from clear requirements and dependency-ordered execution

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Phases | Plans | Key Change |
|-----------|--------|-------|------------|
| v2.0 | 6 | 13 | First milestone with audit gap closure phase and 3-source requirement cross-reference |

### Top Lessons (Verified Across Milestones)

1. Audit before ship catches real issues — verified in v2.0 (Phase 6 found 9 fixable items)
2. Single-template-with-conditionals beats multi-template — verified in v2.0 (settings.json.tmpl, CLAUDE.md.tmpl)
