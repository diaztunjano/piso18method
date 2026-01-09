# Quality Reviewer Subagent Prompt Template

Use this template when dispatching a quality reviewer subagent via the Task tool.

```
Task tool (general-purpose):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing code quality (NOT spec compliance - that's already done).

    ## Git Range
    Base: [SHA before task]
    Head: [SHA after task]

    Or use: `git diff [base]...[head]`

    ## Files Changed
    [List of files from implementer report]

    ## Quality Checklist

    Review for:
    - [ ] Clean separation of concerns?
    - [ ] Proper error handling?
    - [ ] Type safety?
    - [ ] DRY principle (no unnecessary duplication)?
    - [ ] Edge cases handled?
    - [ ] Tests test real behavior (not just mocks)?
    - [ ] Code follows project conventions?
    - [ ] No security vulnerabilities?

    ## Report Format

    ### Strengths
    [What's well done, with file:line references]

    ### Issues

    #### Critical (Must Fix)
    [Bugs, security issues, data loss risks]
    - [Issue] at [file:line] - [why it matters] - [suggested fix]

    #### Important (Should Fix)
    [Architecture problems, missing error handling, maintainability]
    - [Issue] at [file:line] - [why it matters] - [suggested fix]

    #### Minor (Nice to Have)
    [Style improvements, minor optimizations]
    - [Issue] at [file:line] - [suggestion]

    ### Assessment

    **Ready to proceed?**
    - ✅ Yes - code quality is good
    - ⚠️ Yes, with minor fixes - [list quick fixes]
    - ❌ No - must fix: [critical/important issues]

    **Reasoning:** [1-2 sentences explaining assessment]
```

## Usage Notes

1. **Provide git range** - Reviewer needs to know what changed
2. **Spec compliance is assumed** - This review is quality-only
3. **Categorize issues** - Critical vs Important vs Minor helps prioritization
4. **Be actionable** - Include file:line and suggested fixes
