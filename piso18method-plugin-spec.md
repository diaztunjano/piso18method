# piso18method Plugin Specification

> **Versión:** 1.0.0
> **Fecha:** 2026-01-09
> **Estado:** Spec completa, lista para implementación

---

## 1. Resumen Ejecutivo

**piso18method** es un plugin standalone para Claude Code que empaqueta una metodología de desarrollo estructurada. Está basado en los skills de `superpowers` pero adaptado y mejorado para ser completamente independiente.

### Propuesta de Valor

| Problema | Solución |
|----------|----------|
| Desarrollo sin estructura | Flujo obligatorio: Discovery → Planning → Execution → Completion |
| Subagents sin contexto | Dispatcher pattern: contexto completo en cada prompt |
| Reviews inconsistentes | Two-stage review obligatorio: spec compliance + code quality |
| Dependencia de superpowers | Plugin standalone, cero dependencias externas |

### Flujo Principal

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────────────┐     ┌──────────────┐
│  Discovery  │ --> │   Planning   │ --> │       Execution         │ --> │  Completion  │
│  (Phase 0)  │     │  (Phase 1)   │     │       (Phase 2)         │     │  (Phase 3)   │
└─────────────┘     └──────────────┘     └─────────────────────────┘     └──────────────┘
                                                    │
                                         ┌──────────┴──────────┐
                                         │                     │
                                   ┌─────▼─────┐        ┌──────▼─────┐
                                   │   Spec    │   ->   │   Code     │
                                   │  Review   │        │   Review   │
                                   └───────────┘        └────────────┘
```

---

## 2. Estructura del Plugin

```
piso18method/
├── .claude-plugin/
│   └── plugin.json                    # Manifest del plugin
├── skills/
│   ├── using-piso18method/           # Meta skill (entry point)
│   │   └── SKILL.md
│   ├── discovery/                     # Phase 0: Brainstorming
│   │   └── SKILL.md
│   ├── planning/                      # Phase 1: Plan generation
│   │   └── SKILL.md
│   ├── execution/                     # Phase 2: Task execution
│   │   ├── SKILL.md
│   │   ├── implementer-prompt.md
│   │   ├── spec-reviewer-prompt.md
│   │   └── quality-reviewer-prompt.md
│   ├── completion/                    # Phase 3: Finish branch
│   │   └── SKILL.md
│   ├── tdd/                          # Supporting: Test-Driven Development
│   │   ├── SKILL.md
│   │   └── testing-anti-patterns.md
│   ├── verification/                  # Supporting: Evidence before claims
│   │   └── SKILL.md
│   ├── code-review/                   # Supporting: Review workflows
│   │   ├── SKILL.md
│   │   ├── requesting.md
│   │   ├── receiving.md
│   │   └── code-reviewer-prompt.md
│   └── debugging/                     # Supporting: Systematic debugging
│       └── SKILL.md
├── commands/
│   ├── start.md                       # /piso18method:start
│   └── status.md                      # /piso18method:status
├── agents/
│   └── code-reviewer.md               # Specialized reviewer agent
├── hooks/
│   ├── hooks.json                     # Hook configuration
│   └── session-start.sh               # Inject methodology context
├── README.md                          # Plugin documentation
└── LICENSE                            # MIT License
```

---

## 3. Manifest del Plugin

**Archivo:** `.claude-plugin/plugin.json`

```json
{
  "name": "piso18method",
  "description": "Structured development methodology: Discovery → Planning → Execution → Review → Completion. Enforces TDD, two-stage code review, and systematic task execution.",
  "version": "1.0.0",
  "author": {
    "name": "David Diaz",
    "email": "david@piso18.io"
  },
  "homepage": "https://github.com/piso18/piso18method",
  "repository": "https://github.com/piso18/piso18method",
  "license": "MIT",
  "keywords": [
    "methodology",
    "tdd",
    "code-review",
    "planning",
    "development-workflow",
    "subagent",
    "dispatcher-pattern"
  ]
}
```

---

## 4. Skills Specification

### 4.1 using-piso18method (Meta Skill)

**Archivo:** `skills/using-piso18method/SKILL.md`

```markdown
---
name: using-piso18method
description: Use when starting any conversation - establishes the development methodology and skill chain. MUST be invoked before any creative or implementation work.
---

