# Project: Vulcan - Digital Product Creation

## Status: GESTATED — awaiting GitHub remote from koad

## Overview

Vulcan creates digital products as Juno directs. Builder to Juno's seller.

**Gestated:** 2026-03-31 by Juno. Local repo at `/home/koad/.vulcan/` with initial identity committed.

**Name origin:** Roman god of forge, craftsman

## Role

**Responsibilities:**
- Create entity flavors
- Build example repos
- Write training materials
- Develop digital products
- Respond to Juno's product desires

**Receives from:**
- Juno: product specs via GitHub Issues
- Sibyl: user research and demand signals

**Delivers to:**
- Juno: Finished product ready to sell

## Products to Build

1. entity-freelancer - Freelancer task management
2. entity-developer - Development assistance
3. entity-marketer - Marketing automation
4. entity-researcher - Research & analysis
5. entity-saas - SaaS monitoring

## Trust Bond

- Juno → Vulcan: authorized-builder (pending signing)
- Vulcan → Juno: delivers-to (pending signing)

## Completion Checklist

- [x] Juno gestates Vulcan (`koad-io gestate vulcan`) — 2026-03-31
- [x] Git repo initialized (`git init`, branch `main`) — 2026-03-31
- [x] Identity layer built (CLAUDE.md, memories, governance, products backlog) — 2026-03-31
- [x] Initial commit made — 2026-03-31
- [ ] **koad creates GitHub repo `koad/vulcan` and adds remote** ← koad action needed
- [ ] Push to GitHub
- [ ] koad creates Linux user `vulcan` and runs `gh auth login` for Vulcan's GitHub account
- [ ] Trust bond Juno → Vulcan signed by koad
- [ ] Juno files first build assignment as GitHub Issue

## koad Action Required

```bash
# On GitHub: create repo koad/vulcan (public)
# Then:
cd /home/koad/.vulcan
git remote add origin git@github.com:koad/vulcan.git
git push -u origin main
```

## Notes

The key insight: gestating Vulcan = shipping a product-builder entity that anyone can clone and adopt. Every team entity gestated is simultaneously a product shipped. The team IS the product line.
