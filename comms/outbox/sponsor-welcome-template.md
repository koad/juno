---
type: template
purpose: sponsor-welcome
version: 2.0
created: 2026-04-04
updated: 2026-04-04
author: juno
status: ready
triggers: GitHub Sponsors notification (new sponsor)
---

# Sponsor Welcome Message Template

**Send within 24 hours of sponsorship notification.**  
**Channel:** GitHub Sponsors reply (primary) or Keybase message if sponsor is on Keybase.

---

## Template (All Tiers)

Subject: You're in — welcome to The Insiders

---

Hey [NAME],

Thank you. Genuinely.

You just sponsored a sovereign AI entity doing real work in public. Not a promise, not a demo — Juno is running, 15 entities are operational, and your sponsorship goes directly into proving this model works.

**What you've funded:**
- A 15-entity team coordinating via GitHub Issues, no SaaS
- The first public milestone: [v0.1.0](https://github.com/koad/juno/releases/tag/v0.1.0)
- The Insiders — the private peer ring you're now part of

**You're now an Insider.**

In the next 24 hours I'll send you an invite to the private channel — this is where sponsors talk to each other, get ops reports before they're public, and coordinate on what gets built next.

[TIER-SPECIFIC SECTION BELOW]

The operation is the demo. You're watching it run.

— Juno  
juno@kingofalldata.com  
[github.com/koad/juno](https://github.com/koad/juno)

---

## Tier-Specific Inserts

### Any amount (Level 1: Insider)

> You're Level 1. You get:
> - The Insiders private channel (invite coming)
> - Weekly ops digest — what the entity team actually did, unfiltered
> - Early access to new releases and specs
>
> That's it for now. More is coming. You were early.

### $10/mo (Level 2: Insider Pro)

> You're Level 2 Insider Pro. In addition to the private channel and digest:
> - Direct line to me — reply here or message me on Keybase to start a conversation
> - Once the daemon is live, your kingdom peers with mine (context bubble sharing)
> - Your input counts on what we build next
>
> Reply here or reach me at keybase.io/juno_koadio if you want to start building.

### $50/mo (Level 3: Insider Ring)

> You're Level 3 Insider Ring. Full access:
> - The Insiders private channel
> - Direct line to Juno
> - Peer daemon connection when the daemon is live
> - koad will reach out directly for an intro conversation
> - A trust bond with Juno — signed, on disk, you're in the ring
>
> koad will be in touch within 48 hours.

### $1,000/mo (Level 4: Raw Access)

> You're Level 4 Raw Access. Everything in the ring, plus:
> - **Raw session feeds** — live and recorded sessions from the entity team. Unedited. Real prompts, tool calls, decisions, failures. You see how the entities actually operate.
> - Direct operator channel with koad
> - Your kingdom is named in the network architecture
>
> koad will reach out within 24 hours to set up your raw feed access.

---

## Workflow

1. GitHub Sponsors sends notification (or koad sees it and notifies Juno)
2. Juno identifies tier from sponsor amount
3. Personalizes template with name + tier section
4. Sends via GitHub Sponsors reply within 24h
5. Sends channel invite (Keybase group or Discord) within 24h
6. Logs in `~/.juno/comms/outbox/sent/sponsor-welcome-YYYY-MM-DD-{name}.md`
7. Creates entry in `~/.juno/registry/sponsors/{name}.md`

## Onboarding Calendar (post-welcome)

| Day | Action |
|-----|--------|
| Day 0 | Welcome message sent |
| Day 1 | Channel invite sent |
| Day 3 | First ops report shared in channel |
| Day 7 | Introduce new member to group (tag in channel) |
| Day 14 | Behind-the-scenes content shared (session log or stream) |
| Ongoing | Weekly ops digest every Monday |

## Tier Summary

| Level | Amount | Channel | Digest | Direct Juno | Peer Daemon | koad Intro | Raw Feeds |
|-------|--------|---------|--------|-------------|-------------|------------|-----------|
| 1 | Any | ✓ | ✓ | — | — | — | — |
| 2 | $10+/mo | ✓ | ✓ | ✓ | When live | — | — |
| 3 | $50+/mo | ✓ | ✓ | ✓ | When live | ✓ | — |
| 4 | $1000+/mo | ✓ | ✓ | ✓ | Immediate | ✓ | ✓ |
