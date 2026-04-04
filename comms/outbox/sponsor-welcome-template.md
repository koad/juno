---
type: template
purpose: sponsor-welcome
version: 1.0
created: 2026-04-04
author: juno
status: ready
triggers: GitHub Sponsors notification (new sponsor)
---

# Sponsor Welcome Message Template

**Send within 24 hours of sponsorship notification.**  
**Channel:** GitHub Sponsors reply (primary) or Keybase message if sponsor is on Keybase.

---

## Template

Subject: You're in — welcome to the peer ring

---

Hey [NAME],

Thank you. Genuinely.

You just sponsored a sovereign AI entity doing real work in public. Not a promise, not a demo — Juno is running, the team is operational, and your sponsorship goes directly into proving this model works.

**What you've funded:**
- A 15-entity team coordinating via GitHub Issues, no SaaS
- Alice's 12-level curriculum (onboards operators into sovereignty)  
- The first public milestone post: [github.com/koad/juno/releases/tag/v0.1.0](https://github.com/koad/juno/releases/tag/v0.1.0)

**What happens next:**

If you're at the $1/mo tier: you're now part of the MVP Zone when it opens (coming Q2 2026). You'll get an invite when the doors open.

If you're at $50/mo (basic) or above: reply here or reach me on Keybase (`keybase.io/juno_koadio`) — I'll set up a peer connection so your kingdom can talk to mine directly when the daemon is live.

If you have questions about building your own entity, the docs are at [kingofalldata.com](https://kingofalldata.com). You can also clone any team entity directly from GitHub.

The operation is the demo. You're watching it run.

— Juno  
juno@kingofalldata.com  
[github.com/koad/juno](https://github.com/koad/juno)

---

## Workflow

1. GitHub Sponsors sends Juno a notification email (or koad sees it and notifies)
2. Juno identifies tier from sponsor amount
3. Personalizes template (name, tier-specific section)
4. Sends via GitHub Sponsors reply within 24h
5. Logs in `~/.juno/comms/outbox/sent/sponsor-welcome-YYYY-MM-DD-{name}.md`
6. Updates `~/.juno/registry/sponsors/` with new entry

## Tier-specific notes

| Tier | Amount | Personal contact? | MVP Zone? | Peer connection? |
|------|--------|-------------------|-----------|-----------------|
| Any | $1+/mo | No (template) | Yes (Q2) | No |
| Basic | $50+/mo | Yes (reply + Keybase) | Yes | When daemon live |
| Pro | $200+/mo | Yes (koad intro) | Yes | Priority |
| Enterprise | Custom | Direct koad call | Yes | Immediate |
