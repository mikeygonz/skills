---
name: vault
description: |
  Save context from conversations to an Obsidian vault — decisions, lessons, ideas, references, and session summaries. Auto-categorizes and git-commits.

  Use when:
  - User says "save this," "log this," "remember this," "vault this"
  - User says "done" or "wrap this up" after a meaningful work session
  - User shares a link/article/tweet worth saving for later
  - User makes a decision and explains their reasoning
  - User has an insight or idea worth capturing
  - Proactively after a meaningful work session (suggest saving)
  - User asks to find something previously saved ("what did we decide about X")

  Do NOT use for casual chat, simple Q&A, or heartbeat-only periods.
---

# Vault

Save conversation context to an Obsidian vault. The model infers what to save, how to categorize it, and where it goes. The user never needs to remember commands.

## How It Works

1. User signals intent to save (or agent suggests it after a good session)
2. Agent extracts the relevant content from conversation
3. Agent categorizes it and picks the right folder
4. Agent composes markdown with frontmatter
5. `vault.sh` writes the file and auto git-commits

## Categories

Infer the category from context. When ambiguous, ask.

| Category | Folder | When to use |
|----------|--------|-------------|
| Session dump | `daily/` | End of a work session — capture decisions, takeaways, open threads |
| Decision | `decisions/` | A choice was made with reasoning — "we're going with X because Y" |
| Lesson | `learning/` | An insight, pattern, or thing learned — "TIL," "turns out," aha moments |
| Idea | `ideas/` | Something to explore later — side projects, features, experiments |
| Reference | `learning/` | A link, article, tweet, or tool worth retrieving later |

## Using vault.sh

The script handles file creation, frontmatter, and git-commit. Pipe markdown content to it:

```bash
echo '<markdown content>' | bash scripts/vault.sh <command> "title"
```

Commands: `done`, `decide`, `learn`, `idea`, `ref`, `search`, `sync`

- `done [topic]` — Appends to today's `daily/YYYY-MM-DD.md`
- `decide "title"` — Creates `decisions/<slug>.md`
- `learn "title"` — Creates `learning/<slug>.md`
- `idea "title"` — Creates `ideas/<slug>.md`
- `ref "title"` — Creates `learning/<slug>.md` (tagged `reference`)
- `search "query"` — Grep vault content
- `sync` — Commit + push to remote

## Content Structure

Adapt the structure to the category:

**Session dump:**
```markdown
## Topic Name

### Decisions
- What was decided and why

### Key Context
- Important things discussed

### Open Threads
- [ ] What's unfinished

### References
- Links, tickets, people involved
```

**Decision:**
```markdown
**Decision:** What was decided
**Context:** Why this came up
**Reasoning:** Why this over alternatives
**Related:** Tickets, links, people
```

**Lesson:**
```markdown
**Insight:** The core takeaway
**Context:** How we learned this
**Source:** Where it came from
```

**Idea:** Keep lightweight — one-liner + why it's interesting + next step.

**Reference:** URL + summary + key takeaways.

## Frontmatter

Every entry gets:
```yaml
---
title: "Title"
created: YYYY-MM-DD
tags: [type, topic1, topic2]
related: [DES-123, link, etc]  # when applicable
---
```

Use consistent tags:
- **Type:** `daily`, `decision`, `learning`, `idea`, `reference`
- **Source:** `telegram`, `claude-code`, `call`, `article`
- **Topic:** whatever fits — `multiplatform`, `openclaw`, `vidiq`, etc.

## Telegram Behavior

Telegram is one long conversation. When inferring what to save:
1. If the user says "save this" about a specific thing — capture that thing
2. If the user says "done" or "wrap up" — capture the full session since the last natural break
3. If multiple topics were discussed and it's ambiguous — ask: "Which part? The X discussion, the Y brainstorm, or everything?"
4. Skip heartbeat messages — they're noise

## Retrieval

When the user asks "what did we decide about X" or "find that thing about Y":

```bash
bash scripts/vault.sh search "query"
```

Then read the matching files and summarize.

## Proactive Suggestions

After a meaningful session, suggest saving. Keep it casual:
- "Want me to save this session to the vault?"
- "Good stuff — should I vault this?"

Don't suggest after casual chat, quick questions, or quiet periods.
