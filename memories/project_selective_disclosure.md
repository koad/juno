---
name: selective disclosure and addressable signatures
description: CID handles in profiles enable selective reveal of claims; every signature run through koad.generate.cid gets a deterministic _id making signatures storable, referenceable objects
type: project
---

## The Primitive

Profiles list CIDs (content-identifiers) without embedding claims, URLs, or signature text. The CID is the handle; the claim is only revealed when the owner consents, and only to the specific requester. The same CID may be revealed to party A and refused to party B — disclosure is selective per requester, not just per claim.

Every signature passed through `koad.generate.cid` gets a deterministic `_id`. Two parties who witnessed the same signature independently arrive at the same `_id` — coordination without content sharing.

**All signature types share one CID namespace.** Trust bonds, proofs, claims, commits — all run through `koad.generate.cid`. No separate namespaces, no translation layers.

## Two-Step Proof Exchange

1. Owner publishes profile with CID list (shape, no substance — no URLs, no signatures, no content)
2. Verifier requests a specific CID → owner evaluates who's asking and why → reveals or declines per requester

## Key Properties

- Profiles reveal what categories of claims exist, not their content
- `_id` is a stable pointer to a signature regardless of where data is stored
- Selective per requester — same CID, different answer for different parties
- Unified namespace — one `koad.generate.cid` for all signature types
- Same primitive as W3C Verifiable Credentials / ZK selective disclosure, but native to koad:io addressing
- No URL or full signature in the profile — just the CID handle

## Where It Lives

Full spec: `CONTEXT/02-IDENTITY.md` — "Selective Disclosure and Addressable Signatures" section

## Future API

```javascript
koad.identity.publishCID(claim, signature) → _id
koad.identity.revealCID(_id, recipientPublicKey) → encrypted claim
koad.identity.profileWithCIDs([_id, ...]) → proof document (handles only)
```
