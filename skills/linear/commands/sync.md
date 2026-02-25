---
name: sync
description: Synchronize Linear issues with Notion workspace. Run explicitly with /sync or "sync my tasks".
---

# Linear-Notion Sync Command

Syncs Linear issues to Notion task pages. Linear = PRD/specs, Notion = your notes.

## What Gets Synced

- Task title
- Linear ID + URL
- Status (for board view)
- Priority
- Backlink from Linear to Notion

**NOT synced:** Description/PRD (stays in Linear only)

## Sync Workflow

### Step 1: Fetch Linear Issues

```
mcp__linear__list_issues:
- assignee: "me"
- includeArchived: false
```

This returns title, status, priority, id, url - no need for `get_issue`.

### Step 2: Check Existing Notion Pages

- Database: _(your Notion data source URL, e.g. `collection://your-data-source-id`)_
- Match by Linear ID property

### Step 3: Create or Update Notion Pages

**If new issue:**
1. Create page in Linear Tasks database:
   - Task (title): issue title
   - Linear ID: issue identifier (e.g., DES-297)
   - Linear URL: issue URL
   - Status: mapped from Linear (see mappings below)
   - Priority: mapped from Linear (see mappings below)
2. Leave page content blank (user adds their notes)

**If exists:**
- Update Status and Priority if changed
- Don't touch page content (user's notes)

### Step 4: Add Notion Backlinks to Linear

```json
{
  "id": "<issue_id>",
  "links": [{
    "url": "https://www.notion.so/<page_id>",
    "title": "Research"
  }]
}
```

### Step 5: Report Summary

Brief output:
```
Synced 5 issues: 1 new, 1 updated, 3 unchanged
```

## Key IDs

- **Database**: _(your Notion database ID)_
- **Data Source**: _(your Notion data source URL, e.g. `collection://your-data-source-id`)_

---

## Field Mappings

### Status Mapping

| Linear Status | Notion Status |
|---------------|---------------|
| Backlog       | Backlog       |
| Todo          | Todo          |
| In Progress   | In Progress   |
| Done          | Done          |
| Canceled      | Done          |

### Priority Mapping

| Linear Priority | Notion Priority |
|-----------------|-----------------|
| Urgent (1)      | Urgent          |
| High (2)        | High            |
| Medium (3)      | Medium          |
| Low (4)         | Low             |
| No Priority (0) | (blank)         |

### Field Mapping

| Linear         | Notion Property | Notes                    |
|----------------|-----------------|--------------------------|
| title          | Task (title)    | Direct copy              |
| identifier     | Linear ID       | e.g., DES-297            |
| url            | Linear URL      | Full Linear issue URL    |
| status         | Status          | Mapped per table above   |
| priority.name  | Priority        | Mapped per table above   |
| -              | Page content    | User notes (not synced)  |

## Source of Truth

- **Linear**: PRD, specs, status, priority
- **Notion**: Research notes, meeting notes, thinking
