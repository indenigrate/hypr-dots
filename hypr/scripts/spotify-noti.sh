#!/bin/bash

# Get metadata from Spotify
#TITLE=$(playerctl metadata xesam:title)
#ARTIST=$(playerctl metadata xesam:artist)
URL=$(playerctl metadata mpris:artUrl)

# Check if artwork URL exists
if [[ -n "$URL" ]]; then
    # Download album art locally (replace image if it exists)
    curl -s "$URL" --output /tmp/spotify_cover.jpg
    ICON_PATH="/tmp/spotify_cover.jpg"
else
    # Use a default Spotify icon if no album art is found
    cp ~/.config/hypr/scripts/youtube-logo.jpg /tmp/spotify_cover.jpg
fi

# Send notification with album art
#notify-send -i "$ICON_PATH" "Now Playing" "$ARTIST - $TITLE"
