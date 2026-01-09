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
