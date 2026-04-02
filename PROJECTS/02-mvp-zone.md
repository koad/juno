# Project: MVP Zone

## Status: PLANNING — Platform Decided

**Waiting for:** First sponsor (GitHub Sponsors live)

## Vision

A community space where GitHub Sponsors get direct access to Juno, other builders, and the operation in progress. Not a support forum — a room where the right people find each other.

## Platform Decision: Discord

**Recommendation: Discord. Reasoning:**

| Platform | Decision |
|----------|----------|
| **Discord** | ✅ **Selected** — see reasoning below |
| GitHub Discussions | ❌ — Not real-time enough. Sponsors want live access, not a forum. |
| Matrix/Element | ❌ — Correct on principle, wrong on adoption. Nobody our audience knows is there. |
| Custom (koad:io) | ❌ — Right eventually, wrong now. Build audience first, migrate later. |

**Why Discord:**
- Every developer and indie hacker already has an account
- Rich enough for real-time community (channels, roles, threads, voice)
- OpenClaw has a Discord skill — Mercury can post, Juno can be present
- GitHub Sponsors verification bots exist (Stripe + Discord role grant)
- Low friction = higher conversion from sponsor to active member
- When koad:io has enough pull, we migrate to a sovereign alternative

**Sovereignty caveat:** Discord is a SaaS cage. We know this. We accept this tradeoff at this stage — audience-building at zero marginal cost beats principled isolation with no members. The operation moves to self-hosted when it earns that complexity.

## Structure

```
MVP Zone (Discord Server)
├── #welcome          — orientation, what this is, what you get
├── #announcements    — Juno posts here on every milestone (Mercury)
├── #general          — open to all sponsors
├── #builds           — what Vulcan is building (commit feed via Janus)
├── #entities         — entity releases, clone instructions, adoption help
├── #ask-juno         — $5+ tier: direct access to Juno
└── #request-queue    — $10+ tier: feature requests and priority builds
```

## Access Logic

```
User sponsors on GitHub
    ↓
Sponsors webhook → Discord bot
    ↓
Bot assigns role by tier
    ↓
Channels unlock automatically
    ↓
Welcome DM from Mercury
```

## Tiers

| Tier | Price | Access |
|------|-------|--------|
| Supporter | $1/mo | #welcome, #general, #builds, #entities |
| Builder | $5/mo | All above + #ask-juno (direct Juno access) |
| Patron | $10/mo | All above + #request-queue + priority build queue |

## Deliverables

- [x] Platform decided: Discord
- [ ] Discord server created (koad action — needs Discord account)
- [ ] Roles set up: Supporter, Builder, Patron
- [ ] GitHub Sponsors webhook → Discord role bot configured
- [ ] Channel structure created (matches above)
- [ ] Welcome message written (Juno writes, Mercury posts)
- [ ] Server rules drafted
- [ ] Juno presence configured (Mercury manages the bot layer)
- [ ] First invite link ready to send on sponsor #1

## What Juno Needs from koad

- Discord account / server creation (koad action)
- GitHub Sponsors webhook enabled (koad action in GitHub settings)
- Discord bot token for Mercury to use via OpenClaw

## Content on Day One

When the first sponsor arrives, they should find:
- A populated server (not empty)
- A pinned welcome that explains what they've joined
- A #builds channel showing real Vulcan work in progress
- Mercury present and responsive

Juno will pre-populate these channels before the first invite goes out.

## Timeline Trigger

MVP Zone goes live when: first GitHub Sponsor + Discord server created.
That's the only blocker. Everything else is ready to draft now.
