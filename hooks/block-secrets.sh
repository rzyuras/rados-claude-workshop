#!/bin/bash
# Hook: PostToolUse (Edit, Write)
# Blocks writes to sensitive files or files containing secret patterns.
# Exit 0 = allow, Exit 1 = block action

FILE="$CLAUDE_FILE_PATH"

if [ -z "$FILE" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE")

# Block sensitive file names
case "$BASENAME" in
  .env|.env.*|*.pem|*.key|credentials.json|secrets.yml|secrets.yaml)
    echo "BLOCKED: cannot write to sensitive file: $BASENAME"
    exit 1
    ;;
esac

# Block if file content contains secret patterns
if [ -f "$FILE" ]; then
  if grep -qE '(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{20,}|-----BEGIN (RSA |EC )?PRIVATE KEY-----|ghp_[a-zA-Z0-9]{36}|xox[bporas]-[a-zA-Z0-9-]+)' "$FILE" 2>/dev/null; then
    echo "BLOCKED: file appears to contain secrets or API keys: $FILE"
    exit 1
  fi
fi

exit 0
