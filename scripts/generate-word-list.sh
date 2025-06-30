#!/bin/bash

JSON_FILE="./src/data/words.json"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File $JSON_FILE not found"
    exit 1
fi

echo "Generating comma-separated word list from $JSON_FILE..."

# Use jq to extract all words, sort them, and join with commas
word_list=$(jq -r '.[].word' "$JSON_FILE" | sort | tr '\n' ',' | sed 's/,$//')

# Print the comma-separated list
echo "$word_list"
