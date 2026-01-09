---
name: debugging
description: "Use when encountering bugs, test failures, or unexpected behavior. Requires systematic investigation before proposing fixes."
---

# Systematic Debugging

## Overview

Debug systematically, not reactively. Understand before fixing.

**Announce at start:** "I'm using systematic debugging to investigate this issue."

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

## The Scientific Method

```
1. OBSERVE: What exactly is happening?
2. HYPOTHESIZE: What might cause this?
3. PREDICT: If hypothesis is true, what should I see?
4. TEST: Check prediction against reality
5. CONCLUDE: Was hypothesis correct?
6. REPEAT: If wrong, new hypothesis
```

## Common Debugging Techniques

### Binary Search
```
If bug in large codebase:
1. Find midpoint in execution
2. Check if state is correct there
3. If correct: bug is after midpoint
4. If incorrect: bug is before midpoint
5. Repeat until isolated
```

### Git Bisect
```bash
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
# Git will checkout commits, you mark good/bad
git bisect reset  # when done
```

### Print Debugging
```
Add logging at key points:
1. Function entry/exit
2. Before/after state changes
3. Decision points (if/else branches)
4. Loop iterations
```

### Rubber Duck Debugging
```
Explain the problem out loud:
1. What should happen?
2. What actually happens?
3. What have I tried?
4. What assumptions am I making?
```

## Investigation Checklist

Before proposing ANY fix:

- [ ] Can reproduce the bug
- [ ] Identified the failing component
- [ ] Read the relevant code
- [ ] Understand the root cause (not just symptom)
- [ ] Have a hypothesis for why it fails
- [ ] Know what the fix should change

## When Stuck

| Problem | Solution |
|---------|----------|
| Can't reproduce | Get exact steps, check environment differences |
| Too many variables | Isolate one at a time |
| No obvious cause | Add logging, trace data flow |
| Fix doesn't work | Verify hypothesis was correct |
| Fix causes new bugs | Understand side effects |

## Anti-Patterns

**Don't:**
- Guess and check randomly
- Change multiple things at once
- Skip reproduction step
- Assume you know the cause
- Claim "fixed" without tests
- Delete code you don't understand

**Do:**
- Be systematic
- Change one thing at a time
- Verify each hypothesis
- Document findings
- Add regression test

## Remember

- Reproduce first, always
- Understand before fixing
- Test proves the fix
- No "it should work now"
- Regression test is mandatory
