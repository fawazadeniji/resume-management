# Typst Resume Engine

## **Core Philosophy: The Intent**

The system is built on the principle of separating two distinct concerns:

- **Content**: Managed in `data/*.json` files using the [JSON Resume](https://jsonresume.org/) schema standard. This serves as the "Source of Truth" where you focus solely on professional details and skills, in a portable, standardized format. You can maintain multiple resume variants (e.g., `resume.json`, `resume-frontend.json`, `resume-backend.json`) for different job targets.

- **Presentation**: Managed in `templates/*.typ`. This acts as the "Design Engine," using Typst’s scripting to define typography, layout, and styling.

---

## **Repository Structure**

| Folder           | Intent                                                                                                                                                        |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`data/`**      | Contains JSON Resume files (e.g., `resume.json`, `resume-frontend.json`). Each file follows the [JSON Resume schema](https://jsonresume.org/schema) standard. |
| **`templates/`** | Contains `.typ` files that import JSON data to render the layout.                                                                                             |
| **`scripts/`**   | Automation scripts for compilation, cleanup, and exports.                                                                                                     |
| **`output/`**    | Contains the generated PDF artifacts; this folder is ignored by Git.                                                                                          |

---

## **Setup & Installation**

### **1. Install Typst**

Typst is a fast typesetting engine written in Rust.

- **macOS**: `brew install typst`

- **Windows**: `scoop install typst`

- **Linux**: Download from Typst Releases or use a package manager.

### **2. Fonts**

The default template requires the **Noto Sans** font family. Typst will automatically detect these once installed on your system.

---

## **Workflow**

1. **Update Data**: Edit or create a JSON Resume file in `data/` (e.g., `resume.json`, `resume-frontend.json`).

2. **Build**: Execute `./scripts/build.sh` from the root directory to generate the PDF.

   ```bash
   # Build default (resume.json)
   ./scripts/build.sh

   # Build a specific variant
   ./scripts/build.sh resume-frontend.json
   ```

3. **Real-time Preview**: Use the `typst watch` command with the `--input` flag to see changes instantly as you edit.

   ```bash
   # Watch default (resume.json)
   typst watch templates/cv_engine.typ output/resume.pdf

   # Watch a specific variant
   typst watch --input data=resume-frontend.json templates/cv_engine.typ output/resume-frontend.pdf
   ```

---

## **Engineering Benefits**

- **Version Control**: Track the evolution of bullet points using `git diff`.

- **Consistency**: Use global variables to ensure uniform spacing and colors across the document.

- **Portability**: The structured JSON data can be reused for personal websites or other machine-readable formats.