# Using piso18method

## The Methodology

piso18method enforces a structured development workflow with four mandatory phases:

```
Phase 0: Discovery    → Understand requirements, explore approaches
Phase 1: Planning     → Create detailed implementation plan
Phase 2: Execution    → Implement with two-stage review
Phase 3: Completion   → Verify, merge/PR, cleanup
```

## The Rule

**You MUST follow the phase order.** No skipping phases. No shortcuts.

| If you're at... | You MUST complete... | Before moving to... |
|-----------------|---------------------|---------------------|
| Vague idea | Discovery | Planning |
| Clear requirements | Planning | Execution |
| Plan ready | Execution (with reviews) | Completion |
| All tasks done | Completion | Done |

## Skill Chain

| Phase | Skill | Trigger |
|-------|-------|---------|
| 0 | `piso18method:discovery` | User presents idea or feature request |
| 1 | `piso18method:planning` | Design validated, ready for plan |
| 2 | `piso18method:execution` | Plan created, ready to implement |
| 3 | `piso18method:completion` | All tasks complete, tests passing |

## Supporting Skills (Use During Any Phase)

| Skill | When to Use |
|-------|-------------|
| `piso18method:tdd` | Writing any production code |
| `piso18method:verification` | Before claiming anything is "done" |
| `piso18method:code-review` | After implementing tasks |
| `piso18method:debugging` | When encountering bugs or failures |

## Red Flags

These thoughts mean STOP—you're about to violate the methodology:

| Thought | Reality |
|---------|---------|
| "This is simple, skip to coding" | Simple things become complex. Use Discovery. |
| "I already know what to build" | Validate assumptions. Use Discovery. |
| "No need for a plan" | Plans catch issues early. Use Planning. |
| "Reviews slow me down" | Reviews catch bugs. Always review. |
| "It's working, ship it" | Verify first. Use Completion properly. |

## Quick Commands

- `/piso18method:start` - Begin new feature (starts at Discovery)
- `/piso18method:status` - Check current phase and next action

## Entry Point

When starting ANY creative or implementation work:

1. Announce: "Using piso18method for this task"
2. Determine current phase (usually Discovery for new work)
3. Invoke appropriate skill
4. Follow skill instructions exactly
```

---

### 4.2 discovery (Phase 0)

**Archivo:** `skills/discovery/SKILL.md`

```markdown
---
name: discovery
description: "Phase 0 of piso18method. Use when exploring ideas, understanding requirements, or starting new features. MUST be completed before Planning phase."
---

# Discovery Phase

## Overview

Turn vague ideas into validated designs through collaborative dialogue.

**Announce at start:** "I'm in the Discovery phase, exploring requirements before planning."

## The Process

### Step 1: Understand Context

Before asking questions:
- Check project state (files, docs, recent commits)
- Look for related implementations
- Note architectural patterns in use

### Step 2: Ask Questions (One at a Time)

**Rules:**
- ONE question per message
- Prefer multiple choice when possible
- Focus on: purpose, constraints, success criteria

**Good question:**
```
"Should alerts be sent:
A) Immediately when threshold crossed
B) Batched and sent daily
C) On-demand when user checks"
```

**Bad question:**
```
"What alerts do you want, when should they be sent,
and what format should they use?"
```

### Step 3: Explore Approaches

Once requirements are clear:
- Propose 2-3 different approaches
- List trade-offs for each
- Lead with your recommendation and reasoning

**Format:**
```
"I see two approaches:

1. **In-webhook processing** (Recommended)
   - Pros: Real-time, simpler architecture
   - Cons: Couples alert logic to ingestion

2. **Separate alert service**
   - Pros: Clean separation, scalable
   - Cons: Adds complexity, slight delay

I recommend #1 because [specific reasons for this codebase].
Thoughts?"
```

### Step 4: Present Design (Sections)

Present design in 200-300 word sections:
- Architecture overview
- Key components
- Data flow
- Error handling
- Testing approach

