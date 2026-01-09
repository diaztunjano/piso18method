# Spec Reviewer Subagent Prompt Template

Use this template when dispatching a spec reviewer subagent via the Task tool.

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

    ## Review Checklist

    For each requirement in the task:
    - [ ] Is it implemented?
    - [ ] Is it implemented correctly?
    - [ ] Is there anything extra that wasn't requested?

    ## Report

    Format your response as:

    ### Spec Compliance Assessment

    **Status:** ✅ Compliant | ❌ Non-compliant

    ### Requirement-by-Requirement Check
    | Requirement | Status | Notes |
    |-------------|--------|-------|
    | [req 1] | ✅/❌ | [details] |
    | ... | ... | ... |

    ### Issues Found (if any)
    - [Issue with file:line reference]

    ### Extra/Unrequested Features (if any)
    - [Feature that wasn't in spec]

    ### Verdict
    - ✅ Spec compliant - proceed to quality review
    - ❌ Issues found - implementer must fix: [list]
```

## Usage Notes

1. **Include full task requirements** - The reviewer needs the original spec
2. **Include implementer's claims** - What they say they did
3. **Emphasize code inspection** - Reports can be optimistic
4. **Binary outcome** - Either compliant or not, no "mostly compliant"
