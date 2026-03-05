# Customizing the Workshop Kit

## Adding an Agent

Create a new file in `agents/`:

```markdown
---
model: sonnet  # optional: sonnet, opus, haiku
tools:
  - Read
  - Glob
  - Grep
  - Bash
skills:
  - conventions
---

# Agent Name

One-line role description.

## Process

1. Step one
2. Step two

## Constraints

- **NEVER** ...
- **ALWAYS** ...
```

Or use the meta skill: `/generate-agent my-agent "role description"`

## Adding a Skill

Create `skills/[name]/SKILL.md`:

```markdown
# /name — One-line description

## Steps

### 1. First Step
What to do.

### 2. Second Step
What to do next.

## Rules

- **ALWAYS** ...
- **NEVER** ...
```

Or use the meta skill: `/generate-skill pattern-name`

## Writing a Hook

Create a script in `hooks/`:

```bash
#!/bin/bash
# Exit 0 = success (allow)
# Exit 1 = block the action
# Exit 2 = warning (non-blocking)

FILE="$CLAUDE_FILE_PATH"
# your logic here
exit 0
```

Register it in `settings.local.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": ".claude/hooks/your-hook.sh"
      }
    ]
  }
}
```

Make it executable: `chmod +x hooks/your-hook.sh`

## Adjusting Permissions

Edit `settings.local.json` to add allowed commands:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test)",
      "Bash(bundle exec rspec)",
      "Bash(docker compose *)"
    ]
  }
}
```

## Overriding CLAUDE.md

After `/init` generates your CLAUDE.md, edit it freely. Add:

- Team-specific conventions
- Deploy instructions
- Environment setup
- Links to documentation

The generated file is a starting point, not a constraint.

## Available Hook Events

| Event | When | Use Case |
|-------|------|----------|
| `PreToolUse` | Before a tool runs | Validate, block |
| `PostToolUse` | After a tool runs | Lint, check |
| `Notification` | On notifications | Alert, log |

## Available Tools for Agents

| Tool | Description |
|------|-------------|
| Read | Read file contents |
| Glob | Find files by pattern |
| Grep | Search file contents |
| Edit | Modify existing files |
| Write | Create new files |
| Bash | Run shell commands |
| AskUserQuestion | Ask user for input |
| TaskCreate | Create a task |
| TaskUpdate | Update task status |
| TaskList | List all tasks |
| TaskGet | Get task details |