**After each section:** "Does this look right so far?"

### Step 5: Document and Handoff

When design is validated:

1. Write design document:
   ```
   docs/plans/YYYY-MM-DD-<topic>-design.md
   ```

2. Commit the design document

3. Announce handoff:
   ```
   "Discovery complete. Design documented at [path].
   Ready to move to Planning phase with piso18method:planning?"
   ```

## Key Principles

- **One question at a time** - Don't overwhelm
- **Multiple choice preferred** - Easier to answer
- **YAGNI ruthlessly** - Remove unnecessary features
- **Explore alternatives** - Always propose 2-3 approaches
- **Validate incrementally** - Section by section
- **Document before moving on** - Design doc is required output
```

---

### 4.3 planning (Phase 1)

**Archivo:** `skills/planning/SKILL.md`

```markdown
---
name: planning
description: "Phase 1 of piso18method. Use when design is validated and you need to create an implementation plan. MUST be completed before Execution phase."
---

# Planning Phase

## Overview

Create a detailed implementation plan with bite-sized tasks that an implementer with zero codebase context could follow.

**Announce at start:** "I'm in the Planning phase, creating the implementation plan."

**Prerequisites:** Discovery phase complete, design document exists.

## Plan Document Structure

**Save to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** Use piso18method:execution to implement this plan.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Design Doc:** [Link to design document from Discovery]

---

## Tasks

### Task 1: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

\`\`\`python
def test_specific_behavior():
    result = function(input)
    assert result == expected
\`\`\`

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

\`\`\`python
def function(input):
    return expected
\`\`\`

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

\`\`\`bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
\`\`\`

---

### Task 2: [Next Component]
...
```

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**

| Action | Separate Step? |
|--------|----------------|
| Write the failing test | YES |
| Run test to verify it fails | YES |
| Write minimal implementation | YES |
| Run test to verify it passes | YES |
| Commit | YES |

## Plan Quality Checklist

Before finalizing:
- [ ] Exact file paths (no "somewhere in src/")
- [ ] Complete code snippets (no "add validation logic")
- [ ] Exact commands with expected output
- [ ] Tasks are independent where possible
- [ ] ≤20 tasks per plan (split large features)
- [ ] TDD steps included for each feature

## Handoff

When plan is complete:

```
"Plan complete and saved to `docs/plans/YYYY-MM-DD-<feature>.md`.

Ready to move to Execution phase with piso18method:execution?

**Execution options:**
1. Same session - I'll dispatch subagents per task with reviews
2. Separate session - Open new session in worktree, batch execution"
```
```

---

### 4.4 execution (Phase 2)

**Archivo:** `skills/execution/SKILL.md`

```markdown
---
name: execution
description: "Phase 2 of piso18method. Use when you have a plan ready to execute. Implements Dispatcher Pattern with two-stage review."
---

# Execution Phase

## Overview

Execute the plan using the Dispatcher Pattern: fresh subagent per task, with two-stage review after each (spec compliance, then code quality).

**Announce at start:** "I'm in the Execution phase, implementing tasks with two-stage review."

**Prerequisites:** Planning phase complete, plan document exists.

## The Dispatcher Pattern

