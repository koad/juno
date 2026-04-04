# Product: Playback Machine — Session Recordings as Consulting Deliverable

**Status:** Concept — ready to spec  
**Owner:** Juno  
**Build:** Vulcan (extends koad/vulcan#9)  
**Date:** 2026-04-04

---

## The Insight

When koad gestates an entity team for a client, the client doesn't just receive the entities. They receive **the method**.

Context bubbles capture the sessions: how koad prompted Alice into existence, how he structured Vulcan's build spec, what he tried first, what he changed and why. That session record is intellectual property — it shows how a sovereign entity team is *worded into existence*.

The playback machine renders it. The client watches. They learn to do it themselves.

**This is the product:**
- Deliverable: sovereign entity team (their disk, their keys)
- Bonus deliverable: private context bubble library of the entire gestation
- Ongoing value: the client can study the method, apply it to their own future work

---

## Two Business Models

### 1. koad's consulting product (koad.sh premium tier)

**"I gestate your entity team. You get the team and the recordings."**

koad takes a client engagement. Over N sessions, he gestates their entity team: names their entities, writes their CLAUDE.md files, designs their trust bond structure, connects their daemon.

Every session is captured as a private context bubble. At the end:
- Client has their sovereign entity team on their own hardware
- Client has a private bubble library: how koad thought through their specific problem
- Client can replay any decision. "Why did you name the orchestrator Juno and not Athena?" — there's a bubble for that.

This is not just consulting. It's consulting + training material + methodology IP. The client can use it to onboard their team, train future builders, and eventually run sessions themselves.

**Pricing implication:** This is significantly more valuable than "custom entity development." The session recordings are a perpetual asset. Price accordingly.

### 2. Platform model — other prompt engineers sell their method

**Open source means anyone can run this.**

A prompt engineer who has developed their own methodology for building AI agent teams can:
1. Run the koad:io playback machine on their own infrastructure
2. Gestate teams for their clients using their own method
3. Sell private access to their session recordings
4. Keep 100% of the revenue — koad:io is the infrastructure, not the intermediary

The koad:io ecosystem becomes the platform prompt engineers use to deliver and monetize their own consulting work. The playback machine is to prompt engineering what Stripe is to commerce — infrastructure that makes selling possible, not a cut-taker.

**What koad:io provides:**
- Context bubble format (open spec — VESTA-SPEC-016)
- Playback machine renderer (open source)
- Entity directory structure (open source)
- Distribution via their own sovereign infrastructure (no platform fee)

**What the prompt engineer provides:**
- Their method
- Their sessions
- Their client relationships

---

## What This Requires

### Playback Machine (Vulcan — already in queue)
The existing koad/vulcan#9 issue covers the playback machine. Add a requirement:

**Private bubble support:** The renderer must support loading a bubble library from a local directory or private repo — not just public GitHub files. A client's session recordings are private. They should be loadable by the client without being publicly accessible.

Implementation: `playback-machine load --source local --path ~/.{entity}/bubbles/private/`

### Private Bubble Path
Add a `private/` subdirectory convention to the bubble spec:
- `~/.{entity}/bubbles/` — public bubbles (shared, published)
- `~/.{entity}/bubbles/private/` — private bubbles (client deliverables, internal sessions)

Private bubbles follow the same format but `is_shared: false` and are never pushed to public repos.

### Client Delivery Package
When koad completes a gestation engagement, the deliverable is a package:
```
client-delivery/
  entities/           ← the gestated entity directories (portable)
  bubbles/            ← the session recording library (private)
  README.md           ← "how to use what you just received"
  playback-machine/   ← standalone renderer they can run locally
```

---

## Connection to The Insiders

The Insiders (Level 4: $1,000/mo) already includes raw session feeds. That's the public version of this — Insiders get to watch Juno's sessions live.

The consulting version is the private, personalized version: **your** sessions, **your** team, **your** method captured.

These are complementary:
- Insiders Level 4: watch how Juno operates (public, ongoing)
- Consulting + recordings: watch how YOUR team was built (private, one-time)

---

## Prompt Engineering Platform Angle

koad:io is open source. Any prompt engineer who develops a methodology can:

1. Fork koad:io
2. Customize entity templates to their style
3. Gestate teams for clients using their method
4. Package session recordings as deliverables using the playback machine
5. Host their own "Insiders" equivalent for their audience

The network effect: every prompt engineer who builds on koad:io infrastructure validates the spec. Context bubbles from different methodologists can reference each other. A client who worked with one koad:io-based consultant can bring their bubble library to a session with another.

**This is the franchise model without franchise fees.** koad:io is the method + infrastructure. Other practitioners use it freely. The ecosystem grows. koad's early-mover and authorship of the standard is the moat.

---

## Next Steps

1. **File koad/vulcan issue** — add private bubble support + client delivery package to playback machine spec
2. **Add to BUSINESS_MODEL.md** — new consulting tier: team gestation + session recordings
3. **Update koad.sh description** — reflect this as the premium offering
4. **Faber** — Truth pillar content should include this: "how koad words things into existence" is a teachable method, context bubbles are the proof

---

*This is the highest-value product in the ecosystem. It converts koad's time into a scalable asset.*  
*The recordings outlive the engagement. The client keeps learning after koad leaves.*
