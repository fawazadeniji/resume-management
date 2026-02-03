#!/bin/bash
# Simple build script to compile the CV

# Colors
RED='\033[0;31m' # errors/failures
GREEN='\033[0;32m' # success messages
YELLOW='\033[0;33m' # file names in errors
BLUE='\033[0;34m' # progress indicators
CYAN='\033[0;36m' #  file paths
NC='\033[0m' # No Color

# Make the output directory if it doesn't exist
mkdir -p output

build_resume() {
    local DATA_FILE="$1"
    local DATA_PATH="data/$DATA_FILE"

    if [[ ! -f "$DATA_PATH" ]]; then
        echo -e "${RED}✗ Error:${NC} Data file '${YELLOW}$DATA_PATH${NC}' not found"
        return 1
    fi

    # Extract base name from data file (e.g., resume.json -> resume)
    local BASE_NAME
    BASE_NAME=$(basename "$DATA_FILE" .json)

    echo -e "${BLUE}⟳${NC} Compiling resume from ${CYAN}$DATA_PATH${NC}..."

    # Find the next version number
    local VERSION=1
    while [[ -f "output/${BASE_NAME}_v${VERSION}.pdf" ]]; do
        ((VERSION++))
    done

    local OUTPUT_FILE="output/${BASE_NAME}_v${VERSION}.pdf"

    # Compile the typst file, passing the data file name as input
    # --root . sets the project root so /data/ paths resolve correctly
    # --font-path ensures Font Awesome icons are found
    if typst compile --root . --font-path "$HOME/.local/share/fonts" --input "data=$DATA_FILE" templates/cv_engine.typ "$OUTPUT_FILE"; then
        echo -e "${GREEN}✓ Done!${NC} Check ${CYAN}$OUTPUT_FILE${NC}"
    else
        echo -e "${RED}✗ Failed to compile${NC} ${YELLOW}$DATA_FILE${NC}"
        return 1
    fi
}

# Check for -a flag to build all JSON files
if [[ "$1" == "-a" ]]; then
    echo -e "${BLUE}▶ Building all resumes...${NC}"
    for json_file in data/*.json; do
        if [[ -f "$json_file" ]]; then
            build_resume "$(basename "$json_file")"
        fi
    done
    echo -e "${GREEN}▶ All builds complete!${NC}"
else
    # Use provided data file or default to resume.json
    DATA_FILE="${1:-resume.json}"
    build_resume "$DATA_FILE"
fi