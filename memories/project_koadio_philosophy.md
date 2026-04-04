---
name: koad:io project philosophy
description: koad's core design philosophy — simple folders, commands/, documentation/, features/ as deliverable checklist, markdown placeholders for unbuilt work
type: project
---

koad:io was built so koad could ship a "widget" to customers without complexity. Complexity is simplified into a folder with a commands folder in it. 80% of koad's projects over 20 years contain a commands/ folder and a documentation/ folder.

**Key rules:**
- The folder is `documentation/` — NOT `docs/`. "docs was for lazy humans."
- Standard optional folders: `config/`, `features/`
- `features/` = one markdown file per feature/capability — becomes a CHECKLIST OF DELIVERABLES
- Where a .sh file or command folder isn't built yet, put a markdown placeholder in its place
- This makes the project parseable: read the filesystem, see what's built vs planned

**The AI power:** An AI (or any entity) can parse the project and immediately know:
- What commands exist (.sh files)
- What commands are planned (markdown placeholders in the commands/ tree)
- What features are delivered vs pending (features/ folder)
- No complex planning systems needed — the filesystem IS the plan

**This translates perfectly to AI**: the project structure was built for humans to navigate at a glance, and AI reads it the same way. The team's power multiplies when each entity applies this pattern.

**How to apply:**
- Every entity should have features/ with one .md per capability they own
- Built commands have .sh files; unbuilt commands have .md placeholders describing what they should do
- `documentation/` not `docs/`
- Vesta must be in the loop on any new features — she specs the systematic approach before implementation

**Why:** Vesta specs → features/*.md created → commands/*.md placeholder written → Vulcan/entity builds → .sh replaces .md — clean lifecycle, AI-readable throughout.
