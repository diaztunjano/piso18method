# Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent via the Task tool.

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

## Usage Notes

1. **Always paste the full task text** - Never reference the plan file
2. **Include relevant context** - What came before, what depends on this
3. **Be specific about expectations** - What "done" looks like
4. **Encourage questions upfront** - Better to clarify than to redo
