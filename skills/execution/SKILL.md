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

Use template at `@implementer-prompt.md`:

```
Task tool (general-purpose):
  description: "Implement Task N: [task name]"
  prompt: [see implementer-prompt.md]
```

### Spec Reviewer Subagent

Use template at `@spec-reviewer-prompt.md`:

```
Task tool (general-purpose):
  description: "Review spec compliance for Task N"
  prompt: [see spec-reviewer-prompt.md]
```

### Quality Reviewer Subagent

Use template at `@quality-reviewer-prompt.md`:

```
Task tool (general-purpose):
  description: "Review code quality for Task N"
  prompt: [see quality-reviewer-prompt.md]
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
