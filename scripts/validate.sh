#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DATA_DIR="data"
SCHEMA="schema.json"

error() {
    echo -e "${RED}✗${NC} $*" >&2
}

info() {
    echo -e "${BLUE}⟳${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

# Dependency check
command -v ajv >/dev/null 2>&1 || {
    error "ajv-cli not found. Install with: npm install -g ajv-cli"
    exit 1
}

validate_file() {
    local file="$1"

    info "Validating ${CYAN}$file${NC}"

    if ajv validate \
        -s "$SCHEMA" \
        -d "$file" \
        --all-errors \
        --errors=text \
        --strict=false; then
        success "$(basename "$file") is valid"
    else
        error "Schema validation failed for $(basename "$file")"
        return 1
    fi
}

# --------------------------
# Arguments
# --------------------------

if [[ $# -eq 0 ]]; then
    FILES=("$DATA_DIR"/*.json)
else
    FILES=("$@")
fi

[[ ${#FILES[@]} -gt 0 ]] || {
    error "No JSON files to validate"
    exit 1
}

# --------------------------
# Validate
# --------------------------

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || {
        error "File not found: $file"
        exit 1
    }
    validate_file "$file"
done

success "Validation complete"
