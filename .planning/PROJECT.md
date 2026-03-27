# knzinit v2

## What This Is

A Claude Code plugin that bootstraps any new project with memory systems, context management, and project structure. v2 rebuilds the scaffold around the platform's actual two-system architecture (instruction system + learning system), expands hook and settings coverage from ~10% to ~60% of the platform surface, and adds first-class non-code project support.

## Core Value

Every Claude Code session starts oriented and every context boundary (compaction, clear, new session) recovers gracefully — regardless of project type.

## Requirements

### Validated

<!-- Shipped and confirmed valuable in v1. -->

- STATE.md pattern for session continuity — validated by three independent practitioners
- Interview-based scaffolding — fills gap that /init cannot address for knowledge work
- Hook-based enforcement for guaranteed behavior
- Skills for repeatable workflows (skill format stable)
- Subagents for isolated investigation

### Active

<!-- Current scope: v2 milestone. See REQUIREMENTS.md for full breakdown. -->

- [ ] Restructure around two-system architecture (replace 5-layer model)
- [ ] Lean root CLAUDE.md with progressive disclosure (under 200 lines)
- [ ] Three-phase compaction recovery (PreCompact + PostCompact + SessionStart)
- [ ] Project-type-specific settings.json (permissions, env, output styles, security baseline)
- [ ] Non-code CLAUDE.md templates (process-encoding content for knowledge work)
- [ ] Session lifecycle hooks (SessionStart orientation, SessionEnd logging)
- [ ] /handoff and /resume skills
- [ ] Verify CLAUDE_PLUGIN_ROOT stability (hard blocker)

### Out of Scope

<!-- Explicit boundaries. -->

- /knzinit refine (iterative CLAUDE.md improvement) — P3, defer to v2.1
- /knzinit upgrade (version-aware re-scaffolding) — P3, depends on version markers shipping first
- Formal template variable substitution — P3, current approach works without reported failures
- claudeMdExcludes for monorepos — P3, specification mechanism not fully documented
- Agent teams hooks — too new, design architecture to accept them later
- New interactive /init flow integration — behind feature flag, wait for stable release
- Plugin marketplace distribution — not elaborated, treat as potentially changing

## Context

**Source material:** 13 audited research outputs in `feature-support/research/outputs/` covering memory architecture, context window economics, hooks, settings, auto-memory, non-code patterns, plugin stability, compaction strategy, blind spots, community practice, and feature backlog. 15 processed sources, 30 backlog items (12 P1, 14 P2, 4 P3).

**Key findings driving v2:**
1. The 5-layer memory model is factually incorrect — platform has two systems (instruction + learning), not five peer layers
2. knzinit configures 3 of 25 hook events and 1 of 13 settings categories
3. PreCompact is non-blocking — compaction strategy must shift to "recover after" via PostCompact + SessionStart
4. Seven sources converge on progressive disclosure: lean root CLAUDE.md with rich supporting files
5. Non-code projects need different content, not simpler scaffolding
6. Every line in CLAUDE.md has measurable cost (+20-23% agent steps, instruction-following degrades at scale)

**Existing codebase:** Working v1 plugin at project root — SKILL.md orchestrator, scaffold/ templates, hooks, agents, settings.json, sanity-check skill. plugin.json manifest at v1.0.0.

## Constraints

- **Platform stability**: Build only on stable platform features (CLAUDE.md hierarchy, .claude/rules/, settings.json, 25 hook events, skill/agent formats). See stability tiers in executive summary.
- **CLAUDE_PLUGIN_ROOT**: Must verify stability before depending on it (B-29). If unstable, add fallback.
- **keep-coding-instructions**: Moderate stability risk — confirmed by practitioner usage but output styles config surface not fully documented. Verify implementation path.
- **CLAUDE.md budget**: Generated root must stay under 200 lines. Every line must pass: (a) can Claude infer this from the project? (b) does this need guaranteed execution? If (a)=yes, cut. If (b)=yes, use a hook.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Replace 5-layer model with two-system architecture | Platform has two memory systems, not five peer layers. 7+ sources confirm. | — Pending |
| Shift compaction from "prevent" to "recover" | PreCompact is non-blocking. PostCompact + SessionStart provide actual recovery points. | — Pending |
| Include all P1 + selected P2 items in v2 | 12 P1 items are must-haves. P2 items (B-09, B-11, B-12, B-13, B-14, B-17, B-18, B-21) add high value at low risk. | — Pending |
| Defer all P3 items to v2.1+ | Low evidence, speculative, or dependent on emerging features | — Pending |
| Four implementation clusters mapping to phases | Natural groupings from backlog with clear dependency order | — Pending |

---
*Last updated: 2026-03-26 after milestone v1.1 initialization*
