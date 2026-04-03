---
name: handoff
description: Capture current session state to STATE.md for seamless session transitions
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

# /handoff — Session Handoff

Capture what happened this session so the next session (or a different context window) can pick up without re-explanation. This writes directly to STATE.md -- the single source of truth for session continuity.

## What to Capture

Update these sections in `.planning/STATE.md`:

### 1. Session Context (`## Session Context`)
Update with current active task, open questions, and what's being waited on. This is ephemeral — it reflects the conversation state right now.

### 2. What was done (`## Session Continuity`)
Write a structured summary with: completed work (be specific — file names, not "updated some files"), what's in progress, immediate next steps, and open questions/blockers.

### 3. Workflow State (`## Workflow State`, if present)
If the project has a Workflow State table (Durable+ complexity), update step statuses: mark completed steps, note any steps that moved to `waiting` or `failed`. If this section doesn't exist (Lean projects), skip — the Session Continuity summary is sufficient.

### 4. Supporting updates
- Update `## Current Position` to reflect where things actually are
- Update `## Last Activity` with today's date and a brief description
- Append any decisions made this session to `## Recent Decisions`
- Move persistent blockers to `## Open Items` (not just Session Continuity)

## How to Write It

1. Read the current `.planning/STATE.md`
2. Update `## Session Context` with current conversation state
3. Replace the content under `## Session Continuity` with the done/in-progress/next/blockers summary
4. If `## Workflow State` exists, update step statuses in the table
5. Update `## Current Position`, `## Last Activity`, and `## Recent Decisions`

**Keep it concise.** Each section: 2-5 bullet points. The goal is orientation, not a full session transcript.

**Works for all project types and complexity levels.** Lean projects skip the Workflow State table. Everything else is universal.

## When to Run

- Before ending a work session
- Before clearing context on a long session
- When switching to a different area of the project
- Anytime you want to checkpoint progress
