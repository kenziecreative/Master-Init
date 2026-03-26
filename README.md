# knzinit — Project Scaffolding Plugin

A Claude Code plugin that bootstraps any new project with a 5-layer memory system, security agents, guardrail hooks, and a sanity check skill. Works for code projects, non-code projects, or projects that haven't decided yet.

## Plugin Structure

This follows the current Claude Code plugin conventions — skills (not commands), `SKILL.md` files in named directories, and a `.claude-plugin/plugin.json` manifest.

```
init-agent/
├── .claude-plugin/
│   └── plugin.json                       # Plugin manifest
├── skills/
│   └── knzinit/
│       └── SKILL.md                      # Main orchestrator skill
├── scaffold/                             # ALL installable payload lives here
│   ├── agents/
│   │   ├── security-scanner.md           # SAST-lite + dependency audit
│   │   └── secrets-env-auditor.md        # Secret detection + env hygiene
│   ├── hooks/
│   │   ├── pre-compact-check.sh          # Warns on undocumented changes before compaction
│   │   ├── milestone-check.sh            # Blocks stop if milestone work undocumented
│   │   └── pre-commit-secrets.sh         # Catches secrets before commit
│   ├── skills/
│   │   └── sanity-check/
│   │       └── SKILL.md                  # Adaptive project health check
│   ├── templates/
│   │   ├── CLAUDE.md.tmpl                # Layer 1 template
│   │   ├── STATE.md.tmpl                 # Layer 2 template
│   │   ├── LEARNINGS.md.tmpl             # Layer 4 template
│   │   └── gitignore.tmpl                # Baseline .gitignore
│   └── settings.json                     # Hook registration template
└── README.md
```

## What It Does

knzinit sets up the infrastructure that keeps a project healthy across sessions. It's supplemental — it works alongside orchestrators like GSD, not as a replacement. Its job is to catch what falls through the cracks: security issues, exposed secrets, documentation drift, and lost context between sessions.

## Where It Fits

knzinit is step 4 in the project lifecycle pipeline:

```
/knz-research → /knz-generateprd → Design OS → /knzinit → /gsd:new-project → build
```

By the time knzinit runs, the product is defined and designed. knzinit scaffolds the build environment so GSD can focus on execution.

## Skills

### `/knzinit` — Project Bootstrap

The main skill. Walks the user through orientation questions, explores what already exists in the project, then creates the full scaffolding adapted to the project type. Invoked manually when starting a new project.

### `/sanity-check` — Project Health Check

An adaptive health check that only checks what exists — safe to run on brand new projects.

- **Code Health**: Runs build/type-check, test suite, linter, and scans for debug artifacts (console.log/print, TODO/FIXME/HACK, hardcoded localhost, hardcoded user paths). Skipped if no code exists yet.
- **Documentation Currency**: Verifies STATE.md, CLAUDE.md, and LEARNINGS.md are current. Updates stale files.
- **Context Handoff**: Validates that a fresh session could pick up where this one left off.

Output is a pass/skip/fail summary table. If anything fails, it fixes the issues before proceeding.

**When to run**: Before clearing context, before starting a new milestone, after significant refactoring, or when something feels off.

## What It Scaffolds Into Target Projects

When `/knzinit` runs in a target project, it creates:

### 5-Layer Memory System

| Layer | File | Purpose | Loaded |
|-------|------|---------|--------|
| 1 | `CLAUDE.md` | Project identity, session startup instructions, pointers to other layers | Always (system prompt) |
| 2 | `.planning/STATE.md` | Current position, recent decisions, open items, session continuity | At session start |
| 3 | Auto Memory (`MEMORY.md`) | User preferences, project context, feedback, external references | On relevance |
| 4 | `.planning/LEARNINGS.md` | Insights and discoveries that should change how we work | On relevance |
| 5 | Hooks/Guardrails | Automated checks that fire on specific events | On trigger |

