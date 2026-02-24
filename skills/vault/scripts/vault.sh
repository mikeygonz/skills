#!/usr/bin/env bash
# vault.sh — Commit structured context to an Obsidian vault
# Usage: vault.sh <command> [args]
# Requires: VAULT_PATH env var (defaults to ~/vault)

set -euo pipefail

VAULT="${VAULT_PATH:-$HOME/vault}"

cmd="${1:-help}"
shift || true

timestamp() { date +"%Y-%m-%d"; }
now_iso() { date +"%Y-%m-%dT%H:%M:%S%z"; }
slugify() { echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//'; }

commit_vault() {
  local msg="${1:-vault update}"
  cd "$VAULT"
  git add -A
  if git diff --cached --quiet 2>/dev/null; then
    echo "No changes to commit"
  else
    git commit -m "$msg" --quiet
    echo "Committed: $msg"
  fi
}

push_vault() {
  cd "$VAULT"
  git push --quiet 2>/dev/null && echo "Pushed to remote" || echo "Push failed (offline?)"
}

case "$cmd" in

  done)
    # /done — End-of-session dump
    # Args: $1=topic (optional), stdin=content (markdown body)
    TOPIC="${1:-session}"
    DATE=$(timestamp)
    SLUG=$(slugify "$TOPIC")
    FILE="$VAULT/daily/$DATE.md"

    CONTENT=$(cat)

    if [[ -f "$FILE" ]]; then
      # Append to existing daily note
      printf "\n\n---\n\n%s" "$CONTENT" >> "$FILE"
    else
      cat > "$FILE" <<EOF
---
title: "$DATE"
created: $DATE
tags: [daily]
---

# $(date +"%A, %B %-d")

$CONTENT
EOF
    fi

    commit_vault "done: $TOPIC ($DATE)"
    echo "Saved to $FILE"
    ;;

  decide)
    # /decide — Log a decision
    # Args: $1=title, stdin=content
    TITLE="${1:?Usage: vault.sh decide \"Decision title\"}"
    DATE=$(timestamp)
    SLUG=$(slugify "$TITLE")
    FILE="$VAULT/decisions/$SLUG.md"

    CONTENT=$(cat)

    cat > "$FILE" <<EOF
---
title: "$TITLE"
created: $DATE
tags: [decision]
---

# $TITLE

$CONTENT
EOF

    commit_vault "decide: $TITLE"
    echo "Saved to $FILE"
    ;;

  learn)
    # /learn — Capture a lesson or insight
    # Args: $1=title, stdin=content
    TITLE="${1:?Usage: vault.sh learn \"Lesson title\"}"
    DATE=$(timestamp)
    SLUG=$(slugify "$TITLE")
    FILE="$VAULT/learning/$SLUG.md"

    CONTENT=$(cat)

    cat > "$FILE" <<EOF
---
title: "$TITLE"
created: $DATE
tags: [learning]
---

# $TITLE

$CONTENT
EOF

    commit_vault "learn: $TITLE"
    echo "Saved to $FILE"
    ;;

  idea)
    # /idea — Quick capture
    # Args: $1=title, stdin=content
    TITLE="${1:?Usage: vault.sh idea \"Idea title\"}"
    DATE=$(timestamp)
    SLUG=$(slugify "$TITLE")
    FILE="$VAULT/ideas/$SLUG.md"

    CONTENT=$(cat)

    cat > "$FILE" <<EOF
---
title: "$TITLE"
created: $DATE
tags: [idea]
---

# $TITLE

$CONTENT
EOF

    commit_vault "idea: $TITLE"
    echo "Saved to $FILE"
    ;;

  ref)
    # /ref — Save a reference (article, tweet, tool)
    # Args: $1=title, stdin=content
    TITLE="${1:?Usage: vault.sh ref \"Reference title\"}"
    DATE=$(timestamp)
    SLUG=$(slugify "$TITLE")
    FILE="$VAULT/learning/$SLUG.md"

    CONTENT=$(cat)

    cat > "$FILE" <<EOF
---
title: "$TITLE"
created: $DATE
tags: [reference]
---

# $TITLE

$CONTENT
EOF

    commit_vault "ref: $TITLE"
    echo "Saved to $FILE"
    ;;

  search)
    # Search vault by content
    QUERY="${1:?Usage: vault.sh search \"query\"}"
    grep -ril "$QUERY" "$VAULT" --include="*.md" 2>/dev/null | grep -v ".obsidian" | head -20
    ;;

  sync)
    # Commit and push
    commit_vault "vault sync $(timestamp)"
    push_vault
    ;;

  help)
    cat <<EOF
vault.sh — Commit structured context to your Obsidian vault

Commands:
  done [topic]     End-of-session dump (appends to daily note)
  decide "title"   Log a decision with context
  learn "title"    Capture a lesson or insight
  idea "title"     Quick idea capture
  ref "title"      Save a reference (article, tweet, tool)
  search "query"   Search vault content
  sync             Commit and push to remote

Content is read from stdin. Example:
  echo "We decided to use React" | vault.sh decide "Frontend framework choice"
EOF
    ;;

  *)
    echo "Unknown command: $cmd" >&2
    echo "Run 'vault.sh help' for usage" >&2
    exit 1
    ;;
esac
