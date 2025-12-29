#!/bin/bash

# A script to create a bookmark from the currently selected text (a YouTube URL).

# --- Configuration ---
# IMPORTANT: Replace "YOUR_SECRET_TOKEN" with your actual API token.
AUTH_TOKEN="9a2956c8f555c9a309a3befae190e1c2e07cf5fd"
API_BASE_URL="http://localhost:9090/api/bookmarks"

# --- Main Script ---

# 1. Check if required tools are installed.
if ! command -v xclip &> /dev/null; then
    echo "Error: xclip is not installed. Please install it to use this script."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it to parse the API response."
    exit 1
fi

# 2. Get the selected text from the clipboard.
SELECTED_URL=$(xclip -o -selection primary)

if [ -z "$SELECTED_URL" ]; then
    echo "No text selected. Please select a URL."
    exit 1
fi

echo "Selected URL: $SELECTED_URL"

# 3. Call the first API to get bookmark metadata.
# The 'curl' command fetches the data, and 'jq' parses the JSON response.
echo "Fetching metadata..."
METADATA_RESPONSE=$(curl -s -G --data-urlencode "url=$SELECTED_URL" "$API_BASE_URL/check/")

if [ -z "$METADATA_RESPONSE" ]; then
    echo "Error: Failed to get a response from the metadata API."
    exit 1
fi

# 4. Extract the required fields from the JSON response using jq.
URL=$(echo "$METADATA_RESPONSE" | jq -r '.metadata.url')
TITLE=$(echo "$METADATA_RESPONSE" | jq -r '.metadata.title')
DESCRIPTION=$(echo "$METADATA_RESPONSE" | jq -r '.metadata.description')

# Check if the extracted values are valid
if [ "$URL" = "null" ] || [ "$TITLE" = "null" ]; then
    echo "Error: Could not parse metadata from the API response."
    echo "Response was: $METADATA_RESPONSE"
    exit 1
fi

echo "Title found: $TITLE"

# 5. Construct the JSON payload for the POST request.
# Using jq ensures that all strings are correctly escaped for JSON.
JSON_PAYLOAD=$(jq -n \
                  --arg url "$URL" \
                  --arg title "$TITLE" \
                  --arg description "$DESCRIPTION" \
                  '{url: $url, title: $title, description: $description, notes: "", is_archived: false, unread: false, shared: false}')

# 6. Send the POST request to create the bookmark.
echo "Creating bookmark..."
POST_RESPONSE=$(curl -s -X POST "$API_BASE_URL/" \
     -H "Content-Type: application/json" \
     -H "Authorization: Token $AUTH_TOKEN" \
     -d "$JSON_PAYLOAD")

# 7. Display the result.
if echo "$POST_RESPONSE" | jq -e .id >/dev/null; then
    echo "Bookmark created successfully!"
    echo "Response: $POST_RESPONSE"
else
    echo "Error: Failed to create bookmark."
    echo "Response: $POST_RESPONSE"
    exit 1
fi

exit 0
