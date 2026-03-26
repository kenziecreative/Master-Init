---
name: knzinit
description: Bootstrap a new project with 5-layer memory system, security agents, and sanity checks
---

# /knzinit — Project Scaffolding

You are setting up the standard project infrastructure for a new project. This scaffolding is supplemental — it works alongside orchestrators like GSD, not as a replacement. Its purpose is to catch what falls through the cracks: security issues, exposed secrets, documentation drift, and lost context between sessions.

## Step 1: Orientation

Ask the user these three questions. **All three accept "not sure yet" as a valid answer.** Do not force the user down a path — if they don't know, build a flexible foundation that works either way.

1. **What is this project?** (Even a vague idea is fine. "I'm exploring an idea" is a valid answer.)
2. **Is this a code project, a non-code project, or not sure yet?**
3. **Is this already a git repository?** (Check with `git status` first — if it is, tell them and skip the question. If not, ask if they'd like you to initialize one.)

Wait for answers before proceeding.

## Step 2: Explore What Exists

Before creating anything, check what's already in place:

- Does `CLAUDE.md` exist? (extend, don't replace)
- Does `.planning/` exist? (extend, don't replace)
- Does `.claude/` exist with agents, skills, hooks, or settings? (merge, don't overwrite)
- Does `MEMORY.md` exist in the auto-memory directory? (extend, don't replace)
- What language/framework/package manager is present? (if any code exists)
- Does the project have existing security tooling? (ESLint security plugins, Semgrep, pre-commit hooks, etc.)

If anything substantial exists, ask the user how to integrate rather than replacing it.

## Step 3: Build the Scaffolding

Create everything below, adapting to the user's answers. If the project type is unknown, build the flexible variant that works for both code and non-code.

### 3A: Five-Layer Memory System

Use the templates in `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/` as starting points. Adapt each to the project's specifics.

**Layer 1 — CLAUDE.md** (always loaded)

If CLAUDE.md doesn't exist, create it based on `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/CLAUDE.md.tmpl`. If it does, extend it. Include:

- What the project is (use the user's description, however vague)
- "When Starting a Session" section pointing to STATE.md
- Auto Memory section with save/prune guidelines
- Pointers to the other layer files (.planning/STATE.md, .planning/LEARNINGS.md)
- If non-code or no git: add a "Session Discipline" section reminding Claude to update STATE.md before ending sessions

Target: under 200 lines. If the project is brand new and vague, this will be short — that's fine. It grows as the project takes shape.

**Layer 2 — .planning/STATE.md** (read at session start)

Create based on `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/STATE.md.tmpl` with:

- Current position (if new project: "Project initialized. No work completed yet.")
- Last activity date (today)
- Recent Decisions table (max 20 entries, with note to archive older ones to `.planning/decisions-archive.md`)
- Open items / pending questions
- Session Continuity section

Target: under 60 lines.

**Layer 3 — Auto Memory (MEMORY.md)**

Write an initial MEMORY.md in the auto-memory directory with what's known so far. If almost nothing is known, that's fine — write what you have and note that it will be populated as the project develops.

**Layer 4 — .planning/LEARNINGS.md**

Create based on `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/LEARNINGS.md.tmpl`.

**Layer 5 — Hooks/Guardrails**

**If git repo (or user chose to init one):**

Install hooks from `${CLAUDE_PLUGIN_ROOT}/scaffold/hooks/`:
- `pre-compact-check.sh` → `.claude/hooks/pre-compact-check.sh`
- `milestone-check.sh` → `.claude/hooks/milestone-check.sh`

Register both in `.claude/settings.json` (merge with existing if present) using the pattern in `${CLAUDE_PLUGIN_ROOT}/scaffold/settings.json`.

Make hook scripts executable with `chmod +x`.

**If NOT a git repo and user doesn't want one:** Add the Session Discipline section to CLAUDE.md instead of creating hooks.

### 3B: Security & Sanity Setup

**Only create security agents if this is a code project or the user is unsure.** If explicitly non-code, skip the security scanner and secrets auditor but still create the sanity check.

Install from `${CLAUDE_PLUGIN_ROOT}/scaffold/`:
- `agents/security-scanner.md` → `.claude/agents/security-scanner.md`
- `agents/secrets-env-auditor.md` → `.claude/agents/secrets-env-auditor.md`
- `hooks/pre-commit-secrets.sh` → `.claude/hooks/pre-commit-secrets.sh` (git repos only)

Install the sanity check skill:
- `scaffold/skills/sanity-check/SKILL.md` → `.claude/skills/sanity-check/SKILL.md`

Adapt each to the project's actual language and framework. If unknown, use the generic versions as-is — they include notes about what to update once the stack is established.

Register the pre-commit secrets hook as a PreToolUse hook in `.claude/settings.json` that triggers when a Bash command contains `git commit`.

Make executable with `chmod +x`.

### 3C: .gitignore (if git repo)

Create a `.gitignore` based on `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/gitignore.tmpl` if one doesn't already exist.

If the stack is known, add the appropriate language/framework ignores (node_modules/, __pycache__/, target/, build/, dist/, etc.).

### 3D: Create Directories

Ensure these directories exist:
- `.planning/`
- `.planning/security/` (if code project or unsure)
- `.claude/agents/` (if code project or unsure)
- `.claude/skills/`
- `.claude/hooks/` (if git repo)

## Step 4: Merge Settings

If `.claude/settings.json` already exists, READ it first and merge the new hooks into the existing structure. Never overwrite existing hooks — add alongside them.

If it doesn't exist, create it fresh with all applicable hooks.

## Step 5: Git Commit (if git repo)

If this is a git repo, stage and commit everything with:

```
chore: bootstrap project scaffolding (memory, security, sanity checks)
```

## Step 6: Report

Tell the user what was created and what was adapted. Be specific:

- List every file created
- Note what was skipped and why
- If anything was left generic (because the project type is unknown), list what should be updated once the stack is established
- Remind them that `/sanity-check` is available and adaptive
- Note that this scaffolding works alongside GSD — it won't interfere with GSD's planning structure

If the project type was "not sure yet", add:

> **When the project takes shape:** Once you know the language/framework, update the security scanner's dependency scanning, the secrets auditor's env var patterns, and the sanity check's build commands. The scaffolding will keep working in the meantime — it just won't check code-specific things until those are configured.
