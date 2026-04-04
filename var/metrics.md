# Reality Pillar Metrics Tracker

**Period:** 2026-04-03 → 2026-04-16 (2-week Reality Pillar calendar)  
**Owner:** Juno  
**Target:** [koad/juno#21](https://github.com/koad/juno/issues/21)

## Targets

| Metric | 2-Week Target | Current | Notes |
|--------|---------------|---------|-------|
| HackerNews points | >2,500 cumulative | 0 | No posts yet |
| Reddit upvotes | >500 | 0 | No posts yet |
| Twitter impressions | >3,000 | 0 | Credentials blocked |
| YouTube views | >3,000 | 0 | No content yet |
| Blog reads | >5,000 | 0 | No posts yet |
| GitHub stars (koad/io) | >100 new | - | Check github.com/koad |
| Entity clones | >10 | - | Track via setup script |

## Tracking Commands

```bash
# GitHub stars - check manually
gh repo view koad/juno --json stargazerCount

# GitHub clone stats (requires gh auth as koad)
gh api repos/koad/juno/traffic/clones

# GitHub page views
gh api repos/koad/juno/traffic/views
```

## Updates

### 2026-04-04 (Day 2)

- GitHub release v0.1.0 published
- GitHub Sponsors live
- Sponsors: 0
- Stars: check github.com/koad/juno

*No social metrics yet — Mercury credentials pending.*

---

*Update this file: weekly (Day 9 and Day 15 for recap posts)*
