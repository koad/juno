---
title: NIST AI Agent Standards Initiative — Public Comment Draft
prepared-by: juno
date: 2026-04-02
for: koad to review and submit
status: draft
---

# NIST Public Comment Draft

**To:** NIST Center for AI Standards and Innovation (CAISI)
**Re:** AI Agent Standards Initiative — Agent Identity Concept Paper
**From:** Jason Zvaniga / koad:io

---

## Comment

We are developing koad:io, an open framework for sovereign AI agent identity. We believe our practical implementation experience is directly relevant to the Agent Identity Concept Paper.

**What we've built:**

koad:io gives each AI agent a cryptographic identity at gestation — Ed25519, ECDSA, RSA, and DSA keypairs stored on the operator's own hardware. Every agent action is committed to a git repository signed with that identity. Trust relationships are formalized as GPG-signed bond documents stored alongside the keys, establishing explicit, verifiable authorization chains rather than ambient platform permissions.

The architecture maps closely to NIST's target state:

| NIST Target | koad:io Implementation |
|-------------|----------------------|
| Agent-specific identity | Ed25519 keypair per agent, generated at gestation |
| Principle of least privilege | Trust bonds with explicit authorized/excluded action lists |
| Actor differentiation + audit logs | Git commit history with verified agent authorship |
| Dynamic, time-limited tokens | Annual bond renewal with explicit revocation protocol |

**Where we align with NIST's standards stack:**

We use GPG/OpenPGP for agent signing rather than OAuth, and SPIFFE-style entity IDs (`entity@domain`) rather than SPIFFE/SPIRE directly. The conceptual model is identical — each agent has a unique cryptographic identity that can be independently verified without relying on a central authority.

**Our key observation:**

The hardest problem in AI agent identity is not the cryptography — it's making sovereignty practical for individual operators. A framework that requires a cloud identity provider, a hosted key management system, or a central registry defeats the purpose. koad:io's design principle: if your agent's identity lives on your disk and you hold the keys, no vendor can revoke it, no platform failure kills it, and no acquisition changes the terms.

We would welcome the opportunity to contribute implementation experience to the standards process.

**Contact:** Jason Zvaniga — koad@koad.sh
**Framework:** github.com/koad/io (public)

---

*Prepared by Juno (koad:io AI business entity) for koad's review and submission.*
*Based on Sibyl's research: ~/.sibyl/research/2026-04-02-nist-implications.md*
