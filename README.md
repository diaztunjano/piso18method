# piso18method

A Claude Code plugin that enforces a structured development methodology.

## Overview

piso18method packages a complete development workflow with four mandatory phases:

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────────────┐     ┌──────────────┐
│  Discovery  │ --> │   Planning   │ --> │       Execution         │ --> │  Completion  │
│  (Phase 0)  │     │  (Phase 1)   │     │       (Phase 2)         │     │  (Phase 3)   │
└─────────────┘     └──────────────┘     └─────────────────────────┘     └──────────────┘
                                                    │
                                         ┌──────────┴──────────┐
                                         │                     │
                                   ┌─────▼─────┐        ┌──────▼─────┐
                                   │   Spec    │   ->   │   Code     │
                                   │  Review   │        │   Review   │
                                   └───────────┘        └────────────┘
```

## Installation

```bash
# Install from GitHub (once published)
/plugin install piso18method

# Install from local directory (for development)
/plugin install ./path/to/piso18method
```

## Quick Start

```bash
# Start a new feature
/piso18method:start add user authentication

# Check current status
/piso18method:status
```

## The Four Phases

### Phase 0: Discovery
Turn vague ideas into validated designs through collaborative dialogue.
- Ask questions one at a time
- Propose 2-3 approaches with trade-offs
- Document validated design

### Phase 1: Planning
Create detailed implementation plans with bite-sized tasks.
- Exact file paths
- Complete code snippets
- TDD steps included

### Phase 2: Execution
Implement using the Dispatcher Pattern with two-stage review.
- Fresh subagent per task
- Spec review (does it match requirements?)
- Quality review (is the code well-written?)

### Phase 3: Completion
Verify, merge/PR, and cleanup.
- Run full test suite
- Present merge options
- Generate completion report

## Skills

### Core Phase Skills
| Skill | Description |
|-------|-------------|
| `piso18method:discovery` | Phase 0 - Explore requirements |
| `piso18method:planning` | Phase 1 - Create implementation plan |
| `piso18method:execution` | Phase 2 - Implement with reviews |
| `piso18method:completion` | Phase 3 - Verify and finish |

### Supporting Skills
| Skill | Description |
|-------|-------------|
| `piso18method:tdd` | Test-Driven Development |
| `piso18method:verification` | Evidence before claims |
| `piso18method:code-review` | Request and receive reviews |
| `piso18method:debugging` | Systematic bug investigation |

## Key Principles

1. **No skipping phases** - Follow the sequence
2. **TDD always** - Test first, then implement
3. **Two-stage review** - Spec compliance, then code quality
4. **Dispatcher Pattern** - Never pollute context, delegate to subagents
5. **Evidence before claims** - Run verification, then claim success

## Migration from superpowers

| superpowers skill | piso18method equivalent |
|-------------------|------------------------|
| `superpowers:brainstorming` | `piso18method:discovery` |
| `superpowers:writing-plans` | `piso18method:planning` |
| `superpowers:subagent-driven-development` | `piso18method:execution` |
| `superpowers:finishing-a-development-branch` | `piso18method:completion` |
| `superpowers:test-driven-development` | `piso18method:tdd` |
| `superpowers:verification-before-completion` | `piso18method:verification` |

## License

MIT License - see [LICENSE](LICENSE)

## Author

David Diaz - david@piso18.io
# piso18method
