# /generate-skill — Create a skill from codebase patterns

Analyze existing code patterns and generate a SKILL.md that codifies them.

## Usage

```
/generate-skill [pattern-name]
```

Example: `/generate-skill controllers`, `/generate-skill services`, `/generate-skill models`

## Steps

### 1. Find Examples

Search for files matching the pattern name:

```bash
# Try common locations
find . -path "*/controllers/*" -o -path "*/services/*" -o -name "*controller*" -o -name "*service*" | head -20
```

Use Glob and Grep to locate 3-5 representative files.

### 2. Read and Analyze

Read each example file. Extract:

- **Naming**: file naming convention (PascalCase, snake_case, kebab-case)
- **Imports**: what's imported, ordering pattern
- **Structure**: class vs function, export style, method ordering
- **Error handling**: try/catch, Result types, error classes
- **Types**: how types/interfaces are defined and used
- **Test patterns**: corresponding test files, test structure

### 3. Find Commonalities

Compare all examples. Identify:

- What's always the same (ALWAYS rules)
- What's never done (NEVER rules)
- What varies but follows a pattern (templates)
- What dependencies are always used

### 4. Generate SKILL.md

Create `skills/[pattern-name]/SKILL.md`:

```markdown
# /[pattern-name]

[One-line description of when to use this skill]

## Template

[Code template with placeholders]

## Rules

- **ALWAYS** [consistent pattern found]
- **NEVER** [anti-pattern found]
- [Other conventions]

## Example

[One real example from the codebase, annotated]

## Checklist

- [ ] [Naming follows convention]
- [ ] [Imports ordered correctly]
- [ ] [Error handling present]
- [ ] [Test file exists]
```

### 5. Present and Confirm

Show the generated skill to the user. Ask:
- "Does this capture the pattern correctly?"
- "Any rules to add or modify?"

Write the file after approval.

## Rules

- **ALWAYS** read real code — never generate patterns from assumptions.
- **ALWAYS** include at least one real example from the codebase.
- **NEVER** create a skill with fewer than 3 example files analyzed.
- Keep the skill focused on one pattern. Don't mix controllers and services.
