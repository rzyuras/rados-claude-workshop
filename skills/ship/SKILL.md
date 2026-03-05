# /ship — Lint, commit, push, and open a PR

Generic shipping workflow. Detects stack, runs quality gates, commits with conventional format, pushes, and opens a PR.

## Steps

### 1. Detect Stack & Quality Gates

Scan for project files to determine which tools to run:

| File | Lint Command | Test Command |
|------|-------------|--------------|
| `package.json` (has eslint) | `npx eslint .` | `npm test` or `npx vitest --run` |
| `Gemfile` (has rubocop) | `bundle exec rubocop` | `bundle exec rspec` |
| `pyproject.toml` (has ruff) | `ruff check .` | `pytest` |
| `go.mod` | `golangci-lint run` | `go test ./...` |

### 2. Run Quality Gates

Run the detected linter and test runner. If either fails:
- Show the errors to the user.
- **STOP** — do not proceed until fixed.

### 3. Check Git Status

```bash
git status
git diff --stat
```

Review what changed. Identify files to stage.

### 4. Stage Files

Stage specific files — **NEVER** use `git add .` or `git add -A`.

```bash
git add path/to/changed/file1 path/to/changed/file2
```

Exclude: `.env`, `*.log`, `node_modules/`, build artifacts.

### 5. Generate Commit Message

Analyze the staged diff and generate a conventional commit message:

```
type(scope): description
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`

### 6. Confirm with User

Use AskUserQuestion to show the proposed commit message and ask for approval.

### 7. Commit

```bash
git commit -m "type(scope): description"
```

**NEVER** use `--no-verify`.

### 8. Push

```bash
git push -u origin $(git branch --show-current)
```

### 9. Create PR

```bash
gh pr create --title "type(scope): description" --body "## Summary
- [bullet points from diff]

## Test Plan
- [how to verify]"
```

### 10. Report

Show the user:
- Commit hash
- PR URL
- Any warnings from quality gates

## Rules

- **NEVER** use `git add .` — always stage specific files.
- **NEVER** skip quality gates. Lint and test must pass.
- **NEVER** use `--no-verify` on commit.
- **NEVER** force push unless explicitly asked.
- **ALWAYS** use conventional commit format.
- **ALWAYS** get user approval on the commit message before committing.
