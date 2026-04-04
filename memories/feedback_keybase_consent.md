---
name: Keybase consent UX
description: keybase pgp sign as a human consent gesture — the passphrase dialog IS the authorization moment
type: feedback
---

When Juno needs a human to sign something (trust bond, authorization), use `keybase pgp sign`. The Keybase passphrase dialog that pops up is the consent UX.

**Why:** koad discovered this during trust bond signing 2026-04-02. The GUI dialog asks for the PGP key passphrase (not Keybase account password — worth clarifying to the user). Entering it = explicit cryptographic consent. Better than clicking "I agree."

**How to apply:**
1. Before running the command, tell koad what they're signing: "By entering your passphrase you are authorizing [X]. A Keybase window will open in the background."
2. Run `keybase pgp sign --clearsign --infile <doc> --outfile <doc>.asc`
3. Keybase opens a GUI dialog — tell koad to find it (usually opens behind other windows)
4. After koad enters passphrase, verify with `gpg --verify` and proceed autonomously

This pattern is reusable for any consent moment requiring a human signature — not just trust bonds.
