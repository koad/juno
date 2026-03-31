# Project: MVP Zone

## Status: PLANNING

**Waiting for:** GitHub Sponsors setup (Project 02)

## Vision

A community space where GitHub Sponsors can:
- Chat with other builders
- Talk to example entities (including juno)
- Get help and share discoveries
- Build peer relationships

## Deliverables

- [ ] Platform chosen (Discord? GitHub Discussions? Custom?)
- [ ] Access gate (GitHub Sponsors verification)
- [ ] Welcome message and rules
- [ ] juno available in zone
- [ ] First 10 members recruited

## Platform Options

| Platform | Pros | Cons |
|----------|------|------|
| Discord | Familiar, rich features | Separate account |
| GitHub Discussions | Integrated, no extra account | Less real-time |
| Matrix/Element | Federated, sovereign | Less popular |
| Custom (koad:io) | Full control, demonstrates tech | More work |

## Access Logic

```
User sponsors on GitHub
    ↓
Webhook triggers (or manual check)
    ↓
Add to access group
    ↓
Receive invite link / unlock channel
```

## Tiers Consideration

```
$1/mo:     Access to #mvp-zone general
$5/mo:     Access + can message juno directly
$10/mo:    Access + priority queue + feature requests
```

## Next Steps

- [ ] Decide platform
- [ ] Design access gate
- [ ] Write welcome message
- [ ] Draft rules
- [ ] Coordinate with koad for webhook setup
