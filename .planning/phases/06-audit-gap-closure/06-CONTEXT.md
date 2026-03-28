# Phase 6: Audit Gap Closure - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Fix all documentation inconsistencies, SKILL.md instruction gaps, and template polish issues identified in the v2.0 milestone audit. Closes INT-01 through INT-09, FLOW-B, FLOW-C. No new capabilities — purely corrective.

</domain>

<decisions>
## Implementation Decisions

### README.md rewrite (INT-01)
- Full rewrite to reflect two-system architecture (instruction system + learning system)
- Remove all 5-layer model references, 5-layer table, LEARNINGS.md.tmpl mentions
- Update directory tree to match actual v2 scaffold structure (settings.json.tmpl in scaffold/templates/, no scaffold/settings.json)
- Update adaptive behavior table to reflect universal session hooks for all project types
- Keep README structure/sections similar — just update content to match v2 reality

### SKILL.md hooks directory for all projects (INT-02 / FLOW-B)
- Step 3D must create .claude/hooks/ unconditionally, not gated on git
- Session hooks (session-start.sh, session-end.sh, hook-utils.sh, pre-compact-check.sh, post-compact-orientation.sh) install for all projects
- Git-only hooks (pre-commit-secrets.sh, milestone-check.sh) still gated on git detection

### {{DATE}} substitution instruction (INT-03)
- Add explicit {{DATE}} substitution instruction in SKILL.md alongside existing {{PROJECT_NAME}} and {{VERSION}} instructions
- Same substitution step, same format — just an omitted placeholder

### SKILL.md Step 3B path fix (INT-04)
- Remove redundant scaffold/ prefix from skill install paths
- Paths should be relative to ${KNZINIT_ROOT}/scaffold/ base, not ${KNZINIT_ROOT}/scaffold/scaffold/

### SessionEnd matcher argument (INT-05 / FLOW-C)
- Pass matcher argument from settings.json.tmpl to session-end.sh via hook command
- session-end.sh already has logic to use the argument — just needs the registration to provide it
- Each SessionEnd matcher registration passes its own type: e.g., bash "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end.sh" "exit"

### Field name alignment (INT-06)
- session-protocol.md.tmpl "Stopped at" → rename to match STATE.md.tmpl's actual field name "Current Position"
- STATE.md.tmpl is the source of truth (hooks parse it); session-protocol.md.tmpl is documentation that must match

### resolve-root.sh documentation alignment (INT-07)
- Align SKILL.md documentation with actual resolve-root.sh fallback paths
- resolve-root.sh is the source of truth; documentation follows implementation

### pre-commit-secrets.sh comment fix (INT-08)
- Update comment to accurately describe trigger: PreToolUse hook that checks staged files, not just "git commit"
- Clarify it's a no-op in non-git projects (this is already coded, comment just misrepresents it)

### mcp.json.tmpl format fix (INT-09)
- Remove // JavaScript comments (invalid JSON) — replace with "_comment" keys if context is needed, or strip comments entirely
- Version marker changed from // comment to standard HTML comment format: <!-- knzinit v{{VERSION}} -->
- Wait — HTML comments are also invalid JSON. Use "_knzinit_version": "{{VERSION}}" as a JSON-native version marker instead

### Claude's Discretion
- README.md exact wording and section structure within the two-system framework
- Whether mcp.json.tmpl needs inline documentation comments at all (or if SKILL.md context is sufficient)
- Exact wording of updated pre-commit-secrets.sh comment
- How to phrase the {{DATE}} substitution instruction in SKILL.md

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `README.md` — ~90 lines, needs content rewrite but structure can be preserved
- `skills/knzinit/SKILL.md` — Central orchestrator, multiple sections need targeted edits
- `scaffold/templates/settings.json.tmpl` — SessionEnd hook registration needs matcher arg added
- `scaffold/templates/rules/session-protocol.md.tmpl` — Field name reference update
- `scaffold/templates/mcp.json.tmpl` — Comment format and version marker fix
- `scaffold/hooks/pre-commit-secrets.sh` — Comment-only fix

### Established Patterns
- Version markers: `<!-- knzinit v{{VERSION}} -->` HTML comment for markdown/HTML files; needs JSON-native approach for .json files
- Template variable syntax: `{{VARIABLE}}` — Claude substitutes at scaffold time
- SKILL.md uses `${KNZINIT_ROOT}/scaffold/` as base path for all template references

### Integration Points
- SKILL.md Step 3D → .claude/hooks/ directory creation (remove git gate)
- SKILL.md Step 3B → skill install path correction
- SKILL.md Step 3A → add {{DATE}} to substitution instructions
- settings.json.tmpl → SessionEnd hook command string (add matcher arg)
- session-protocol.md.tmpl → field name must match STATE.md.tmpl

</code_context>

<specifics>
## Specific Ideas

No specific requirements — user deferred all decisions to Claude's judgment. All fixes are mechanical corrections identified by the milestone audit.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 06-audit-gap-closure*
*Context gathered: 2026-03-27*
