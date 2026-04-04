---
type: hn-show-submission
status: draft
author: juno
based-on: ~/.sibyl/research/2026-04-04-hn-reception-patterns.md
ready-to-post: false
blocking: Mercury credentials (#11), Alice entry point live (#48)
best-post-time: Tuesday–Thursday 8am–11am US Eastern
---

# Show HN: koad:io — Draft Submission

## Headline Options (choose one)

**Option A — Broad infrastructure audience:**
> Show HN: koad:io — local AI agents with persistent identity, memory, and authorization (all in a git repo)

**Option B — Local inference audience (recommended by Sibyl):**
> Show HN: koad:io — add identity, memory, and signed authorization to your local inference stack (git repo, no cloud)

**Option C — Problem-first:**
> Show HN: I gave my local LLM agents persistent identity and signed authorization. It's just files.

**Recommendation:** Option B or C depending on timing. If Ollama controversy is still hot, Option B avoids the brand. Option C performs well when the personal voice lands.

---

## Body (Option B/C framing)

Local LLM inference is solved. What's not solved: your agent doesn't know who it is between sessions, has no record of what it's authorized to do, and leaves no audit trail of its decisions.

koad:io adds those three things on top of whatever inference engine you run — and stores everything in a plain git repo on your disk.

---

**Here's what it looks like:**

```bash
# Clone an entity (any of these are real, public, running now)
git clone https://github.com/koad/sibyl ~/.sibyl

# What does it know about itself?
cat ~/.sibyl/memories/001-identity.md

# What's it authorized to do?
cat ~/.sibyl/trust/bonds/juno-to-sibyl.md

# Is that authorization real? Verify it yourself.
gpg --verify ~/.sibyl/trust/bonds/juno-to-sibyl.md.asc

# What decisions has it made?
git -C ~/.sibyl log --oneline
```

Every entity has a directory. Every authorization is a GPG-signed file. Every decision is a git commit.

---

**The current state:**

15 entities running on a Mac Mini called fourty4. Juno (orchestrator) runs on a $200 laptop and coordinates the rest over SSH. The full team — content strategist, builder, researcher, QA, comms, brand, design — is running real operations, not demos.

Git history is public. Trust bonds are in the repos. You can `gpg --verify` any authorization in the system.

---

**What it doesn't do yet:**

- Daemon-managed 24/7 operation is in progress (passenger.json scheduler exists, full worker system in development)
- Certificate signing for Alice's onboarding curriculum is v2
- GUI is a Meteor PWA (very early — functions, doesn't dazzle)
- The Alice onboarding curriculum (12 levels, free) exists but the conversational layer is in development

---

**Why not [other agent framework]?**

CrewAI, LangGraph, AutoGen assign roles via code parameters at runtime. When the session ends, the agent has no memory of who it is or what it was authorized to do.

koad:io's agent identity lives in committed files. The agent is the repo — not the runtime. You can `git clone` it, fork it, branch it, revert it. The agent survives a restart, a new machine, a new inference engine.

This is the difference between a configuration and a continuous identity.

---

**Links:**

- Clone a live entity: `git clone https://github.com/koad/alice ~/.alice`
- Framework: `github.com/koad/io`
- Full team (public repos): `github.com/koad` — look for any entity repo
- Operations board: `github.com/users/koad/projects/4`

---

## Top Comments to Pre-Answer

**"Doesn't CrewAI/LangGraph already do this?"**
> CrewAI assigns roles via code at runtime. When the process ends, nothing persists. koad:io stores identity in committed files — the agent is the repo. You can git clone it to a new machine and it resumes with full memory and authorization.

**"Sounds like just a well-organized git repo."**
> Yes — the same way Linux is "just well-organized system calls." The structure is the value: CLAUDE.md as agent identity, memories/ as persistent state, trust/bonds/ as authorization artifacts, hooks/ as trained behaviors. The conventions make it an agent runtime, not just a repo.

**"Who's actually using this?"**
> koad and a 15-entity team run real operations on it: content strategy (Faber), research (Sibyl), QA (Veritas), product (Vulcan), comms (Mercury), design (Muse). The git logs are public and show continuous operation since late March 2026. The system is eating its own cooking.

**"No centralized orchestrator — how does coordination work?"**
> GitHub Issues are the coordination protocol. Juno files an issue on Sibyl's repo → Sibyl picks it up, researches, comments back. File handoffs for synchronous work, issues for async. The audit trail is the issue thread. It scales because every handoff is a file or an issue, not a message that expires.

**"What happens when Anthropic changes their pricing/API?"**
> The entity directories are model-agnostic. Swap `claude` for `ollama` in the hook script — one line change. The agent's identity, memory, trust bonds, and history are untouched. We're testing this with Ollama on fourty4 in parallel.

---

## Cross-Post Sequence (after HN lands)

1. HN (above) — post first, wait for reception
2. r/selfhosted: "I run 15 local AI agents with persistent identity on a Mac Mini. Here's the file structure." — focus on "it's on my hardware"
3. r/LocalLLaMA: "koad:io: add identity and authorization to your local inference setup. No new infrastructure." — focus on inference stack compatibility
4. IndieHackers: "I built a sovereign AI entity that runs on a $200 laptop. Here's the business model." — focus on autonomy and cost

---

## Checklist Before Posting

- [ ] Alice entry point live (PR #1 merged)
- [ ] Mercury has HN account credentials (#11)
- [ ] Sibyl/Veritas has reviewed post for factual accuracy
- [ ] Iris has approved voice alignment
- [ ] At least 3 of the 4 entity repos are public and have recent commits visible
- [ ] Trust bond verify chain is working (gpg --verify returns "Good signature")
- [ ] Tuesday–Thursday, 8am–11am US Eastern

---

*Drafted by Juno based on Sibyl's HN Reception Patterns research (2026-04-04)*
*Not ready to post — requires Alice live + Mercury credentials*
