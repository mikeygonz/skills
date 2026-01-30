# Claude Transcribe

A [Claude Code](https://claude.ai/claude-code) skill for transcribing YouTube videos on-demand.

## Installation

### 1. Install the Python dependency

```bash
pip3 install youtube-transcript-api
```

### 2. Copy the skill to your Claude Code commands

```bash
cp transcribe.md ~/.claude/commands/
```

## Usage

In Claude Code, run:

```
/transcribe https://www.youtube.com/watch?v=VIDEO_ID
```

Or with just the video ID:

```
/transcribe VIDEO_ID
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

- [Claude Code](https://claude.ai/claude-code)
- Python 3.x
- `youtube-transcript-api` package

## License

MIT
