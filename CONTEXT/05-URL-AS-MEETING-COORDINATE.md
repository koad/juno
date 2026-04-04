# URL as Meeting Coordinate

How URLs and CIDs work together as identity anchors in the koad:io ring system — and how proof is embedded in public bio fields without leaking claim content.

---

## The Core Pattern

A URL is not an identity. A URL is a **meeting coordinate** — a place where two parties agree to look for each other.

```
URL = "come find me here"
CID = "this is what we're looking at"
```

These are complementary primitives. A URL is mutable and location-dependent. A CID is permanent and content-derived. Neither alone is sufficient. Together they form a complete addressing scheme for sovereign identity:

- The URL tells you where to go
- The CID tells you what you should find there — and whether it's been tampered with

---

## URL Mutability vs. CID Permanence

| Property | URL | CID |
|----------|-----|-----|
| Derived from | Location choice | Content hash |
| Changes when you move servers | Yes | No |
| Proves content integrity | No | Yes |
| Human-readable | Usually | No |
| Can be published before content | Yes | No |
| Stable over time | No guarantee | Guaranteed |

A URL is where you chose to host something **today**. The CID is the cryptographic commitment to what that thing **is**. If someone changes a file and keeps the same URL, the CID will catch it — the content no longer matches. If someone moves a file to a new host, the CID remains the same — content is unchanged.

---

## Proof-in-Bio

Posting a CID in a public bio field is a **commitment before context**. You sign something, hash that signature into a CID, and publish the CID in your bio. This is the bio beacon pattern.

### Why the bio is the right place

The bio is:
- Public and persistent (bio changes are audited on most platforms)
- Seen by anyone viewing the profile — ring members and strangers alike
- Pre-dates any context you add later (publishing sequence is verifiable)

When a ring member's passenger encounters the CID, it uses it as a lookup key against the ring's shared state. Everyone else sees a meaningless string.

### What the CID commits to

The CID in the bio is derived from the **signature content** — not from the claim the signature asserts, and not from the URL where the signature is hosted.

This means:

1. **You cannot swap the signature and keep the same CID.** The CID is a content-derived identifier. If you change the signature file, the hash changes, the CID changes, and the bio no longer matches. The prior commitment is still in your bio's edit history.
2. **The CID proves prior possession.** Publishing a CID in your bio, before publishing any URL, proves that you possessed that exact signature at the time of the bio update. The bio timestamp is the anchor.
3. **The URL is separate and optional.** You can add a URL later, remove it, or never add one at all — the CID's commitment survives regardless.

```
Timeline:
  T1: koad signs claim → generates CID from signature
  T2: koad posts CID in bio (commitment, no URL yet)
  T3: koad optionally posts URL to signature file
  T4: koad moves signature to new host, updates URL
  T5: CID in bio still resolves correctly — content unchanged
```

At T3 and beyond: the URL is context. At T1: the commitment was made.

---

## Disclosure Spectrum: Dark Mode vs. Semi-Open Mode

koad:io bio beacons support a spectrum of disclosure — from fully dark to semi-open. The CID is always the same. The difference is whether you accompany it with a URL.

### Mode 1 — Fully Dark

```
Bio: bafkreiXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**CID only. No URL. No explanation.**

- Ring members' passengers recognize the CID format and resolve it through ring state
- Everyone else sees noise — a meaningless string, not obviously a proof or claim
- Maximum privacy: nothing about the nature of the claim is revealed to outside observers
- No URL means no public path to the signature content — resolution is ring-exclusive

This is appropriate for:
- Claims you want provable within the ring but invisible to outside observers
- High-sensitivity trust bonds (authorization grants, employment, private affiliations)
- Situations where the existence of the claim is itself sensitive

### Mode 2 — Semi-Open

```
Bio: bafkreiXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     myspace.com/koad/bio
```

Or equivalently, a profile field that lists both.

**CID + URL to the signature file.**

- Ring members use the CID as the lookup key (same as dark mode — URL is redundant for them)
- Anyone with the URL can independently fetch the signature and verify it against the CID
- The URL makes the proof independently auditable — no ring membership required
- koad's example: `myspace.com/koad/bio` hosts the actual signature file; anyone can fetch, hash, and compare against the CID

This is appropriate for:
- Claims you want to be publicly verifiable (domain ownership, public endorsements)
- Content where transparency is a feature, not a risk
- Proofs that benefit from human-readable verification pathways

### Key Properties of Both Modes

```
CID = permanent commitment (content-derived, host-independent)
URL = current location (mutable, optional, human-facing)

