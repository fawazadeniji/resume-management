# Typst Resume Engine

## **Core Philosophy: The Intent**

The system is built on the principle of separating two distinct concerns:

- **Content**: Managed in `data/*.json` files using the [JSON Resume](https://jsonresume.org/) schema standard. This serves as the "Source of Truth" where you focus solely on professional details and skills, in a portable, standardized format. You can maintain multiple resume variants (e.g., `resume.json`, `resume-frontend.json`, `resume-backend.json`) for different job targets.

- **Presentation**: Managed in `templates/*.typ`. This acts as the "Design Engine," using Typst’s scripting to define typography, layout, and styling.

---

## **Repository Structure**

| Folder            | Intent                                                                                                                                                        |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`data/`**       | Contains JSON Resume files (e.g., `resume.json`, `resume-frontend.json`). Each file follows the [JSON Resume schema](https://jsonresume.org/schema) standard. |
| **`templates/`**  | Contains `.typ` files that import JSON data to render the layout.                                                                                             |
| **`scripts/`**    | Automation scripts for compilation, validation, and exports.                                                                                                  |
| **`output/`**     | Contains the generated PDF artifacts (versioned as `*_v1.pdf`, `*_v2.pdf`, etc.); this folder is ignored by Git.                                              |
| **`schema.json`** | JSON Resume schema file used for validating data files.                                                                                                       |

---

## **Setup & Installation**

### **1. Install Typst**

Typst is a fast typesetting engine written in Rust.

- **macOS**: `brew install typst`

- **Windows**: `scoop install typst`

- **Linux**: Download from Typst Releases or use a package manager.

### **2. Fonts**

The default template requires the **Noto Sans** font family. Typst will automatically detect these once installed on your system.

### **3. Validation (Optional)**

To enable JSON schema validation, install `ajv-cli`:

```bash
npm install -g ajv-cli
```

---

## **Workflow**

1. **Update Data**: Edit or create a JSON Resume file in `data/` (e.g., `resume.json`, `resume-frontend.json`).

2. **Validate (Optional)**: Run `./scripts/validate.sh` to validate your JSON files against the schema.

   ```bash
   # Validate all JSON files
   ./scripts/validate.sh

   # Validate specific file(s)
   ./scripts/validate.sh data/resume.json
   ```

3. **Build**: Execute `./scripts/build.sh` from the root directory to generate the PDF. The script automatically validates data before building.

   ```bash
   # Build default (resume.json)
   ./scripts/build.sh

   # Build a specific variant
   ./scripts/build.sh resume-frontend.json

   # Build all data files
   ./scripts/build.sh -a

   # Build with a specific template
   ./scripts/build.sh -t cv_engine.typ resume.json

   # Dry run (preview commands without executing)
   ./scripts/build.sh -n

   # Skip validation
   ./scripts/build.sh -v resume.json
   ```

4. **Real-time Preview**: Use the `typst watch` command with the `--input` flag to see changes instantly as you edit.

   ```bash
   # Watch default (resume.json)
   typst watch --input data=resume.json templates/cv_engine.typ output/resume.pdf

   # Watch a specific variant
   typst watch --input data=resume-frontend.json templates/cv_engine.typ output/resume-frontend.pdf
   ```

---

## **Build Script Options**

| Option       | Description                                      |
| ------------ | ------------------------------------------------ |
| `-a`         | Build all JSON files in `data/`                  |
| `-t <file>`  | Specify template file (default: `cv_engine.typ`) |
| `-n`         | Dry run (print commands without executing)       |
| `-v`         | Skip schema validation                           |
| `-h, --help` | Show help menu                                   |

Output files are automatically versioned (e.g., `resume_v1.pdf`, `resume_v2.pdf`) to avoid overwriting previous builds.

---

## **Engineering Benefits**

- **Version Control**: Track the evolution of bullet points using `git diff`.

- **Schema Validation**: Automatic validation against JSON Resume schema ensures data integrity before compilation.

- **Consistency**: Use global variables to ensure uniform spacing and colors across the document.

- **Portability**: The structured JSON data can be reused for personal websites or other machine-readable formats.

- **Versioned Output**: Build artifacts are automatically versioned to preserve previous iterations.
