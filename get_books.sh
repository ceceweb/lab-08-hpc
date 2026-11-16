#!/bin/bash
set -euo pipefail

bucket="$1"
dir="$2"

# Create the book directory if it does not exist yet
mkdir -p "$dir"

# Copy only the .txt files from the bucket (not index.html)
aws s3 cp "s3://$bucket" "$dir" --recursive --exclude "*" --include "*.txt"

# Turn the directory into an absolute path
abs_dir="$(realpath "$dir")"

# Write the header line, then one absolute path per line, sorted
echo "File path" > book_list.txt
find "$abs_dir" -name "*.txt" | sort >> book_list.txt

# Print how many books were listed (without the header)
echo $(tail -n +2 book_list.txt | wc -l)
