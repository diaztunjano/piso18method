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
