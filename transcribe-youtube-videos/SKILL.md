---
name: transcribe-youtube-videos
description: Fetch transcripts from YouTube videos. Use when the user shares a YouTube URL, references a video, wants to know what someone said in a video, or needs video content as text.
compatibility: Requires Python 3.x and youtube-transcript-api package (pip3 install youtube-transcript-api)
metadata:
  author: mikeygonz
  version: "1.0"
---

# Transcribe YouTube Videos

Fetch transcripts from any YouTube video. No API key required.

## When to Activate

- User shares a YouTube URL and wants to discuss its content
- User asks "what did they say about X in this video?"
- User references a video and needs the transcript
- User wants to summarize, quote, or analyze video content

## Workflow

### Step 1: Extract Video ID

Parse the YouTube URL to extract the video ID. Handle these formats:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `VIDEO_ID` (direct ID)

### Step 2: Fetch Transcript

Run this Python script via Bash:

```bash
python3 -c "
from youtube_transcript_api import YouTubeTranscriptApi
api = YouTubeTranscriptApi()
transcript = api.fetch('VIDEO_ID')
for entry in transcript:
    print(entry.text)
"
```

Replace `VIDEO_ID` with the extracted ID.

### Step 3: Format Output

Present the transcript with:
1. A header indicating the video URL
2. The full transcript text (without timestamps for readability)
3. Optionally offer to save to a file if it's long

## Error Handling

If the transcript fetch fails:
1. Check if the video has captions enabled
2. Try fetching auto-generated captions with language fallback:

```bash
python3 -c "
from youtube_transcript_api import YouTubeTranscriptApi
api = YouTubeTranscriptApi()
transcript_list = api.list(video_id='VIDEO_ID')
print('Available transcripts:')
for t in transcript_list:
    print(f'  - {t.language} ({t.language_code})')
"
```

## Dependencies

Requires `youtube-transcript-api` Python package:
```bash
pip3 install youtube-transcript-api
```

If not installed, offer to install it for the user.
