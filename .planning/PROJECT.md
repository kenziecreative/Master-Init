# trailhead v2

## What This Is

A Claude Code plugin that bootstraps any project with context management, session lifecycle hooks, and project structure. Built around the platform's two-system architecture (instruction system + learning system), it generates lean CLAUDE.md files with progressive disclosure, full session lifecycle recovery across all context boundaries, and first-class support for both code and non-code projects.

## Core Value

Every Claude Code session starts oriented and every context boundary (compaction, clear, new session) recovers gracefully — regardless of project type.

## Requirements

### Validated

- ✓ Two-system architecture scaffold (instruction + learning systems) — v2.0
- ✓ Lean root CLAUDE.md under 200 lines with progressive disclosure — v2.0
- ✓ Three-phase compaction recovery (PreCompact + PostCompact + SessionStart) — v2.0
- ✓ Project-type-specific settings.json (permissions, env, security baseline) — v2.0
- ✓ Non-code CLAUDE.md templates with process-encoding content — v2.0
- ✓ Session lifecycle hooks (SessionStart orientation, SessionEnd logging) — v2.0
- ✓ /handoff and /resume skills for session continuity — v2.0
- ✓ CLAUDE_PLUGIN_ROOT stability verified with fallback — v2.0
- ✓ MCP template generation for external services — v2.0
- ✓ Decisions archive with overflow warnings — v2.0
- ✓ Error handling on all hooks with .claude/hook-errors.log — v2.0
- ✓ Non-git project support (hooks self-guard) — v2.0
- ✓ STATE.md pattern for session continuity — v1.0
- ✓ Interview-based scaffolding — v1.0
- ✓ Hook-based enforcement for guaranteed behavior — v1.0
- ✓ Skills for repeatable workflows — v1.0

### Active

- [ ] /trailhead refine (iterative CLAUDE.md improvement) — deferred from v2.0
- [ ] /trailhead upgrade (version-aware re-scaffolding) — deferred from v2.0
- [ ] Formal template variable substitution — deferred from v2.0
- [ ] claudeMdExcludes for monorepo projects — deferred from v2.0

### Out of Scope

- Agent teams hooks (TaskCreated, TaskCompleted, TeammateIdle) — too new, architecture accepts later
- New interactive /init flow integration — behind feature flag, wait for stable release
- Plugin marketplace distribution — not elaborated, potentially changing
- AI-specific security patterns (prompt injection, context leakage) — insufficient evidence
- Context budget monitoring API — platform limitation, no hook/setting exposes utilization

## Context

**Shipped v2.0** with 12,328 LOC across shell scripts, markdown templates, JSON templates, and skills. Tech stack: Bash (hooks, path resolution), Markdown templates with conditional markers, JSON templates, Claude Code plugin format (SKILL.md orchestrator, plugin.json manifest).

**Architecture:** Two-system scaffold — instruction system (CLAUDE.md + .claude/rules/) for static behavioral instructions, learning system (STATE.md + auto-memory) for dynamic session state. Generated root CLAUDE.md stays under 200 lines with detail in supporting files.

**Session lifecycle:** 6 hook events registered (PreCompact, PostCompact, SessionStart x4 matchers, SessionEnd, Stop, PreToolUse). Compaction recovery shifted from "prevent" to "recover after" via PostCompact + SessionStart orientation.

**Project types:** Code, non-code, and unknown variants with differentiated templates, interview questions, settings, and health checks. Non-code projects encode workflow processes rather than programming conventions.

**Tech debt (v2.0):** 6 minor documentation/cosmetic items — SKILL.md sentinel mismatch, README directory tree stale entry, duplicate hook install instruction, unconditional git-hook registration, missing SUMMARY frontmatter, misattributed template placeholder. All non-blocking.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Replace 5-layer model with two-system architecture | Platform has two memory systems, not five peer layers. 7+ sources confirm. | ✓ Good |
| Shift compaction from "prevent" to "recover" | PreCompact is non-blocking. PostCompact + SessionStart provide actual recovery points. | ✓ Good |
| Include all P1 + selected P2 items in v2 | 12 P1 items are must-haves. P2 items add high value at low risk. | ✓ Good |
| Defer all P3 items to v2.1+ | Low evidence, speculative, or dependent on emerging features | ✓ Good |
| Single settings.json.tmpl with conditional adaptation | One template with SKILL.md conditionals vs maintaining two separate templates | ✓ Good |
| Merge-not-overwrite for settings sections | Hooks append, deny/allow union, env adds-only, scalar keys set-if-absent | ✓ Good |
| resolve-root.sh with CLAUDE_PLUGIN_ROOT fallback | Walk-up to .claude-plugin/plugin.json if env var missing. Avoids jq dependency. | ✓ Good |
| /handoff writes directly to STATE.md | Single source of truth for session state, not a separate handoff file | ✓ Good |
| README rewrite from scratch for v2 | Too many interlocking stale references for safe incremental patching | ✓ Good |
| Conditional markers as orchestrator instructions | SKILL.md strips IF/ENDIF markers and includes only matching variant | ✓ Good |

---
*Last updated: 2026-03-28 after v2.0 milestone*
