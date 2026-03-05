#!/bin/bash
# Hook: PostToolUse (Edit, Write)
# Runs the appropriate linter after file edits.
# Exit 0 = success, Exit 2 = warning to model (non-blocking)

FILE="$CLAUDE_FILE_PATH"

if [ -z "$FILE" ]; then
  exit 0
fi

EXT="${FILE##*.}"

case "$EXT" in
  ts|tsx|js|jsx)
    if command -v npx &>/dev/null && [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/node_modules/.bin/eslint" ]; then
      npx eslint "$FILE" --no-error-on-unmatched-pattern 2>&1
      if [ $? -ne 0 ]; then
        echo "lint warning: eslint found issues in $FILE"
        exit 2
      fi
    fi
    ;;
  rb)
    if command -v bundle &>/dev/null && [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/Gemfile" ]; then
      bundle exec rubocop "$FILE" --format simple 2>&1
      if [ $? -ne 0 ]; then
        echo "lint warning: rubocop found issues in $FILE"
        exit 2
      fi
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check "$FILE" 2>&1
      if [ $? -ne 0 ]; then
        echo "lint warning: ruff found issues in $FILE"
        exit 2
      fi
    fi
    ;;
esac

exit 0
