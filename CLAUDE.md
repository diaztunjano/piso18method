# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**piso18method** is a standalone Claude Code plugin that packages a structured development methodology. It enforces a four-phase workflow: Discovery → Planning → Execution → Completion.

This is a **plugin implementation project** - the codebase consists of markdown files defining skills, commands, agents, and hooks for Claude Code.

## Project Status

The plugin is fully implemented and ready for use.

## Plugin Structure (Target)

```
piso18method/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── skills/
│   ├── using-piso18method/      # Meta skill (entry point)
│   ├── discovery/               # Phase 0: Brainstorming
│   ├── planning/                # Phase 1: Plan generation
│   ├── execution/               # Phase 2: Task execution with dispatcher pattern
│   ├── completion/              # Phase 3: Verification and merge/PR
│   ├── tdd/                     # Supporting: Test-Driven Development
│   ├── verification/            # Supporting: Evidence before claims
│   ├── code-review/             # Supporting: Review workflows
│   └── debugging/               # Supporting: Systematic debugging
├── commands/
│   ├── start.md                 # /piso18method:start
│   └── status.md                # /piso18method:status
├── agents/
│   └── code-reviewer.md         # Specialized reviewer agent
├── hooks/
│   ├── hooks.json               # Hook configuration
│   └── session-start.sh         # Inject methodology context
├── README.md
└── LICENSE
```

## Key Concepts

### Four Mandatory Phases

1. **Discovery (Phase 0)**: Turn vague ideas into validated designs through collaborative dialogue
2. **Planning (Phase 1)**: Create detailed implementation plans with bite-sized tasks
3. **Execution (Phase 2)**: Implement via Dispatcher Pattern with two-stage review (spec + quality)
4. **Completion (Phase 3)**: Verify tests, merge/PR, cleanup

### Dispatcher Pattern (Execution Phase)

The main agent (Dispatcher) never implements directly. It:
- Extracts all tasks from the plan
- Dispatches Implementer subagents with full task text in the prompt
- Runs Spec Reviewer after each task (does implementation match requirements?)
- Runs Quality Reviewer after spec passes (is the code well-written?)
- Coordinates fixes if reviews find issues

**Critical Rule**: Never make subagents read the plan file - provide full task text in the dispatch prompt.

### Two-Stage Review

```
Implementer → Spec Review → (fixes if needed) → Quality Review → (fixes if needed) → Done
```

## Implementation Notes

- Skills go in `skills/<skill-name>/SKILL.md` with YAML frontmatter
- Commands go in `commands/<command-name>.md`
- The `session-start.sh` hook injects the meta skill content at session start

