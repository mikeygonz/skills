# Skills

A collection of [Agent Skills](https://agentskills.io/) by [@mikeygonz](https://github.com/mikeygonz).

Compatible with Claude Code, Cursor, Gemini CLI, and other [skills-compatible agents](https://agentskills.io/).

## Available Skills

| Skill | Description | Install |
|-------|-------------|---------|
| [read-x](./skills/read-x/) | Read full X/Twitter posts and articles — no API key needed | `npx skills add mikeygonz/skills --skill read-x` |
| [watch-youtube](./skills/watch-youtube/) | Watch and analyze YouTube videos using Gemini's video understanding API | `npx skills add mikeygonz/skills --skill watch-youtube` |
| [linear](./skills/linear/) | Manage Linear tickets — CLI wrapper, agent guidelines, image fetching, Notion integration | `npx skills add mikeygonz/skills --skill linear` |

## Install All Skills

```bash
npx skills add mikeygonz/skills
```

## Requirements

Some skills have dependencies. Check individual skill folders for details.

## Credits

Skills in this repo are created by [@mikeygonz](https://github.com/mikeygonz). Attribution for dependencies:

- **read-x** — Uses [FxTwitter API](https://github.com/FixTweet/FxTwitter) for post/article extraction
- **watch-youtube** — Uses [Google Gemini API](https://ai.google.dev/gemini-api/docs/video-understanding) for video understanding
- **linear** — Uses [Linear GraphQL API](https://developers.linear.app/docs/graphql/working-with-the-graphql-api) + optional [Linear MCP](https://github.com/linear/linear-mcp) and [Notion MCP](https://github.com/makenotion/notion-mcp-server)

## License

MIT
