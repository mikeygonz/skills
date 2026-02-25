---
name: create-issue
description: Create Linear issues from conversation context. Run with /create-issue or "create an issue".
---

# Create Linear Issue Command

Turn conversations, transcripts, or rough ideas into structured Linear issues.

## Workflow

### Step 1: Gather Context

User provides one or more of:
- Transcript (meeting, voice note, chat)
- Rough description of the problem/feature
- Screenshots or references
- Existing context from conversation

### Step 2: Draft the Issue

Extract and structure:
- **Title**: Clear, actionable (imperative form)
- **Description**: Problem, context, proposed solution
- **Team**: Default to Design team (fetch via `list_teams` if needed)
- **Priority**: Suggest based on urgency signals
- **Labels**: Suggest relevant labels (fetch via `list_issue_labels`)

Present the draft for review:
```
Title: [draft title]
Priority: [suggested]
Labels: [suggested]

---
[draft description in markdown]
---

Want to adjust anything before I create it?
```

### Step 3: Iterate

User can:
- Refine the title
- Adjust priority/labels
- Add/remove description sections
- Ask clarifying questions

Keep iterating until user confirms.

### Step 4: Create Issue

```
mcp__linear__create_issue:
- title: [final title]
- description: [final description]
- teamId: [team id]
- priority: [1-4 or 0]
- labelIds: [array of label ids]
```

### Step 5: Report & Link

After creation:
1. Return the issue URL
2. Ask if user wants to run `/sync` to create corresponding Notion page

## Description Template

```markdown
## Problem
[What's the issue or opportunity?]

## Context
[Background, user feedback, conversation excerpt]

## Proposed Solution
[High-level approach]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Notes
[Additional context, links, references]
```

## Priority Guide

| Signal | Priority |
|--------|----------|
| Blocking other work | Urgent (1) |
| User-facing bug, deadline | High (2) |
| Feature work, improvements | Medium (3) |
| Nice-to-have, cleanup | Low (4) |
| Unclear urgency | No Priority (0) |

## Tips

- Don't over-structure early ideas — keep description lean
- Title should make sense in a list view (no "We should..." or "I think...")
- Include transcript excerpts as context, not the whole thing
- Link to relevant docs/Notion pages in Notes section
