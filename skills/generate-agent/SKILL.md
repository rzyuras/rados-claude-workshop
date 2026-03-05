# /generate-agent — Create a custom agent from a role description

Generate an agent .md file with appropriate tools, skills, and process steps.

## Usage

```
/generate-agent [name] "[role description]"
```

Example: `/generate-agent api-dev "writes API endpoints following our Express patterns"`

## Steps

### 1. Parse Input

Extract the agent name and role description from the user's input.

### 2. Scan Existing Config

Read existing agents and skills to understand the project's setup:

```bash
ls agents/*.md 2>/dev/null
ls skills/*/SKILL.md 2>/dev/null
```

Understand what's already available to avoid duplication.

### 3. Determine Tools

Based on the role description, assign appropriate tools:

| Role Type | Tools |
|-----------|-------|
| Read-only (analyst, reviewer) | Read, Glob, Grep, Bash |
| Writer (developer, implementer) | Read, Glob, Grep, Edit, Write, Bash |
| Task manager (planner, lead) | + TaskCreate, TaskUpdate, TaskList, TaskGet |
| Interactive (needs user input) | + AskUserQuestion |

**Principle of least privilege** — only give tools the agent actually needs.

### 4. Match Skills

Check which existing skills are relevant to the agent's role:

- Code-writing agents → `conventions`
- Shipping agents → `ship`
- Review agents → `conventions`

### 5. Choose Model

- Agents that need deep reasoning or analysis → `sonnet` or `opus`
- Agents that do simple, repetitive tasks → `haiku`
- Default: inherit from parent (don't specify model)

### 6. Generate Agent File

Create `agents/[name].md`:

```markdown
---
model: [if needed]
tools:
  - [tool list]
skills:
  - [skill list]
---

# [Name]

[Role description — one line]

## Process

1. [Step-by-step workflow]
2. [...]

## Constraints

- **NEVER** [key restriction]
- **ALWAYS** [key requirement]
```

### 7. Present and Confirm

Show the generated agent to the user. Explain tool and model choices.

## Rules

- **ALWAYS** follow principle of least privilege for tools.
- **NEVER** give write tools to read-only roles.
- **NEVER** give all tools to any agent — be selective.
- **ALWAYS** include a Constraints section with NEVER/ALWAYS rules.
- Keep the process section to 5-8 steps max.