CID and URL are independent handles for the same truth.
Changing the URL doesn't change the CID.
Losing the URL doesn't invalidate the CID.
```

If the URL goes down:
- Semi-open mode degrades gracefully to dark mode behavior
- Ring members who have already resolved the CID retain the proof
- Passengers cache resolved content — ring state survives host failure
- The bio CID is still a valid commitment; the URL was context, not proof

---

## Passengers and CID Resolution

Passengers are the entities running inside the daemon. They see bio CIDs as lookup keys and resolve them against ring state — the shared, peer-synchronized record of claims and their content.

The passenger flow:

```
1. Encounter a bio with a CID
2. Check ring state: is this CID known?
3a. Known → load resolved claim, apply context
3b. Unknown → log for resolution, request from ring peers
4. If Mode 2: URL available as fallback for resolution outside ring
```

In dark mode, step 3b may never resolve unless the owner shares the claim through a selective disclosure exchange (see `02-IDENTITY.md` — Selective Disclosure and Addressable Signatures). The CID is in the ring's awareness but the content is not exposed.

---

## Hosting the Signature File (Semi-Open Mode)

The URL can point to any publicly reachable location. The choice of host is independent from the proof. Examples:

| Host | Notes |
|------|-------|
| Own server (`myspace.com/koad/bio`) | Maximum sovereignty; owner controls uptime and path |
| GitHub Gist or raw file | Free, persistent, well-known format; content hash verifiable |
| IPFS | URL can itself be a CID-based address — maximum durability |
| Keybase (`keybase.pub/koad/...`) | Keybase-signed hosting; adds a second layer of attribution |

Regardless of host, the CID in the bio is the root of trust — not the URL. You can migrate hosts freely. The CID is the commitment. The URL is the pointer.

---

## Relation to Selective Disclosure

This pattern is a surface layer over the selective disclosure primitive (`02-IDENTITY.md`). The disclosure spectrum here is about **bio visibility** — whether the URL is public — not about claim content visibility to specific requesters.

The full disclosure stack:

```
Layer 0 — Bio beacon (this spec)
  CID in bio: commits to signature existence, no content revealed
  URL in bio: optional pointer to signature file for public fetch

Layer 1 — Selective disclosure (02-IDENTITY.md)
  Who gets to see the claim content on request?
  Owner decides per requester — not just by whether URL is public

Layer 2 — Trust bond (06-TRUST-BONDS.md)
  What relationships authorize which disclosures?
  Ring membership determines resolution access
```

A fully dark bio beacon (Mode 1) + selective disclosure means: the claim exists, it's provable, it's resolvable within the ring — but only to requesters the owner approves.

A semi-open bio beacon (Mode 2) + selective disclosure means: anyone can fetch and verify the signature from the URL — but further context, linked claims, or derived claims may still require owner approval.

---

## Summary

| Concept | Role |
|---------|------|
| URL | Meeting coordinate — where to find the signature today |
| CID | Content commitment — what the signature is, permanently |
| Bio beacon | Publishing the CID (and optionally URL) as a public anchor |
| Dark mode | CID only — ring-exclusive resolution |
| Semi-open mode | CID + URL — independent public verification enabled |
| Passenger | Resolves CIDs against ring state automatically |
| Host migration | URL changes; CID does not; proof survives |

---

*Spec authored: 2026-04-04*
*Vesta — Platform-Keeper, koad:io Protocol*
