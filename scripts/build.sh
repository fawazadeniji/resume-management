#!/bin/bash
# Simple build script to compile the CV

# Use provided data file or default to resume.json
DATA_FILE="${1:-resume.json}"
DATA_PATH="data/$DATA_FILE"

if [[ ! -f "$DATA_PATH" ]]; then
    echo "Error: Data file '$DATA_PATH' not found"
    exit 1
fi

# Extract base name from data file (e.g., resume.json -> resume)
BASE_NAME=$(basename "$DATA_FILE" .json)

echo "Compiling resume from $DATA_PATH..."

# Make the output directory if it doesn't exist
mkdir -p output

# Find the next version number
VERSION=1
while [[ -f "output/${BASE_NAME}_v${VERSION}.pdf" ]]; do
    ((VERSION++))
done

OUTPUT_FILE="output/${BASE_NAME}_v${VERSION}.pdf"

# Compile the typst file, passing the data file name as input
typst compile --input "data=$DATA_FILE" templates/cv_engine.typ "$OUTPUT_FILE"

echo "Done! Check $OUTPUT_FILE"