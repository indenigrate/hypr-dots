#!/bin/bash

# Define where to store the cover and the cached URL
COVER_PATH="/tmp/spotify_cover.jpg"
LAST_URL_FILE="/tmp/spotify_cover_last_url"

# Fetch the artwork URL from playerctl
ART_URL=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)

# If Spotify is closed or nothing is playing, exit cleanly
if [ -z "$ART_URL" ]; then
    # You can comment out the next line if you want to keep the last cover visible when paused/closed
    rm -f "$COVER_PATH"
    echo "" > "$LAST_URL_FILE"
    echo "$COVER_PATH"
    exit 0
fi

# Read the last known URL
if [ -f "$LAST_URL_FILE" ]; then
    LAST_URL=$(cat "$LAST_URL_FILE")
else
    LAST_URL=""
fi

# Only process the image if the URL has changed (new song)
if [ "$ART_URL" != "$LAST_URL" ]; then
    # Some players return a local file:// path, Spotify usually returns an https:// link
    if [[ "$ART_URL" == file://* ]]; then
        LOCAL_PATH="${ART_URL#file://}"
        cp "$LOCAL_PATH" "$COVER_PATH"
    else
        curl -s "$ART_URL" -o "$COVER_PATH"
    fi
    
    # Save the new URL to our cache file
    echo "$ART_URL" > "$LAST_URL_FILE"
fi

# hyprlock expects the script to output the file path of the image to render
echo "$COVER_PATH"
