# Transcribe

An [Agent Skill](https://agentskills.io/) for transcribing YouTube videos on-demand.

Compatible with Claude Code, Cursor, Gemini CLI, and other [skills-compatible agents](https://agentskills.io/).

## Installation

### Via skills.sh CLI

```bash
npx skills add mikeygonz/claude-transcribe
```

### Manual installation

1. Install the Python dependency:
```bash
pip3 install youtube-transcript-api
```

2. Copy the skill to your agent's skills directory:
```bash
# For Claude Code
cp -r transcribe ~/.claude/skills/
```

## Usage

Ask your agent to transcribe any YouTube video:

```
transcribe https://www.youtube.com/watch?v=VIDEO_ID
```

Or with just the video ID:

```
transcribe VIDEO_ID
```

You can also just say "transcribe this video" with a URL in your message.

## What it does

1. Extracts the video ID from various YouTube URL formats
2. Fetches the transcript using `youtube-transcript-api`
3. Returns clean text (no timestamps) for easy reading

## Supported URL formats

- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `VIDEO_ID` (direct)

## Requirements

- Python 3.x
- `youtube-transcript-api` package

## License

MIT
