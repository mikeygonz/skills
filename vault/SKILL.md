---
name: vault
description: |
  Commit structured context to an Obsidian vault — decisions, lessons, ideas, references, and session summaries. Auto-commits to git.

  Use when:
  - User says /done — dump session takeaways to vault
  - User says /decide — log a decision with reasoning
  - User says /learn — capture a lesson or insight
  - User says /idea — quick idea capture
  - User says /ref — save a reference (article, tweet, tool, link)
  - User asks to "save this to the vault" or "log this"
  - End of a meaningful work session (proactively suggest /done)
---

# Vault

Commit structured context to an Obsidian vault with auto git-commit. Every entry gets frontmatter tags, timestamps, and lands in the right folder.

## Setup

Vault path defaults to `~/vault`. Override with `VAULT_PATH` env var.

Vault must be a git repo (for auto-commit).

## Commands

### /done [topic]

End-of-session dump. Extracts key context from the conversation and appends to today's daily note.

**How to use:** Gather from the recent conversation:
- Decisions made (and why)
- Key context and takeaways
- Open threads / unfinished items
- References (links, tickets, people)

If the user provides a topic, scope to that thread. If no topic, capture everything since the last natural break.

**If unsure what to capture:** Ask the user — "What should I capture? The multiplatform brainstorm, the vault skill work, or everything?"

Format the content as markdown sections, then pipe to the script:

```bash
echo '<content>' | bash scripts/vault.sh done "topic"
```

Appends to `daily/YYYY-MM-DD.md`. Creates the file if it doesn't exist.

### /decide "title"

Log a decision with full context.

Structure the content as:
- **Decision:** What was decided
- **Context:** Why this came up
- **Reasoning:** Why this choice over alternatives
- **Alternatives considered:** What else was on the table
- **Related:** Links to tickets, people, projects

```bash
echo '<content>' | bash scripts/vault.sh decide "Decision title"
```

Saves to `decisions/<slug>.md`.

### /learn "title"

Capture a lesson, pattern, or insight.

Structure as:
- **Insight:** The core takeaway
- **Context:** How we learned this
- **Application:** When to apply this in the future
- **Source:** Where it came from (conversation, article, experience)

```bash
echo '<content>' | bash scripts/vault.sh learn "Lesson title"
```

Saves to `learning/<slug>.md`.

### /idea "title"

Quick idea capture. Keep it lightweight.

Structure as:
- **Idea:** One-liner
- **Why it's interesting:** Brief context
- **Next step:** What would validate or explore this

```bash
echo '<content>' | bash scripts/vault.sh idea "Idea title"
```

Saves to `ideas/<slug>.md`.

### /ref "title"

Save a reference — article, tweet, tool, repo, anything worth retrieving later.

Structure as:
- **URL:** The link
- **Summary:** What it is and why it matters
- **Key quotes/takeaways:** The important bits
- **Tags:** For future retrieval

```bash
echo '<content>' | bash scripts/vault.sh ref "Reference title"
```

Saves to `learning/<slug>.md` with `[reference]` tag.

### Search

Find past entries:

```bash
bash scripts/vault.sh search "query"
```

### Sync

Commit and push to remote:

```bash
bash scripts/vault.sh sync
```

## Telegram-Specific Guidance

Telegram is one long thread. When handling /done:
1. If the user provides a topic — scope to that topic only
2. If no topic — capture everything since the last natural break in conversation
3. If multiple topics were discussed and it's ambiguous — ask which to capture
4. Heartbeat messages are noise — skip them when scanning for context

## Proactive Usage

After a meaningful work session (not casual chat), suggest: "Want me to /done this session to the vault?"

Do NOT suggest after:
- Casual chat / banter
- Simple Q&A (one-off questions)
- Heartbeat-only periods

## Frontmatter Tags

All entries get tags in frontmatter for retrieval. Use consistent tags:
- Source tags: `telegram`, `claude-code`, `call`, `article`
- Type tags: `daily`, `decision`, `learning`, `idea`, `reference`
- Topic tags: whatever fits — `multiplatform`, `openclaw`, `vidiq`, etc.

Add `related:` frontmatter linking to Linear tickets, vault notes, or URLs when applicable.
