#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <numbers_file> <photos_folder>"
    exit 1
fi

numbers_file="$1"
photos_folder="$2"

if [[ ! -f "$numbers_file" ]]; then
    echo "Error: numbers file '$numbers_file' not found"
    exit 1
fi

if [[ ! -d "$photos_folder" ]]; then
    echo "Error: photos folder '$photos_folder' not found"
    exit 1
fi

output_folder="$photos_folder/good photos"
mkdir -p "$output_folder"

matched=0

while IFS= read -r number || [[ -n "$number" ]]; do
    # Skip empty lines
    [[ -z "$number" ]] && continue

    while IFS= read -r -d '' photo; do
        filename="$(basename "$photo")"
        if [[ "$filename" == *"$number"* ]]; then
            echo "Moving: $filename"
            mv "$photo" "$output_folder/"
            matched=$((matched + 1))
        fi
    done < <(find "$photos_folder" -maxdepth 1 \( -name "*.jpg" -o -name "*.JPG" \) -print0)

done < "$numbers_file"

echo "Done. $matched photo(s) moved to '$output_folder'."
