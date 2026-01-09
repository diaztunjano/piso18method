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