**Why 5 layers?** Each layer has a different loading cost and update frequency. CLAUDE.md is always in context so it stays lean. STATE.md is read once per session. Learnings and memory are consulted when relevant. Hooks run automatically without consuming context.

### Security Agents

#### Security Scanner → `.claude/agents/security-scanner.md`
- **Model**: Sonnet
- **What it does**: SAST-lite code review for injection flaws, OWASP Top 10, and cryptographic weaknesses. Runs the project's package manager audit command for dependency scanning. Validates security headers, cookie settings, TLS, and auth configuration.
- **Output**: `.planning/security/security-scan-<date>.md`
- **Pass/Fail**: Fails on any Critical finding or any High with a known public exploit.
- **Adapts to**: The project's actual language and framework. Generic until the stack is established.

#### Secrets & Environment Auditor → `.claude/agents/secrets-env-auditor.md`
- **Model**: Haiku
- **What it does**: Detects API keys, tokens, credentials, and high-entropy strings. Validates `.env.example` completeness. Checks that `.env` files are gitignored. Scans git history (last 50 commits) for previously committed secrets.
- **Output**: `.planning/security/secrets-audit-<date>.md`
- **Critical rule**: Never prints full secret values — always masks them.
- **Adapts to**: Language-specific env var patterns (process.env, os.environ, os.Getenv, etc.).

### Hooks

#### Pre-Compact Check → `.claude/hooks/pre-compact-check.sh`
- **Event**: PreCompact (fires before context compression)
- **What it does**: Checks if substantive files were modified without updating STATE.md. If so, warns that documentation should be updated before context is lost.
- **Why**: Context compression discards details. If STATE.md isn't current before compression, the session's progress is effectively lost.

#### Milestone Check → `.claude/hooks/milestone-check.sh`
- **Event**: Stop (fires when Claude stops responding)
- **What it does**: Looks at commits from the last 30 minutes. If they match milestone-like patterns (complete, finish, implement, ship, release, phase, v1, etc.), checks whether STATE.md was updated. Blocks with exit code 2 if not.
- **Why**: Milestone completions are the highest-value moments to document. Missing them means the next session starts without knowing what was accomplished.

#### Pre-Commit Secrets → `.claude/hooks/pre-commit-secrets.sh`
- **Event**: PreToolUse (triggers when a Bash command contains `git commit`)
- **What it does**: Scans staged files for common secret patterns — Stripe keys (sk_live_, sk_test_), AWS access keys (AKIA), GitHub tokens (ghp_), GitLab tokens (glpat-), Slack tokens (xox), private key blocks, and JWT patterns. Skips binary files.
- **Why**: `.gitignore` is the first line of defense (prevents staging). This hook is the second line (catches what gitignore misses before it's committed).

## Adaptive Behavior

knzinit adapts to three project types:

| Project Type | Security Agents | Hooks | Sanity Check | Session Discipline |
|-------------|----------------|-------|-------------|-------------------|
| **Code + Git** | All agents + all hooks | Pre-compact, milestone, pre-commit secrets | Full (code + docs + handoff) | Via hooks |
| **Code, no Git** | Agents only (no hooks) | None | Docs + handoff only | Via CLAUDE.md section |
| **Non-code** | Skipped | Pre-compact + milestone (if git) | Docs + handoff only | Via CLAUDE.md section |

When the project type is "not sure yet", knzinit builds the flexible variant that includes everything except code-specific scanning. Components self-activate as the stack is established.

## Extending

Each component is independent. To iterate:

- **Change what gets scaffolded**: Edit `skills/knzinit/SKILL.md` (the orchestrator logic)
- **Change template content**: Edit files in `scaffold/templates/`
- **Change security scanning**: Edit files in `scaffold/agents/`
- **Change automated guardrails**: Edit files in `scaffold/hooks/` and `scaffold/settings.json`
- **Change health checks**: Edit `scaffold/skills/sanity-check/SKILL.md`

The orchestrator references components via `${CLAUDE_PLUGIN_ROOT}` paths, so the plugin works regardless of where it's installed.
