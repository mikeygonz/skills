---
name: figma-code-to-canvas
description: Set up Figma's Code to Canvas MCP integration for Claude Code. Pushes running UI from code into Figma as fully editable design layers. Use when user mentions "code to canvas", "push to figma", "figma MCP setup", "send to figma", or wants to turn code into Figma designs.
compatibility: Requires Figma desktop app with Dev Mode, a Figma Dev or Full seat on any paid plan, and Claude Code CLI.
metadata:
  author: mikeygonz
  version: "1.0"
---

# Figma Code to Canvas

Push running UI from Claude Code into Figma as fully editable design layers — real frames, components, styles, and layout structure (not screenshots).

Announced Feb 17, 2026 as a Figma x Anthropic partnership.

## When to Activate

- User wants to set up Figma's Code to Canvas MCP integration
- User asks "how do I push code to Figma?"
- User wants to send a running app's UI into Figma
- User mentions "code to canvas" or "generate figma design"
- User wants the bidirectional design-code loop (Figma → code → Figma)

## Concepts

**The Loop**: Design in Figma → generate code with Claude → capture working UI back into Figma as editable layers → refine on canvas → push updates back to code.

**Two MCP Servers**:
- **Remote** (`https://mcp.figma.com/mcp`): Includes `generate_figma_design` (Code to Canvas). Requires a Figma file URL.
- **Desktop** (`http://127.0.0.1:3845/mcp`): Runs locally via Figma desktop app. Supports selection-based input, design tokens, Code Connect. Does NOT include Code to Canvas by itself.

For the full experience, you want **both** servers configured.

## Setup Workflow

### Step 1: Add the Remote MCP Server

This is the server that provides `generate_figma_design` (Code to Canvas):

```bash
claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
```

### Step 2: Authenticate

1. Start a new Claude Code session (or restart current one)
2. Type `/mcp` to manage MCP servers
3. Select `figma`
4. Select **Authenticate**
5. Click **Allow Access** in the browser popup
6. Confirm: "Authentication successful. Connected to figma"

### Step 3: Verify Desktop Server (Optional but Recommended)

If the user also wants selection-based design context (reading from Figma):

1. Open **Figma desktop app** (not browser)
2. Open a Figma Design file
3. Toggle to **Dev Mode** (`Shift+D`)
4. In the Inspect panel, find MCP server section → **Enable desktop MCP server**
5. Add to Claude Code:

```bash
claude mcp add --scope user --transport http figma-desktop http://127.0.0.1:3845/mcp
```

### Step 4: Verify Tools

After setup, the following tools should be available:

| Tool | Source | Purpose |
|------|--------|---------|
| `generate_figma_design` | Remote | **Code to Canvas** — pushes UI as Figma layers |
| `get_design_context` | Desktop | Returns structured code representation of Figma selection |
| `get_screenshot` | Desktop | Screenshots of selected frames |
| `get_variable_defs` | Desktop | Extracts design tokens (color, spacing, typography) |
| `get_metadata` | Desktop | Layer metadata (IDs, names, types, positions) |
| `create_design_system_rules` | Desktop | Creates rule files for design-to-code translation |

## Capture Workflow

### Step 1: Get a Capture ID

Call `generate_figma_design` with `outputMode` and target file info. It returns a `captureId`.

### Step 2: Inject & Capture

**For local apps (localhost):** Add `<script src="https://mcp.figma.com/mcp/html-to-design/capture.js" async></script>` to your HTML, then open the page with the capture hash URL.

**For external sites (e.g. app.example.com):** Use AppleScript to inject the capture script into the user's browser tab via `fetch()` + `eval()`. This bypasses CSP because AppleScript's `execute javascript` runs through the DevTools protocol.

```applescript
-- Step 1: Load the capture script
tell application "Comet" to execute active tab of front window javascript "fetch(\"https://mcp.figma.com/mcp/html-to-design/capture.js\").then(r => r.text()).then(s => eval(s))"

-- Step 2: Verify it loaded
tell application "Comet" to execute active tab of front window javascript "typeof window.figma"
-- Should return "object"

-- Step 3: Fire the capture (replace CAPTURE_ID with actual ID)
tell application "Comet" to execute active tab of front window javascript "window.figma.captureForDesign({captureId:\"CAPTURE_ID\",endpoint:\"https://mcp.figma.com/mcp/capture/CAPTURE_ID/submit\",selector:\"body\"}).then(r => JSON.stringify(r))"
```

Replace `"Comet"` with the user's browser app name. Works with any Chromium browser that supports AppleScript (Chrome, Brave, Arc, Comet, etc.).

**Prerequisite:** The browser must have **View → Developer → Allow JavaScript from Apple Events** enabled.

**Important:** Creating a `<script>` element via AppleScript will be blocked by CSP on external sites. Always use `fetch()` + `eval()` instead — the DevTools protocol execution context bypasses CSP.

### Step 3: Poll for Completion

Call `generate_figma_design` with the `captureId` every 5 seconds until status is `completed`. Up to 10 polls.

## Usage Examples

Once configured, use prompts like:

- "Capture `https://app.example.com/dashboard` and send it to my Design Playground file."
- "Start a local server for my app and capture the UI in a new Figma file."
- "Send this to Figma."

Each captured screen becomes an editable Figma frame. For multi-screen flows, capture multiple screens in a single session.

## Requirements

- **Figma seat**: Dev or Full seat on any paid plan
- **Claude Code**: Installed and configured
- **For remote server**: Just a Figma file URL
- **For desktop server**: Figma desktop app with Dev Mode MCP enabled
- **For external site capture via AppleScript**: Browser must allow JavaScript from Apple Events

## References

- [Figma Blog: Code to Canvas Announcement](https://www.figma.com/blog/introducing-claude-code-to-figma/)
- [Figma Developer Docs: MCP Server](https://developers.figma.com/docs/figma-mcp-server/)
- [Figma Developer Docs: Tools and Prompts](https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/)
- [GitHub: figma/mcp-server-guide](https://github.com/figma/mcp-server-guide)
