# Phase 1: Foundation - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Resolve CLAUDE_PLUGIN_ROOT blocker and restructure CLAUDE.md templates around the platform's two-system architecture with progressive disclosure. Covers INFR-01, INFR-02, INFR-05, ARCH-01, ARCH-02, ARCH-03, ARCH-04.

</domain>

<decisions>
## Implementation Decisions

### Two-system architecture (ARCH-01)
- Generated CLAUDE.md explicitly names the two systems: "instruction system" (CLAUDE.md, .claude/rules/, settings, hooks) and "learning system" (STATE.md, auto memory)
- 2-3 lines for each system explaining what belongs where
- LEARNINGS.md is eliminated — its content merges into auto memory entries. No separate learnings file in v2
- STATE.md classified under the learning system (evolving state, not static instructions). Hooks handle the "read at session start" behavior
- SKILL.md orchestrator shows a brief 3-4 line summary of the two-system architecture after scaffolding completes

### Progressive disclosure (ARCH-02, ARCH-03)
- Root CLAUDE.md = identity + pointers only. Project identity, two-system explanation, session protocol, auto-memory guidance, key file pointers. Everything else deferred
- Coding/workflow conventions, guardrails, and edge cases go to .claude/rules/ files, not root
- /knzinit generates 1-2 starter .claude/rules/ files based on project type (e.g., session-protocol.md, conventions.md for code projects) to give users a pattern to follow
- First third of generated CLAUDE.md contains: session start protocol ("read STATE.md") + two-system explanation. These are the critical behavioral instructions (ARCH-03)
- Auto-memory guidance is concise inline: 3-5 lines covering 200-line cap, index+topic pattern, machine-local scope, STATE.md preferred for critical state (ARCH-04)

### CLAUDE_PLUGIN_ROOT fallback (INFR-01)
- Runtime detection with fallback: check if CLAUDE_PLUGIN_ROOT is set, use it if available, otherwise derive path dynamically
- Dynamic discovery for fallback: walk up from executing skill/hook file to find plugin root, or search known plugin directories
- Ship the fallback code regardless of stability research results — defensive coding

### Version markers (INFR-02)
- HTML comment at bottom of each generated file: `<!-- knzinit v2.0.0 -->`
- Footer position — unobtrusive, doesn't affect rendering or instruction ordering
- Version pulled from plugin.json at scaffold time — single source of truth, no hardcoded versions in templates

### Scope-restricted settings guidance (INFR-05)
- 2-3 inline lines in the auto-memory section of generated CLAUDE.md noting that autoMemoryDirectory and autoMode must be set in user settings, not project settings
- Document only — /knzinit does not prompt to configure or modify user-level settings during scaffolding

### Claude's Discretion
- Exact wording of the two-system explanation within the decided structure
- Specific .claude/rules/ file names and content for each project type
- Dynamic path resolution implementation details
- Template line count allocation within the <200 line budget

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scaffold/templates/CLAUDE.md.tmpl` — Current template (~42 lines, uses 5-layer model). Will be rewritten for two-system architecture
- `scaffold/templates/STATE.md.tmpl` — Current STATE.md template (~30 lines). References will need updating to remove 5-layer language
- `scaffold/templates/LEARNINGS.md.tmpl` — Will be removed (content merges into auto memory)
- `skills/knzinit/SKILL.md` — Orchestrator that drives scaffolding. References "5-layer memory system" throughout — needs updating
- `.claude-plugin/plugin.json` — Version source for markers. Currently at v1.0.0

### Established Patterns
- SKILL.md uses `${CLAUDE_PLUGIN_ROOT}` for template path resolution — this is the variable we need to verify/fallback
- Templates use `{{VARIABLE}}` placeholder syntax (e.g., `{{PROJECT_NAME}}`, `{{DATE}}`) — Claude substitutes at scaffold time
- scaffold/settings.json defines hook configurations — hooks reference `$CLAUDE_PROJECT_DIR` for project-local paths

### Integration Points
- `plugin.json` version field → version markers in generated files
- `SKILL.md` Step 3A "Five-Layer Memory System" → must become two-system architecture
- `SKILL.md` template references (`${CLAUDE_PLUGIN_ROOT}/scaffold/templates/`) → need fallback wrapping
- scaffold/hooks/*.sh → remain as-is for Phase 1, but SKILL.md description of them changes

</code_context>

<specifics>
## Specific Ideas

No specific references or "I want it like X" moments — decisions were made on recommended approaches throughout.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-foundation*
*Context gathered: 2026-03-27*