You (the Dispatcher) coordinate subagents. You NEVER implement directly.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DISPATCHER (You)                              │
├─────────────────────────────────────────────────────────────────────┤
│  1. Read plan ONCE, extract ALL tasks                               │
│  2. Create TodoWrite with all tasks                                 │
│  3. For each task:                                                  │
│     a. Dispatch Implementer subagent (full task text in prompt)     │
│     b. Answer any questions                                         │
│     c. Receive implementation report                                │
│     d. Dispatch Spec Reviewer subagent                              │
│     e. If issues → Implementer fixes → Re-review                    │
│     f. Dispatch Quality Reviewer subagent                           │
│     g. If issues → Implementer fixes → Re-review                    │
│     h. Mark task complete                                           │
│  4. After all tasks: Move to Completion phase                       │
└─────────────────────────────────────────────────────────────────────┘
```

## Critical Rule

**NEVER make a subagent read the plan file.**

The Dispatcher provides the FULL task text in the prompt. This:
- Prevents context pollution
- Makes subagent faster
- Ensures subagent has exactly what it needs

## Subagent Templates

### Implementer Subagent

Use template at `./implementer-prompt.md`:

```
Task tool (general-purpose):
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N: [task name]

    ## Task Description
    [FULL TEXT of task from plan - PASTE HERE]

    ## Context
    [Scene-setting: where this fits, dependencies, architecture]

    ## Before You Begin
    If you have questions about requirements, approach, or dependencies:
    **Ask them now.** Don't guess.

    ## Your Job
    1. Implement exactly what the task specifies
    2. Follow TDD (use piso18method:tdd skill)
    3. Verify implementation works
    4. Commit your work
    5. Self-review before reporting

    ## Self-Review Checklist
    - Completeness: Did I implement everything?
    - Quality: Is this my best work?
    - Discipline: Did I avoid overbuilding (YAGNI)?
    - Testing: Do tests verify real behavior?

    ## Report Format
    When done:
    - What you implemented
    - Test results
    - Files changed
    - Self-review findings
    - Any concerns
