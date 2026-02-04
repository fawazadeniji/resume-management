#!/usr/bin/env bash
set -euo pipefail

# ==========================
# Resume build script
# ==========================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Directories
DATA_DIR="data"
TEMPLATE_DIR="templates"
OUTPUT_DIR="output"

# Defaults
TEMPLATE="cv_engine.typ"
BUILD_ALL=false
DRY_RUN=false
DATA_FILE="resume.json"
VALIDATE=true
VALIDATE_SCRIPT="./scripts/validate.sh"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# --------------------------
# Helpers
# --------------------------

error() {
    echo -e "${RED}✗ Error:${NC} $*" >&2
}

info() {
    echo -e "${BLUE}⟳${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

resolve_template() {
    local tpl="$1"

    if [[ -f "$tpl" ]]; then
        echo "$tpl"
    elif [[ -f "$TEMPLATE_DIR/$tpl" ]]; then
        echo "$TEMPLATE_DIR/$tpl"
    else
        return 1
    fi
}

show_help() {
    echo -e "${CYAN}Resume Builder${NC}"
    echo
    echo -e "${GREEN}Usage:${NC} ./scripts/build.sh [options] [data_file]"
    echo
    echo -e "${GREEN}Options:${NC}"
    echo "  -a                 Build all JSON files in data/"
    echo "  -t <template>      Specify template file (default: $TEMPLATE)"
    echo "  -n                 Dry run (print commands only)"
    echo "  -v, --no-validate  Skip schema validation"
    echo "  -h, --help         Show this help menu"
    echo

    echo -e "${GREEN}Examples:${NC}"
    echo "  ./scripts/build.sh"
    echo "  ./scripts/build.sh resume-robotics-ml.json"
    echo "  ./scripts/build.sh -a -t cv_engine.typ"
    echo ""

    echo -e "${GREEN}Available templates:${NC}"
    shopt -s nullglob
    for tpl in "$TEMPLATE_DIR"/*.typ; do
        echo "  $(basename "$tpl")"
    done

    echo
    echo -e "${GREEN}Available data files:${NC}"
    for json in "$DATA_DIR"/*.json; do
        echo "  $(basename "$json")"
    done
}

build_resume() {
    local data_file="$1"
    local data_path="$DATA_DIR/$data_file"
    local template_path="$2"

    [[ -f "$data_path" ]] || { error "Data file '$data_path' not found"; return 1; }

    if [[ "$VALIDATE" == true ]]; then
        if [[ -x "$VALIDATE_SCRIPT" ]]; then
            echo -e "${BLUE}▶ Validating ${CYAN}$data_path${NC}..."
            if ! "$VALIDATE_SCRIPT" "$data_path"; then
                echo -e "${RED}✗ Build aborted due to schema errors${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠ Validation skipped (validate.sh not executable)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Validation disabled${NC}"
    fi

    local base_name
    base_name="$(basename "$data_file" .json)"

    info "Compiling ${CYAN}$data_path${NC} with ${CYAN}$template_path${NC}"

    local version=1
    while [[ -f "$OUTPUT_DIR/${base_name}_v${version}.pdf" ]]; do
        ((version++))
    done

    local output_file="$OUTPUT_DIR/${base_name}_v${version}.pdf"

    local cmd=(
        typst compile
        --root .
        --font-path "$HOME/.local/share/fonts"
        --input "data=$data_file"
        "$template_path"
        "$output_file"
    )

    if [[ "$DRY_RUN" == true ]]; then
        echo "DRY RUN: ${cmd[*]}"
    else
        if "${cmd[@]}"; then
            success "Built ${CYAN}$output_file${NC}"
        else
            error "Failed to compile $data_file"
            return 1
        fi
    fi
}

# --------------------------
# Argument parsing
# --------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        -a)
            BUILD_ALL=true
            ;;
        -t)
            [[ $# -ge 2 ]] || { error "-t requires a template argument"; exit 1; }
            TEMPLATE="$2"
            shift
            ;;
        -n)
            DRY_RUN=true
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--no-validate)
            VALIDATE=false
            ;;
        *)
            DATA_FILE="$1"
            ;;
    esac
    shift
done

# --------------------------
# Resolve template
# --------------------------

if ! TEMPLATE_PATH="$(resolve_template "$TEMPLATE")"; then
    error "Template '$TEMPLATE' not found"
    exit 1
fi

# --------------------------
# Build
# --------------------------

shopt -s nullglob

if [[ "$BUILD_ALL" == true ]]; then
    info "Building all resumes using ${CYAN}$(basename "$TEMPLATE_PATH")${NC}"
    files=("$DATA_DIR"/*.json)
    [[ ${#files[@]} -gt 0 ]] || { error "No JSON files found in $DATA_DIR"; exit 1; }

    for file in "${files[@]}"; do
        build_resume "$(basename "$file")" "$TEMPLATE_PATH"
    done

    success "All builds complete!"
else
    if [[ -z "$DATA_FILE" ]]; then
        DATA_FILE="resume.json"
    fi
    build_resume "$DATA_FILE" "$TEMPLATE_PATH"
fi
