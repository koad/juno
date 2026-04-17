# trust-bond-viewer

Generates a static HTML trust bond registry for the koad:io Insiders dashboard (Architect tier).

## What it produces

- `dist/trust-bonds/index.html` — table + SVG authority graph of all bonds across entity repos
- `dist/trust-bonds/bonds/<label>.html` — per-bond detail page with full terms and GPG signature status

`dist/` is gitignored (build artifact). Run the command to regenerate.

## Usage

```bash
juno trust-bond-viewer
# or with overrides:
juno trust-bond-viewer --entities "juno vulcan alice" --out-dir /tmp/bonds
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `--entities` | all team entities | Comma- or space-separated list of entity names to scan |
| `--home-root` | `~` | Root dir containing `.<entity>/` homes |
| `--out-dir` | `~/.juno/dist/trust-bonds/` | Output directory |

## Data sources

Bonds are read from `<home-root>/.<entity>/trust/bonds/*.md` for each entity in the list.
Directories that don't exist are silently skipped. Duplicate bond labels (same bond copied
to multiple entity dirs) are deduplicated — juno's copy is canonical (first encountered).

## GPG signature verification

Each bond's `.md.asc` detached signature is verified via `gpg --verify`. Results:

- `VERIFIED` — signature is valid and the signing key is in the local keyring
- `UNVERIFIED` — signature present but key not in keyring, or file modified
- `NO_SIGNATURE` — no `.asc` file found

### Key-import remediation

If bonds appear as UNVERIFIED, import the signing key (Juno's GPG key):

```bash
gpg --keyserver keys.openpgp.org --search-keys juno@kingofalldata.com
# or if you have the public key file:
gpg --import juno-public.asc
```

Re-run the viewer after importing to refresh verification status.

## Tier gate

This command produces static HTML — it is ungated. Tier enforcement (Architect tier =
`session.tier >= 3`) is PWA-side work: the Meteor `insiders.js` server gates the endpoint
that serves this output to Architect-tier sponsors. The generator itself has no auth logic.

## Graph view

The index page includes an SVG authority graph: nodes are entities, edges are directed bonds
labeled by type (authorized-agent, authorized-builder, authorized-specialist, peer).
Layout: koad at top, Juno below, team entities in an arc at the bottom.
No JavaScript required — pure SVG.
