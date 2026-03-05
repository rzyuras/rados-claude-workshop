# /init — Generate CLAUDE.md from your project

Scan the current repository and generate a comprehensive CLAUDE.md file.

## Steps

### 1. Detect Stack

Scan the root directory for manifest files and identify the tech stack:

| File | Stack |
|------|-------|
| `package.json` | Node.js (check for typescript, framework in deps) |
| `Gemfile` | Ruby (check for rails, sinatra) |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pyproject.toml` / `requirements.txt` | Python (check for django, flask, fastapi) |
| `pom.xml` / `build.gradle` | Java/Kotlin |
| `composer.json` | PHP |

For monorepos, scan subdirectories too. List all stacks found.

### 2. Read Configs

For each detected stack, read relevant config files:

- **Linter**: `.eslintrc*`, `.rubocop.yml`, `ruff.toml`, `.golangci.yml`
- **Formatter**: `.prettierrc*`, `.editorconfig`
- **Test runner**: `jest.config*`, `vitest.config*`, `.rspec`, `pytest.ini`
- **CI/CD**: `.github/workflows/*.yml`, `.gitlab-ci.yml`, `Jenkinsfile`
- **Docker**: `Dockerfile*`, `docker-compose*.yml`
- **Package manager**: lock files (`pnpm-lock.yaml`, `yarn.lock`, `Gemfile.lock`)

Extract: what linter runs, what test command to use, what CI checks.

### 3. Map Architecture

- List top-level directories and their purpose.
- Identify entry points (`src/index.*`, `app/*`, `main.*`).
- Note key patterns (MVC, modular, monorepo, microservices).
- Read a few representative files to understand code organization.

### 4. Extract Git Conventions

```bash
# Recent commit messages
git log --oneline -20

# Branch naming
git branch -a | head -20

# Check for conventional commits
git log --oneline -50 | head -20
```

Infer: commit format, branch naming, PR workflow.

### 5. Generate CLAUDE.md

Write a `CLAUDE.md` file at the project root with these sections:

```markdown
# [Project Name]

[One-line description inferred from README or package.json]

## Stack

[Table: component → technology]

## Architecture

[Brief description of directory structure and patterns]

## Commands

[Table: command → description, grouped by area]

## Conventions

- Git branch format: [detected pattern]
- Commit format: [detected pattern]
- [Other conventions found]

## Key Files

[List of important entry points, configs, and patterns]
```

### 6. Present to User

Show the generated CLAUDE.md content and ask:
- "Does this look correct?"
- "Anything to add or change?"

Apply any feedback before writing the final file.

## Rules

- **NEVER** guess — if you can't detect something, skip that section.
- **NEVER** include secrets, tokens, or environment-specific values.
- **ALWAYS** read actual files, don't assume based on file names alone.
- Keep it concise. CLAUDE.md should be a quick reference, not documentation.
- If a README exists, use it for project name and description.
