#!/usr/bin/env python3
"""Watch a YouTube video using Gemini's video understanding API."""

import sys
import os

def watch(url: str, prompt: str, model: str = "gemini-2.5-flash"):
    from google import genai
    from google.genai import types

    api_key = os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        print("Error: GOOGLE_API_KEY not set", file=sys.stderr)
        sys.exit(1)

    client = genai.Client(api_key=api_key)
    response = client.models.generate_content(
        model=model,
        contents=types.Content(
            parts=[
                types.Part(
                    file_data=types.FileData(file_uri=url)
                ),
                types.Part(text=prompt)
            ]
        )
    )
    print(response.text)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: watch.py <youtube_url> <prompt> [model]")
        sys.exit(1)
    
    url = sys.argv[1]
    prompt = sys.argv[2]
    model = sys.argv[3] if len(sys.argv) > 3 else "gemini-2.5-flash"
    watch(url, prompt, model)
