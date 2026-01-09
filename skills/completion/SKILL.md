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
