#!/bin/bash

# Script to flatten repository structure into a single text file
# Usage: ./flatten_repo.sh

OUTPUT_FILE="repo_structure.txt"

echo "Flattening repository structure to $OUTPUT_FILE..."

# Clear the output file
> "$OUTPUT_FILE"

# Add header
echo "=========================================" >> "$OUTPUT_FILE"
echo "REPOSITORY STRUCTURE AND CONTENT" >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "=========================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Show directory tree structure first
echo "DIRECTORY TREE:" >> "$OUTPUT_FILE"
echo "---------------" >> "$OUTPUT_FILE"
# Use tree if available, otherwise use find
if command -v tree >/dev/null 2>&1; then
    tree -a -I '.git|.DS_Store|*.log|node_modules|vendor|tmp' >> "$OUTPUT_FILE"
else
    find . -type f \
        -not -path './.git/*' \
        -not -path './node_modules/*' \
        -not -path './vendor/*' \
        -not -path './tmp/*' \
        -not -name '.DS_Store' \
        -not -name '*.log' \
        | sort >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Add file contents
echo "FILE CONTENTS:" >> "$OUTPUT_FILE"
echo "-------------" >> "$OUTPUT_FILE"

# Find all relevant files and process them
find . -type f \
    -not -path './.git/*' \
    -not -path './node_modules/*' \
    -not -path './vendor/*' \
    -not -path './tmp/*' \
    -not -path './spike/*' \
    -not -path './.vscode/*' \
    -not -path './bin/*' \
    -not -path './.bundle/*' \
    -not -name '.DS_Store' \
    -not -name '*.log' \
    -not -name '*Gem*' \
    -not -name '.rspec' \
    -not -name '.rubocop*' \
    -not -name '*spec_helper*' \
    -not -name '*flatten*' \
    -not -name '*ruby-lsp*' \
    -not -name "$OUTPUT_FILE" \
    | sort | while read -r file; do
    
    # Skip binary files
    if file "$file" | grep -q "text\|empty"; then
        echo "" >> "$OUTPUT_FILE"
        echo "================================================" >> "$OUTPUT_FILE"
        echo "FILE: $file" >> "$OUTPUT_FILE"
        echo "================================================" >> "$OUTPUT_FILE"
        
        # Check if file is empty
        if [[ ! -s "$file" ]]; then
            echo "(empty file)" >> "$OUTPUT_FILE"
        else
            cat "$file" >> "$OUTPUT_FILE"
        fi
        
        echo "" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "=========================================" >> "$OUTPUT_FILE"
echo "END OF REPOSITORY STRUCTURE" >> "$OUTPUT_FILE"
echo "=========================================" >> "$OUTPUT_FILE"

echo "Done! Repository structure saved to $OUTPUT_FILE"
echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo "You can now upload $OUTPUT_FILE for review."