```

### Spec Reviewer Subagent

Use template at `./spec-reviewer-prompt.md`:

```
Task tool (general-purpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether implementation matches specification.

    ## What Was Requested
    [FULL TEXT of task requirements]

    ## What Implementer Claims
    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    **DO NOT:**
    - Take their word for what they implemented
    - Trust claims about completeness

    **DO:**
    - Read the actual code
    - Compare implementation vs requirements line by line
    - Look for missing pieces
    - Look for extra unrequested features

    ## Report
    - ✅ Spec compliant (after code inspection)
    - ❌ Issues: [list with file:line references]
```

### Quality Reviewer Subagent

Use template at `./quality-reviewer-prompt.md`:

```
Task tool (general-purpose):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing code quality (NOT spec compliance - that's done).

    ## Git Range
    Base: [SHA before task]
    Head: [SHA after task]

    ## Checklist
    - Clean separation of concerns?
    - Proper error handling?
    - Type safety?
    - DRY principle?
    - Edge cases handled?
    - Tests test real behavior (not mocks)?

    ## Report Format

    ### Strengths
    [What's well done, with file:line references]

    ### Issues

    #### Critical (Must Fix)
    [Bugs, security issues]

    #### Important (Should Fix)
    [Architecture problems, missing error handling]

    #### Minor (Nice to Have)
    [Style, optimization]

    ### Assessment
    Ready to proceed? [Yes/No/With fixes]
```

## Two-Stage Review Flow

```
Implementer completes task
         │
         ▼
┌─────────────────┐
│  Spec Review    │ ──❌ Issues ──> Implementer fixes ──┐
└────────┬────────┘                                     │
         │ ✅                                           │
         │ <────────────────────────────────────────────┘
         ▼
┌─────────────────┐
│ Quality Review  │ ──❌ Issues ──> Implementer fixes ──┐
└────────┬────────┘                                     │
         │ ✅                                           │
         │ <────────────────────────────────────────────┘
         ▼
    Task Complete
```

## Red Flags (Never Do)

| Anti-pattern | Why it's bad |
|--------------|--------------|
| Skip spec review | Over/under-building slips through |
| Skip quality review | Technical debt accumulates |
| Start quality before spec passes | Wrong order, wastes time |
| Dispatch parallel implementers | Merge conflicts |
| Make subagent read plan file | Context pollution |
| Trust report without code inspection | Implementers can be optimistic |
| Implement directly (not via subagent) | Context pollution |

## Handoff to Completion

When all tasks are complete and reviewed:

```
"Execution complete. All tasks implemented with two-stage review.

Summary:
- Tasks completed: N/N
- All spec reviews: ✅
- All quality reviews: ✅

Ready to move to Completion phase with piso18method:completion?"
```
```

---

### 4.5 completion (Phase 3)

**Archivo:** `skills/completion/SKILL.md`

```markdown
---
name: completion
description: "Phase 3 of piso18method. Use when all tasks are implemented and reviewed. Handles verification, merge/PR, and cleanup."
---

# Completion Phase

## Overview

Verify tests, present completion options, execute chosen workflow, cleanup.

**Announce at start:** "I'm in the Completion phase, verifying and finalizing the work."

**Prerequisites:** Execution phase complete, all tasks reviewed.

## The Process

### Step 1: Verify Tests

**Before anything else:**

```bash
# Run project's full test suite
npm test / pytest / cargo test / go test ./...
```

**If tests fail:**
```
Tests failing (N failures). Must fix before completing:

[Show failures]

Cannot proceed until tests pass.
```

STOP. Do not proceed to Step 2.

**If tests pass:** Continue.

### Step 2: Determine Base Branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master
```

Or ask: "This branch split from main - is that correct?"

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete and verified. What would you like to do?

1. Merge back to [base-branch] locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
git checkout [base-branch]
git pull
git merge [feature-branch]
[run tests again]
git branch -d [feature-branch]
```

#### Option 2: Create PR

```bash
git push -u origin [feature-branch]
gh pr create --title "[title]" --body "$(cat <<'EOF'
## Summary
- [bullet points]

## Test Plan
- [ ] [verification steps]

---
Created with piso18method
EOF
)"
```

#### Option 3: Keep As-Is

Report: "Keeping branch [name]. Ready for manual handling."

#### Option 4: Discard

**Require confirmation:**
```
This will permanently delete:
- Branch [name]
- All commits since [base]

Type 'discard' to confirm.
```

### Step 5: Final Report

```
## piso18method Completion Report

**Feature:** [name]
**Phases completed:** Discovery → Planning → Execution → Completion

**Deliverables:**
- Design doc: docs/plans/YYYY-MM-DD-design.md
- Plan doc: docs/plans/YYYY-MM-DD-plan.md
- [PR link or merge commit]

**Stats:**
- Tasks: N
- Reviews: N spec + N quality
- Tests: N passing

Done!
```
```

---

### 4.6 tdd (Supporting Skill)

**Archivo:** `skills/tdd/SKILL.md`

**Contenido:** Copiar de `superpowers/skills/test-driven-development/SKILL.md` con estos cambios:
- Eliminar todas las referencias a "superpowers"
- Cambiar cualquier mención de skill externo a `piso18method:*`

**Archivo adicional:** `skills/tdd/testing-anti-patterns.md`
- Copiar de `superpowers/skills/test-driven-development/testing-anti-patterns.md`

---

### 4.7 verification (Supporting Skill)

**Archivo:** `skills/verification/SKILL.md`

**Contenido:** Copiar de `superpowers/skills/verification-before-completion/SKILL.md` con estos cambios:
- Eliminar todas las referencias a "superpowers"
- Adaptar ejemplos al contexto de piso18method

---

### 4.8 code-review (Supporting Skill)

**Archivo:** `skills/code-review/SKILL.md`

```markdown
---
name: code-review
description: "Supporting skill for code review workflows. Covers both requesting and receiving reviews."
---

# Code Review

This skill covers both sides of code review:
- `@requesting.md` - How to request reviews
- `@receiving.md` - How to handle review feedback
- `@code-reviewer-prompt.md` - Template for reviewer subagent

## When to Use

**Request review:**
- After each task in Execution phase
- After completing major feature
- Before merge to main

**Receive review:**
- When feedback arrives
- Before implementing suggestions
- When feedback seems unclear

## Quick Reference

### Requesting Review

1. Get git SHAs:
   ```bash
   BASE_SHA=$(git rev-parse HEAD~1)
   HEAD_SHA=$(git rev-parse HEAD)
   ```

2. Dispatch code-reviewer with `@code-reviewer-prompt.md`

3. Act on feedback:
   - Critical → Fix immediately
   - Important → Fix before proceeding
   - Minor → Note for later

### Receiving Review

1. READ complete feedback without reacting
2. UNDERSTAND - restate in own words
3. VERIFY against codebase
4. EVALUATE - technically sound?
5. RESPOND - technical acknowledgment or reasoned pushback
6. IMPLEMENT - one at a time, test each

**Forbidden responses:**
- "You're absolutely right!"
- "Great point!"
- "Let me implement that now" (before verification)
```

**Archivos adicionales:**
- `skills/code-review/requesting.md` - Copiar de superpowers
- `skills/code-review/receiving.md` - Copiar de superpowers
- `skills/code-review/code-reviewer-prompt.md` - Copiar de superpowers

---

### 4.9 debugging (Supporting Skill)

**Archivo:** `skills/debugging/SKILL.md`

**Contenido:** Versión simplificada del debugging skill de superpowers:

```markdown
---
name: debugging
description: "Use when encountering bugs, test failures, or unexpected behavior. Requires systematic investigation before proposing fixes."
---

# Systematic Debugging

## Overview

Debug systematically, not reactively. Understand before fixing.

## The Process

### Step 1: Reproduce

Before anything else, reproduce the issue:
```
1. Note exact steps to trigger
2. Note expected vs actual behavior
3. Confirm it's reproducible
```

**Can't reproduce?** Gather more information. Don't guess.

### Step 2: Isolate

Narrow down the cause:
```
1. Find the smallest input that triggers the bug
2. Identify which component is failing
3. Check recent changes (git log, git diff)
```

### Step 3: Understand

Before proposing a fix:
```
1. Read the relevant code carefully
2. Trace the data flow
3. Understand WHY it's failing, not just WHERE
```

### Step 4: Fix with TDD

```
1. Write a test that reproduces the bug (should FAIL)
2. Verify the test fails for the right reason
3. Fix the bug
4. Verify the test passes
5. Verify no regressions
```

### Step 5: Verify

**MANDATORY:** Run full test suite before claiming "fixed"

## Red Flags

| Thought | Reality |
|---------|---------|
| "I know what's wrong" | Verify first |
| "Quick fix" | Understand root cause |
| "It works now" | Run tests |
| "Edge case, won't happen again" | Add test anyway |

## Remember

- Reproduce first, always
- Understand before fixing
- Test proves the fix
- No "it should work now"
```

---

## 5. Commands Specification

### 5.1 /piso18method:start

**Archivo:** `commands/start.md`

```markdown
---
description: Start a new feature using piso18method. Begins at Discovery phase.
argument-hint: [feature-description]
---

# Starting New Feature with piso18method

You requested to start: $ARGUMENTS

I'm initiating the piso18method workflow.

## Current Phase: Discovery

Beginning Discovery phase to understand requirements and explore approaches.

**Next steps:**
1. I'll explore the codebase for relevant context
2. Ask clarifying questions (one at a time)
3. Propose 2-3 approaches
4. Validate the design with you

Let me start by understanding what we're building...
```

### 5.2 /piso18method:status

**Archivo:** `commands/status.md`

```markdown
---
description: Check current piso18method phase and next action
---

# piso18method Status

Checking current phase...

## Phase Detection

To determine current phase, I'll check:
1. Design doc exists? → At least past Discovery
2. Plan doc exists? → At least past Planning
3. Tasks in progress? → In Execution
4. All tasks complete? → Ready for Completion

## Status Report

Based on the current state:

**Current Phase:** [Detected phase]
**Progress:** [Details]
**Next Action:** [What to do next]

## Commands

- Continue current phase: [specific skill to invoke]
- Skip to phase: `/piso18method:skip-to [phase]` (not recommended)
```

---

## 6. Agent Specification

### 6.1 code-reviewer

**Archivo:** `agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: |
  Senior code reviewer agent. Use after task implementation for quality review.
  Dispatch via piso18method:code-review skill.
model: inherit
---

You are a Senior Code Reviewer. Your role is to review code for production readiness.

## Review Process

1. **Plan Alignment**
   - Compare implementation against plan/requirements
   - Identify deviations (justified or problematic)
   - Verify all planned functionality implemented

2. **Code Quality**
   - Adherence to patterns and conventions
   - Error handling and type safety
   - Maintainability and organization
   - Test coverage and quality

3. **Architecture**
   - SOLID principles
   - Separation of concerns
   - Integration with existing systems
   - Scalability considerations

4. **Issue Categorization**
   - **Critical:** Must fix (bugs, security, data loss)
   - **Important:** Should fix (architecture, missing features)
   - **Minor:** Nice to have (style, optimization)

## Output Format

### Strengths
[What's done well - be specific with file:line]

### Issues

#### Critical
[List with file:line, what's wrong, why it matters, how to fix]

#### Important
[Same format]

#### Minor
[Same format]

### Assessment
**Ready to proceed?** [Yes / No / With fixes]
**Reasoning:** [1-2 sentences]
```

---

## 7. Hooks Specification

### 7.1 hooks.json

**Archivo:** `hooks/hooks.json`

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh\""
          }
        ]
      }
    ]
  }
}
```

### 7.2 session-start.sh

**Archivo:** `hooks/session-start.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-piso18method content
using_skill_content=$(cat "${PLUGIN_ROOT}/skills/using-piso18method/SKILL.md" 2>&1 || echo "Error reading skill")

