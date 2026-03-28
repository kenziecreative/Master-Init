# Phase 3: Hooks - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Implement complete session lifecycle with compaction recovery and error handling. Every context boundary (compaction, clear, new session) recovers gracefully via a hook chain. All hooks get robust error handling and work in non-git projects. Covers HOOK-01 through HOOK-07.

</domain>

<decisions>
## Implementation Decisions

### Compaction recovery chain (HOOK-01, HOOK-02, HOOK-05)
- PreCompact hook upgraded from warning-only to **active save** — auto-appends a lightweight snapshot to STATE.md (modified files, recent commits, timestamp) before compaction
- PostCompact hook provides **full orientation** — reads STATE.md and outputs: current phase/position, last activity, open items, recent decisions (~10-15 lines)
- PostCompact handles compaction recovery exclusively — SessionStart(compact) is a no-op to avoid duplicate orientation output
- Generated CLAUDE.md includes 2-3 lines: "Before compaction: preserve current task context in STATE.md. After compaction: re-read STATE.md to restore orientation."

### SessionStart orientation (HOOK-03)
- **Same output for all 3 active matchers** (startup, resume, clear) — consistent orientation regardless of session entry point. SessionStart(compact) defers to PostCompact
- Output includes **key fields only**: current phase/position, last activity, and "what a new session needs to know" section from STATE.md (~8-12 lines)
- Uses **command hook** (shell script with grep/sed) — deterministic, fast, no LLM cost, matches existing hook pattern
- **Silent exit** if STATE.md doesn't exist — no output, no error, hook is a no-op until project is scaffolded

### SessionEnd logging (HOOK-04)
- Logs on **all exits** (all 6 matchers) — matcher type captured in entry to distinguish clean vs. abrupt exits
- Each entry captures: **timestamp, matcher (exit type), session duration** — lightweight, factual, no LLM interpretation
- Log lives at **.planning/session-log.md** — version-controlled alongside STATE.md and other planning artifacts
- **Cap at 100 entries** — hook trims oldest entries when exceeded, consistent with STATE.md 20-decision cap pattern

### Error handling (HOOK-06)
- All hooks: **log + stderr + continue** — trap errors, append to .claude/hook-errors.log (timestamp, hook name, error), emit to stderr, exit 0 so hook doesn't block Claude
- **Shared hook-utils.sh** wrapper provides: `log_error()`, `is_git_project()`, `read_state_field()` — all hooks source it for consistent behavior
- `read_state_field()` extracts YAML frontmatter or markdown sections from STATE.md — used by SessionStart, PostCompact, PreCompact

### Non-git support (HOOK-07)
- Single set of hooks with **detect and skip** — each hook checks for .git at the top, skips git-dependent logic if missing
- `is_git_project()` from shared hook-utils.sh provides the check — graceful degradation, not separate hook variants
- Existing hooks (pre-compact-check.sh, milestone-check.sh) retrofitted with this pattern

### Claude's Discretion
- Exact grep/sed patterns for STATE.md field extraction
- Hook script internal structure and variable naming
- PostCompact output formatting within the ~10-15 line budget
- Session duration calculation method (if calculable from available data)
- Hook-errors.log rotation policy (if needed)
- How existing hooks (pre-compact-check.sh, milestone-check.sh, pre-commit-secrets.sh) are refactored vs. rewritten

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scaffold/hooks/pre-compact-check.sh` — Current PreCompact hook (warning-only). Will be upgraded to active-save behavior
- `scaffold/hooks/milestone-check.sh` — Current Stop hook. Needs error handling wrapper and non-git guard
- `scaffold/hooks/pre-commit-secrets.sh` — Current PreToolUse/Bash hook. Needs error handling wrapper
- `scaffold/templates/settings.json.tmpl` — Already registers 3 hooks (PreCompact, Stop, PreToolUse). Will be extended with PostCompact, SessionStart, SessionEnd
- `scaffold/templates/STATE.md.tmpl` — Has structured fields (Current Position, Last Activity, Recent Decisions, Open Items, Session Continuity) that hooks will parse
- `scaffold/resolve-root.sh` — Path resolution pattern that new hooks can reference

### Established Patterns
- All hooks use `$CLAUDE_PROJECT_DIR` for project-local paths
- Hooks use `bash "$CLAUDE_PROJECT_DIR/.claude/hooks/script.sh"` invocation pattern in settings.json
- Git operations use `git -C "$PROJECT_DIR"` pattern with `PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"`
- 10-second timeout on all existing hooks
- Exit code conventions: 0 = success/continue, 2 = block (for blocking events)

### Integration Points
- `settings.json.tmpl` hooks section — new hooks registered here with merge-not-overwrite (Phase 2 decision)
- `CLAUDE.md.tmpl` — add 2-3 compaction instruction lines (HOOK-05)
- `SKILL.md` Step 5 (or equivalent) — hooks installed to `.claude/hooks/` during scaffolding
- `.planning/session-log.md` — new file created by SessionEnd hook

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

*Phase: 03-hooks*
*Context gathered: 2026-03-27*
