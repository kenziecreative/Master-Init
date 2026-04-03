---
name: sanity-check
description: Verify project health and surface findings by severity before context clear, milestone completion, or deployment
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash
---

# /sanity-check

Run this to verify the project is in a clean, consistent state. This check adapts to the current state of the project — it only checks what exists. It also adapts to the project's complexity level to check the right things.

## Detection

**Detect project type:** Read `TRAILHEAD_PROJECT_TYPE` from `.claude/settings.json` env block. If missing or set to `code`/`unknown`, use code behavior. If set to `noncode`, use non-code behavior.

**Detect complexity level:** Read `TRAILHEAD_COMPLEXITY_LEVEL` from `.claude/settings.json` env block. Default to `lean` if missing.

## Behavior

### 1. Project Health

**Code projects (code/unknown/missing):**
- **Compilation/type check**: Run the project's build or type-check command
- **Test suite**: Run tests if a test framework is configured
- **Lint**: Run the linter if configured
- **Debug artifacts**: Scan for console.log/print statements, TODO/FIXME/HACK comments, hardcoded localhost URLs, hardcoded file paths containing /Users/ or /home/

If no build/test/lint commands are established yet, skip and note: "Code health checks will activate once build tooling is configured."

**Non-code projects (noncode):**
- **Deliverable Currency**: Are WIP deliverables referenced in STATE.md still active? Are open items still relevant?
- **Work Stages accuracy**: Does the "Work Stages" section in CLAUDE.md reflect where things actually are?
- **Stale references**: Are there references to completed or abandoned deliverables that should be archived?

### 2. Documentation Currency

Read and verify these files are current (check whichever exist):

1. **`.planning/STATE.md`** — Does the current position match reality? Is the last activity date current?
   - **Decisions overflow:** Count the entries in the Recent Decisions table. If more than 20 entries, warn: "STATE.md has {N} decisions (cap: 20). Archive the oldest {N-20} to `.planning/decisions-archive.md` to keep STATE.md lean."
2. **`CLAUDE.md`** — Does it reflect the actual project state?
3. **Auto memory (MEMORY.md)** — Is it populated? Are entries relevant and not stale?

### 3. Context Handoff

Verify that a fresh session would understand the project:

1. Read `CLAUDE.md` — does it point to the right starting docs?
2. Read `.planning/STATE.md` — would a new session know where to resume?
3. Are there implicit decisions from this session that need documenting?

### 4. Complexity-Specific Checks

**Durable+ projects (durable, extensible, multi-agent):**
- Is `## Workflow State` present in STATE.md? If missing, flag it.
- Are any steps stuck in "executing" status? (Likely stale from a previous session.)
- Are there completed steps with no corresponding entry in Recent Decisions?
- Is `## Evaluation Plan` still just placeholder checkboxes? (Flag as info after first milestone.)

**Extensible+ projects (extensible, multi-agent):**
- Are integration points documented in CLAUDE.md or STATE.md?
- Are there external service references without corresponding `.mcp.json` entries?

**Lean projects:**
- No additional checks beyond the standard ones.

### 5. Report

Output findings sorted by severity, highest first. For each finding:

```
**[severity] Finding title**
Why it matters: [one sentence explaining impact]
Fix: [concrete next action]
```

**Severity levels:**
- **critical** — Blocks the next session or risks losing work (e.g., STATE.md not updated, secrets exposed, workflow state inconsistent)
- **warning** — Quality drift accumulating (e.g., stale decisions, outdated CLAUDE.md, eval plan still empty)
- **info** — Improvement opportunity, no immediate risk (e.g., could add more golden tasks, workflow state section unused)

If no findings: **"Sanity check clean. No issues found."**

End with a one-line summary: **`X critical, Y warnings, Z info`**

## When to Run

- Before clearing context on a long session
- Before starting a new major task or milestone
- After a significant refactoring or architectural change
- When something feels "off" about the project state
