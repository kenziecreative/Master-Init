# Phase 4: Non-Code and Skills - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Non-code projects (research, writing, strategy, process work) get templates, interview questions, health checks, and STATE.md fields that match their actual workflows. Plus /handoff and /resume skills for all project types. Covers NCODE-01, NCODE-02, NCODE-03, NCODE-04, SKIL-01, SKIL-02.

</domain>

<decisions>
## Implementation Decisions

### Non-code CLAUDE.md content (NCODE-01)
- Focus on **workflow encoding** — how work flows through stages, what recurring decisions look like, what "done" means for each deliverable type
- Conditional sections within existing CLAUDE.md.tmpl — follows Phase 2's "single template + conditional adaptation" pattern
- Non-code projects replace "Project Structure" section with two new sections:
  - **Work Stages** — how deliverables move from draft to done, checkpoints
  - **Session Patterns** — what a typical session looks like, what Claude should default to doing
- **Session Discipline** reminder always included for non-code projects (2-3 lines reminding to update STATE.md) — non-code projects lack git commits as natural save points

### Non-code interview questions (NCODE-02)
- Branch happens **after Step 1** — when user answers "non-code", a new Step 1B asks 3-4 workflow-specific questions before Step 2
- Questions (all accept "not sure yet"):
  1. What does a typical work session look like?
  2. What are your main deliverables/outputs?
  3. What decisions come up repeatedly?
  4. Any domain terminology Claude should know?
- Step 2 ("Explore What Exists") still runs for non-code but **adapted** — skips language/framework detection and security tooling checks
- "Not sure yet" project type continues to default to code variant (consistent with Phase 2 decision)

### Non-code health checks (NCODE-03)
- Single adaptive `/sanity-check` skill — reads `KNZINIT_PROJECT_TYPE` from `.claude/settings.json` env block to determine behavior
- For non-code projects, "Code Health" section replaced with **Deliverable Currency**: are WIP deliverables referenced in STATE.md? Are open items still relevant? Does "Work Stages" in CLAUDE.md reflect where things actually are?
- Stale `LEARNINGS.md` reference updated to auto memory check: is MEMORY.md populated? Are entries relevant? (Aligns with v2 two-system architecture)
- Falls back to code behavior if `KNZINIT_PROJECT_TYPE` is missing from settings

### Non-code STATE.md template (NCODE-04)
- STATE.md varies by project type with domain-appropriate fields
- Non-code variant replaces "Establish tech stack" open item with workflow-appropriate items (e.g., "Define deliverables and quality bar", "Map recurring decisions")
- Session Continuity section structure stays the same (used by hooks and /handoff)

### /handoff skill (SKIL-01)
- Writes **4-section structured summary** directly to STATE.md's "Session Continuity" section:
  1. What was done this session
  2. What's in progress
  3. What's next
  4. Open questions/blockers
- Updates STATE.md directly — single source of truth, no separate handoff file
- Works for all project types (code, non-code, unknown)

### /resume skill (SKIL-02)
- **Concise orientation** output: 8-15 lines covering current position, last activity, in-progress work, next steps, open questions
- **Superset of SessionStart hook** — hook gives basic orientation (phase, position, last activity); /resume adds handoff summary, recent decisions, and changes since last session (git log if available)
- User runs /resume when they want MORE context than the automatic hook provided
- Works for all project types

### Claude's Discretion
- Exact wording of non-code CLAUDE.md workflow sections
- How SKILL.md implements the Step 1B branch (inline conditional or separate section)
- STATE.md non-code template field names and placeholder content
- /handoff and /resume SKILL.md internal structure
- How /resume formats the superset output (sections, bullets, table)

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scaffold/templates/CLAUDE.md.tmpl` — Current template with "Project Structure" section that needs non-code conditional replacement
- `scaffold/templates/STATE.md.tmpl` — Current template with code-oriented open items; needs non-code variant fields
- `skills/knzinit/SKILL.md` — Step 1 already asks project type; Step 2 needs adaptation; Step 3B skips security agents for non-code
- `scaffold/skills/sanity-check/SKILL.md` — Current 3-section check needs Code Health → Deliverable Currency swap and LEARNINGS.md fix
- `scaffold/templates/settings.json.tmpl` — Contains `KNZINIT_PROJECT_TYPE` env var that sanity-check reads at runtime

### Established Patterns
- Single template + conditional adaptation in SKILL.md (Phase 2 pattern) — same approach for CLAUDE.md and STATE.md non-code variants
- SKILL.md uses `${KNZINIT_ROOT}/scaffold/` for template paths
- Skills use SKILL.md frontmatter format with `name` and `description` fields
- Hooks read STATE.md via `read_state_field()` from `hook-utils.sh` — /resume can use similar extraction

### Integration Points
- `SKILL.md` Step 1 → project type answer drives Step 1B branch and all conditional adaptation
- `settings.json` env.KNZINIT_PROJECT_TYPE → runtime detection for sanity-check
- `STATE.md` Session Continuity section → written by /handoff, read by /resume and SessionStart hook
- `.claude/skills/` directory → /handoff and /resume installed here during scaffolding

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 04-non-code-and-skills*
*Context gathered: 2026-03-27*
