# rados-claude-workshop

Claude Code config kit: agents, skills, and hooks. Clone, symlink as `.claude/` in any project, run `/init`.

## What's Inside

| Directory | Purpose |
|-----------|---------|
| `agents/` | 4 agents: planner, developer, reviewer, shipper |
| `skills/` | 5 skills including 3 META generators |
| `hooks/` | 2 hooks: lint-on-save, block-secrets |
| `CLAUDE.md` | Template with placeholders — `/init` fills it |
| `settings.local.json` | Hook config + minimal permissions |
| `examples/` | Concrete skill, agent, and CLAUDE.md examples |
| `docs/` | Customization guide |

## Quick Start

```bash
# 1. Clone
git clone https://github.com/rzyuras/rados-claude-workshop.git

# 2. Symlink into your project
cd /path/to/your-project
ln -sfn /path/to/rados-claude-workshop .claude

# 3. Launch Claude Code and initialize
claude
> /init
```

That's it. `/init` scans your repo and generates a CLAUDE.md tailored to your stack.

## How the Symlink Works

```
your-project/
├── src/
├── package.json
└── .claude → /path/to/rados-claude-workshop
         ├── CLAUDE.md        ← Claude reads this automatically
         ├── agents/          ← available via --agent flag
         ├── skills/          ← available via /slash commands
         ├── hooks/           ← triggered on Edit/Write
         └── settings.local.json
```

Claude Code looks for `.claude/` in your project root. The symlink makes it find this kit's config.

## Agents

| Agent | Role | Model | Invocation |
|-------|------|-------|------------|
| **planner** | Analyzes codebase, decomposes into subtasks | sonnet | `claude --agent planner` |
| **developer** | Implements one subtask, runs lint + tests | default | `claude --agent developer` |
| **reviewer** | Reviews git diff, reports BLOCKER/WARNING/NIT | sonnet | `claude --agent reviewer` |
| **shipper** | Commits, pushes, opens PR | default | `claude --agent shipper` |

## Skills

### META Skills (the highlight)

These skills read your repo and generate config for you:

| Skill | What it does |
|-------|-------------|
| `/init` | Scans stack, configs, git history → generates CLAUDE.md |
| `/generate-skill` | Reads code patterns → generates a SKILL.md |
| `/generate-agent` | Takes a role description → generates an agent .md |

### Utility Skills

| Skill | What it does |
|-------|-------------|
| `/conventions` | Detects and displays project conventions |
| `/ship` | Lint → commit → push → PR (generic, any stack) |

## Hooks

| Hook | Trigger | Effect |
|------|---------|--------|
| `lint-on-save.sh` | PostToolUse (Edit/Write) | Runs eslint, rubocop, or ruff on edited file. Exit 2 = warning. |
| `block-secrets.sh` | PostToolUse (Edit/Write) | Blocks writes to .env, .pem, credentials. Detects API key patterns. Exit 1 = block. |

## Examples

The `examples/` directory shows what the META skills **actually produce** — concrete, production-quality output:

| Example | Shows |
|---------|-------|
| [`examples/skills/controllers/`](examples/skills/controllers/SKILL.md) | Express controller skill with `endpoint()` wrapper, response helpers, middleware chain, 8 ALWAYS/NEVER rules |
| [`examples/skills/actors/`](examples/skills/actors/SKILL.md) | Ruby service actor skill with actor type taxonomy, Play/Simple/Resilient patterns, error handling, 9 rules |
| [`examples/skills/components/`](examples/skills/components/SKILL.md) | React Native component skill with design tokens, MVVM split, component library usage, 7 rules |
| [`examples/agents/api-dev.md`](examples/agents/api-dev.md) | Domain-specific agent that writes API endpoints — constrained tools + linked skills |
| [`examples/generated-claude-md.md`](examples/generated-claude-md.md) | What `/init` generates for a Node.js + Express project |

**These are the level of detail you should aim for.** A good skill has:
- Templates with real import paths and code patterns
- 7+ ALWAYS/NEVER rules extracted from your codebase
- At least one complete, real example
- A verification checklist

## Customizing

See [`docs/customization.md`](docs/customization.md) for:

- Adding your own agents and skills
- Adjusting permissions in settings.local.json
- Writing custom hooks
- Overriding CLAUDE.md after `/init`

## Claude Code Concepts

| Concept | What | Where |
|---------|------|-------|
| **CLAUDE.md** | Project context loaded every session | Root or `.claude/CLAUDE.md` |
| **Agents** | Specialized roles with restricted tools | `.claude/agents/*.md` |
| **Skills** | On-demand prompts via `/slash` commands | `.claude/skills/*/SKILL.md` |
| **Hooks** | Shell scripts triggered on tool use | `.claude/hooks/` + `settings.local.json` |
| **Settings** | Permissions, hooks, model config | `.claude/settings.local.json` |
