#!/bin/bash
# Usage: ./spotify-status.sh title (or artist, album, status)

# Fetch the specific metadata
OUTPUT=$(playerctl metadata -p spotify --format "{{$1}}" 2>/dev/null)

# Exit cleanly if Spotify is closed
if [ -z "$OUTPUT" ]; then
    exit 0
fi

# Truncate if longer than 25 characters
if [ ${#OUTPUT} -gt 25 ]; then
    echo "${OUTPUT:0:22}..."
else
    echo "$OUTPUT"
fi
