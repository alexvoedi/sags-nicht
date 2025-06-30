#!/bin/bash
# filepath: check_duplicates.sh

JSON_FILE="./src/data/words.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File $JSON_FILE not found"
    exit 1
fi

echo "Checking for duplicate words in $JSON_FILE..."

# Use jq to extract all words and check for duplicates
duplicates=$(jq -r '.[].word' "$JSON_FILE" | sort | uniq -d)

if [ -z "$duplicates" ]; then
    echo "No duplicate words found."
    exit 0
else
    echo "Found duplicate words:"
    echo "$duplicates"
    exit 1
fi
