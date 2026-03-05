# /conventions — Detect and display project conventions

Auto-detect coding conventions from the current project. Used by developer and reviewer agents.

## Steps

### 1. Detect Linter & Formatter

Search for config files:

```bash
ls .eslintrc* .prettierrc* .rubocop.yml ruff.toml .editorconfig pyproject.toml 2>/dev/null
```

Read each config and extract active rules.

### 2. Detect Naming Conventions

Sample 10-15 files across the project:

- **Files**: kebab-case, snake_case, PascalCase, camelCase?
- **Functions/methods**: camelCase, snake_case?
- **Classes/types**: PascalCase?
- **Constants**: UPPER_SNAKE_CASE?
- **Test files**: `*.test.*`, `*.spec.*`, `*_test.*`, `*_spec.*`?

### 3. Detect Import Patterns

Read 5 representative files and check:

- Import ordering (stdlib → external → internal → relative)
- Path aliases (`@/`, `~/`, `#`)
- Default vs named exports
- Barrel files (index.ts re-exports)

### 4. Detect Error Handling

Search for error handling patterns:

```bash
grep -r "catch\|rescue\|Error\|Exception" --include="*.ts" --include="*.rb" --include="*.py" -l | head -5
```

Read examples. Note: custom error classes? Result types? Error middleware?

### 5. Detect Git Conventions

```bash
git log --oneline -20
git branch -a | head -10
```

Infer commit format and branch naming.

### 6. Output Checklist

Present findings as a verifiable checklist:

```markdown
## Conventions: [project name]

### Naming
- [ ] Files: [pattern]
- [ ] Functions: [pattern]
- [ ] Classes: [pattern]
- [ ] Tests: [pattern]

### Code Style
- [ ] Linter: [tool + key rules]
- [ ] Formatter: [tool]
- [ ] Import order: [pattern]

### Error Handling
- [ ] Pattern: [description]

### Git
- [ ] Branch: [pattern]
- [ ] Commit: [pattern]
```

## Rules

- **ALWAYS** read actual files — don't guess from file names.
- **ALWAYS** check at least 5 files before declaring a convention.
- **NEVER** report conventions you can't verify with examples.
- If a linter config exists, its rules take precedence over inferred patterns.
