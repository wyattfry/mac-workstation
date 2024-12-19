#!/bin/bash

# Ensure that exactly three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <start_line> <end_line> <file>"
    exit 1
fi

# Get the start and end line numbers and the filename
start_line=$1
end_line=$2
file=$3

# Validate that start_line is less than or equal to end_line
if [ "$start_line" -gt "$end_line" ]; then
    echo "Error: start_line must be less than or equal to end_line."
    exit 1
fi

# Preserve the original file's permissions (mode)
file_mode=$(stat -f "%Lp" "$file")

# Extract the section of the file (lines start_line through end_line)
# Sort the extracted section, and then replace it back in the file
{
    head -n $((start_line - 1)) "$file"   # Print lines before the section
    sed -n "${start_line},${end_line}p" "$file" | sort  # Sort the section
    tail -n +$((end_line + 1)) "$file"   # Print lines after the section
} > "$file.sorted"  # Save the output to a temporary file

# Replace the original file with the sorted one
mv "$file.sorted" "$file"

# Restore the original file permissions
chmod "$file_mode" "$file"

# echo "Section $start_line to $end_line of '$file' has been sorted, and file permissions have been preserved."