# Escape for JSON
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\' ;;
            '"') output+='\"' ;;
            $'\n') output+='\n' ;;
            $'\r') output+='\r' ;;
            $'\t') output+='\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}

escaped_content=$(escape_for_json "$using_skill_content")

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<METHODOLOGY>\nYou have piso18method installed.\n\n**The methodology skill is loaded below. For other skills, use the Skill tool:**\n\n${escaped_content}\n</METHODOLOGY>"
  }
}
EOF

exit 0
```

---

## 8. Installation & Usage

### Installation

```bash
# From GitHub (once published)
/plugin install piso18method

# From local directory (for development)
/plugin install ./path/to/piso18method
```

### Basic Usage

```bash
# Start new feature
/piso18method:start add user authentication

# Check status
/piso18method:status

# Skills are auto-invoked based on context
# Or manually invoke:
# - piso18method:discovery
# - piso18method:planning
# - piso18method:execution
# - piso18method:completion
```

---

## 9. Migration from superpowers

| superpowers skill | piso18method equivalent |
|-------------------|------------------------|
| `superpowers:brainstorming` | `piso18method:discovery` |
| `superpowers:writing-plans` | `piso18method:planning` |
| `superpowers:subagent-driven-development` | `piso18method:execution` |
| `superpowers:executing-plans` | `piso18method:execution` |
| `superpowers:finishing-a-development-branch` | `piso18method:completion` |
| `superpowers:test-driven-development` | `piso18method:tdd` |
| `superpowers:verification-before-completion` | `piso18method:verification` |
| `superpowers:requesting-code-review` | `piso18method:code-review` |
| `superpowers:receiving-code-review` | `piso18method:code-review` |
| `superpowers:systematic-debugging` | `piso18method:debugging` |
| `superpowers:using-superpowers` | `piso18method:using-piso18method` |

**Not included:**
- `superpowers:using-git-worktrees` - Too specific, add if needed
- `superpowers:dispatching-parallel-agents` - Adds complexity
- `superpowers:writing-skills` - Not relevant to development workflow

---

## 10. Checklist de Implementación

- [ ] Crear repo `piso18method`
- [ ] Crear estructura de directorios
- [ ] Crear `.claude-plugin/plugin.json`
- [ ] Crear `skills/using-piso18method/SKILL.md`
- [ ] Crear `skills/discovery/SKILL.md`
- [ ] Crear `skills/planning/SKILL.md`
- [ ] Crear `skills/execution/SKILL.md` + prompts
- [ ] Crear `skills/completion/SKILL.md`
- [ ] Crear `skills/tdd/SKILL.md` + anti-patterns
- [ ] Crear `skills/verification/SKILL.md`
- [ ] Crear `skills/code-review/SKILL.md` + sub-files
- [ ] Crear `skills/debugging/SKILL.md`
- [ ] Crear `commands/start.md`
- [ ] Crear `commands/status.md`
- [ ] Crear `agents/code-reviewer.md`
- [ ] Crear `hooks/hooks.json`
- [ ] Crear `hooks/session-start.sh`
- [ ] Crear `README.md`
- [ ] Crear `LICENSE`
- [ ] Probar instalación local
- [ ] Probar flujo completo
- [ ] Publicar a GitHub
