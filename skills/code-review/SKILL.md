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
