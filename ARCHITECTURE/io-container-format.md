# .io Container Format — Sovereign Identity Capsule

## Concept

The `.io` file is a portable sovereign identity capsule. One file contains everything that defines an entity or human identity. Like a game cartridge: plug it in, get the full persona.

Canonical address: `kingofalldata.com/juno.io`

## Container structure

```
juno.io
├── manifest.json         ← index, format version, content hashes, signatures
├── model.glb             ← canonical 3D avatar (glTF binary, WebXR-ready)
├── avatar.png            ← 2D render from canonical model
├── profile.json          ← structured identity
├── keys.gpg              ← public keys
├── sigchain.json         ← full signature chain (provenance)
├── agent/                ← shared agent files (CLAUDE.md, memories/, PRIMER.md)
└── bubbles/              ← named sub-bubbles (nestable context)
    ├── work.bubble
    └── public.bubble
```

## Namespace convention (full stack)

```
kingofalldata.com/koad          ← profile page (human shares this)
kingofalldata.com/koad.png      ← avatar (2D render from canonical model)
kingofalldata.com/koad.json     ← structured profile
kingofalldata.com/koad.gpg      ← public keys
kingofalldata.com/koad.atom     ← unified social feed
kingofalldata.com/koad.io       ← full identity capsule (everything)
```

## Avatar pipeline

```
source photo (any resolution)
  → AI upscale (Real-ESRGAN / GFPGAN)
  → image-to-3D (InstantMesh / TripoSR / Zero123++)
  → glTF/GLB or VRM (browser-native, VR-importable)
  → canonical 2D renders (consistent character, locked camera angles)
  → avatar.png (packaged into .io)
```

glTF/GLB is the base format — browser-native, WebXR-ready, imports in Unity/Unreal/VR.
VRM builds on glTF for humanoid avatars specifically.

## Bubbles

Bubbles are named context containers. They can be nested:

```
koad.io
└── bubbles/
    ├── work.bubble         ← work context
    │   └── bubbles/
    │       └── koadio.bubble   ← koad:io project context
    └── public.bubble       ← public-facing context
```

Any entity or harness can load a named bubble as pre-invocation context.
The bubble name is the address. Nested bubbles are dot-addressed: `work.koadio`.

## Public vs private

- **Public** `.io` at `kingofalldata.com/{namespace}.io` — identity, model, keys, public bubbles
- **Private** `.io` distributed via encrypted sync or private git — adds private agent context, private memories
- Same format. Scoped sections. The private file extends the public one.

## Multi-device propagation

Pull your `.io` onto a new device → fully reconstituted. No vendor sync. No cloud dependency. The file IS the migration path.

## For humans

Same format. `kingofalldata.com/koad.io` contains koad's 3D avatar, profile, keys, and public context. A human makes their model via photo → 3D pipeline (same tooling). The `.io` is the same container regardless of whether the persona is human or entity.

## Related issues

- sibyl#17 — image-to-3D pipeline research
- vulcan#64 — build spec
- vulcan#53 — namespace routing
