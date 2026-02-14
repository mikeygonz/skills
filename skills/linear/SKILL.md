---
name: linear
description: |
  Manage Linear tickets from your AI agent — read, create, update, and triage issues via the Linear GraphQL API. Includes a bash CLI wrapper for common operations.

  Use when:
  - User mentions a ticket ID (e.g., "ENG-123")
  - User asks "what's on my board" or "show my tickets"
  - User wants to create a new issue
  - User asks to update ticket status/priority
  - User wants a standup summary
---

# Linear Integration

Manage Linear issues directly from your AI agent using the Linear GraphQL API. Includes a lightweight bash CLI (`linear.sh`) that wraps common operations.

## Setup

Requires `LINEAR_API_KEY` environment variable. Generate one at [Linear Settings → API](https://linear.app/settings/api).

## CLI Usage

```bash
LINEAR_API_KEY="$LINEAR_API_KEY" ./scripts/linear.sh <command> [args]
```

### Commands

| Command | Description |
|---------|-------------|
| `my-issues` | Your assigned open issues |
| `my-todos` | Your Todo items |
| `urgent` | Urgent/High priority issues across workspace |
| `teams` | List available teams |
| `team <TEAM_KEY>` | Team issues (e.g., `team ENG`) |
| `project <name>` | Issues in a project |
| `issue <ID>` | Full issue details (e.g., `issue ENG-123`) |
| `branch <ID>` | Get Linear branch name for git |
| `create <TEAM_KEY> "title" ["description"]` | Create a new issue |
| `comment <ID> "text"` | Add a comment |
| `status <ID> <state>` | Update status (`todo`, `progress`, `review`, `done`, `blocked`) |
| `priority <ID> <level>` | Set priority (`urgent`, `high`, `medium`, `low`, `none`) |
| `assign <ID> <username>` | Assign to a user |
| `projects` | List all projects |
| `standup` | Daily standup summary (todos, in progress, blocked, recently done) |

### Examples

```bash
# See what's on your plate
linear.sh my-issues

# Get full details on a ticket
linear.sh issue ENG-123

# Create a bug report
linear.sh create ENG "Fix login redirect" "Users are redirected to 404 after OAuth"

# Move a ticket to In Progress
linear.sh status ENG-123 progress

# Daily standup
linear.sh standup
```

## Agent Guidelines

### Reading Tickets
- Always fetch full issue details before acting on a ticket
- Use `branch <ID>` to get the correct git branch name

#### Fetching Images from Tickets

Linear ticket descriptions often contain screenshots, diagrams, and mockups. These are critical context — don't skip them.

1. Check the description for markdown images: `![...](https://uploads.linear.app/...)`
2. Download them:
   ```bash
   curl -s -o /tmp/linear-ENG-123-1.jpg "<image-url>"
   ```
3. View with your agent's image tool

**Note:** Linear image URLs have time-limited signature tokens. If a download fails with 401, refetch the ticket to get a fresh URL.

#### Fetching Linked Notion Research

Many teams keep research, design context, and visual references in Notion pages linked to Linear tickets. After fetching a Linear ticket, check for linked Notion content:

1. Search Notion for a page matching the ticket ID:
   ```
   notion-search(query: "ENG-123", filter: "page")
   ```

2. If found, fetch the full page:
   ```
   notion-fetch(pageId: "<page-id>")
   ```

3. Extract and download images from the Notion page — these often contain:
   - UI patterns and references
   - Competitor screenshots
   - Wireframes and mockups
   - Visual inspiration

   Notion image URLs are in `image.file.url` (hosted) or `image.external.url` (external). Note: Notion-hosted URLs expire — re-fetch the page if downloads fail.

This gives you the full picture:
- **Linear**: spec, acceptance criteria, status
- **Notion**: research, visual references, design context

Requires the Notion MCP server or API access. Skip this step if your team doesn't use Notion.

### MCP Integration

If you have the [Linear MCP server](https://github.com/linear/linear-mcp) configured, you can use MCP tools directly for richer integration:

| Tool | Purpose |
|------|---------|
| `get_issue` | Fetch ticket details by ID |
| `list_issues` | Search/filter tickets |
| `create_issue` | Create new ticket |
| `update_issue` | Update existing ticket |
| `list_comments` / `create_comment` | Read/add comments |
| `list_projects` / `get_project` | Project management |
| `list_teams` / `get_team` | Team info |
| `list_cycles` | Sprint/cycle info |

The CLI script works standalone without MCP — use whichever fits your setup.

### Creating Tickets

**Title convention:** Start with a verb. "Add dark mode toggle" not "Dark mode toggle feature." Keep it short and scannable.

Delete sections you don't need — these are prompts, not bureaucracy. Write only as much as you need ([Linear Method](https://linear.app/method/write-issues-not-user-stories)).

#### Feature
```markdown
## What
<!-- One sentence: what are we building? -->

## Why
<!-- What problem does this solve? Link to feedback, metrics, or discussion. -->

## Design
<!-- Figma link, screenshots, or "TBD — spike needed first" -->

## Scope
- [ ] ...
- [ ] ...

## Notes
<!-- Edge cases, dependencies. Delete if not needed. -->
```

#### Bug
```markdown
## What's broken
<!-- What's happening vs. what should happen? -->

## Repro
1. ...
2. ...

## Evidence
<!-- Screenshot, video, error log, or user quote -->

## Severity
<!-- Blocker / Painful / Annoying / Cosmetic -->
```

#### Spike / Research
```markdown
## Question
<!-- What are we trying to answer? -->

## Context
<!-- Why now? What decision depends on this? -->

## Deliverable
<!-- e.g., "Figma explorations + recommendation" / "Prototype in /labs" -->

## Timebox
<!-- Default: 1-2 days max. -->
```

#### Improvement / Polish
```markdown
## What
<!-- What specifically needs improvement? -->

## Current → Better
<!-- e.g., "Modal snaps open → modal eases in with 200ms spring" -->

## Why now
<!-- What triggered this? Delete if obvious. -->
```

### Comments & Edits Policy
- **Never add comments without explicit user approval** — draft first, then ask
- Reading tickets is always fine; writing requires permission

### Workflow

```
Triage → Backlog → Todo → In Progress → In Review → Done
```

## Configuration

Set these environment variables for convenience:

| Variable | Description |
|----------|-------------|
| `LINEAR_API_KEY` | Required. Your Linear API key |
| `LINEAR_DEFAULT_TEAM` | Optional. Default team key (e.g., `ENG`) |

## Requirements

- `curl`
- `jq`
- A Linear API key with read/write access
