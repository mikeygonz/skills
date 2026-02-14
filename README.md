# Skills

A collection of [Agent Skills](https://skills.sh) by [@mikeygonz](https://github.com/mikeygonz).

Compatible with [Claude Code](https://claude.com/product/claude-code), [Cursor](https://cursor.sh), [Gemini CLI](https://gemini.google.com), [OpenClaw](https://clawd.bot), and other [skills-compatible agents](https://skills.sh).

## Available Skills

| Skill | Description | Env Vars | Install |
|-------|-------------|----------|---------|
| [read-x](./skills/read-x/) | Read X/Twitter posts and articles | None | `npx skills add mikeygonz/skills --skill read-x` |
| [watch-youtube](./skills/watch-youtube/) | Watch and analyze YouTube videos via Gemini | `GOOGLE_API_KEY` | `npx skills add mikeygonz/skills --skill watch-youtube` |
| [linear](./skills/linear/) | Manage Linear tickets — CLI, templates, image fetching, Notion integration | `LINEAR_API_KEY` | `npx skills add mikeygonz/skills --skill linear` |
| [deploy-preview](./skills/deploy-preview/) | Deploy Vercel previews, check status, view logs, run Lighthouse audits | `VERCEL_TOKEN` | `npx skills add mikeygonz/skills --skill deploy-preview` |

## Install All

```bash
npx skills add mikeygonz/skills
```

## Setup

### API Keys

| Skill | Variable | Get it at | Required? |
|-------|----------|-----------|-----------|
| read-x | — | — | No keys needed |
| watch-youtube | `GOOGLE_API_KEY` | [aistudio.google.com/apikey](https://aistudio.google.com/apikey) | Yes (free) |
| linear | `LINEAR_API_KEY` | [linear.app/settings/api](https://linear.app/settings/api) | Yes |
| linear | `LINEAR_DEFAULT_TEAM` | Your team key (e.g., `ENG`) | Optional |
| deploy-preview | `VERCEL_TOKEN` | [vercel.com/account/tokens](https://vercel.com/account/tokens) | Yes |
| deploy-preview | `VERCEL_SCOPE` | Your team slug | Optional |

### Dependencies

All skills require `curl` and `jq`. The linear skill includes a bash CLI wrapper (`scripts/linear.sh`). The watch-youtube skill requires the `google-genai` Python package.

## Credits

- **read-x** — [FxTwitter API](https://github.com/FixTweet/FxTwitter) for post/article extraction
- **watch-youtube** — [Google Gemini API](https://ai.google.dev/gemini-api/docs/video-understanding) for video understanding
- **linear** — [Linear GraphQL API](https://developers.linear.app/docs/graphql/working-with-the-graphql-api) + optional [Linear MCP](https://github.com/linear/linear-mcp) and [Notion MCP](https://github.com/makenotion/notion-mcp-server)
- **deploy-preview** — [Vercel CLI](https://vercel.com/docs/cli) + [Vercel REST API](https://vercel.com/docs/rest-api) + [PageSpeed Insights API](https://developers.google.com/speed/docs/insights/v5/get-started)

## License

MIT
