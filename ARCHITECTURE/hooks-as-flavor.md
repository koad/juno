# Hooks as Flavor

## The Model

```
entity flavor = identity (PRIMER + memories) + capabilities (hooks/) + harness per task
```

`hooks/` is the training layer made explicit. Every autonomous capability the entity has lives there — versioned, forkable, auditable. "What does this entity flavor do?" — read its hooks.

## Harness-per-Hook

The entity fires a hook. The hook declares what runtime it needs. The entity doesn't care which harness runs — it just observes the result.

| Task type | Harness | Cost |
|-----------|---------|------|
| Startup checks, git ops | Shell script | Free |
| Issue triage, status scans | Haiku | Cheap |
| Research threads | deepseek-r1 via ollama | Free |
| Architecture decisions | Claude Sonnet | Worth it |
| Content drafts | opencode | No API key |

Harness defaults live in `.env`. Individual hooks override per task.

## Why This Matters for Entity Flavors

When you sell an entity flavor, you're selling:

1. **Identity** — who the entity is (PRIMER, memories, trust bonds)
2. **Capabilities** — what it does autonomously (hooks/)
3. **Cost profile** — what runtime each capability uses

The hooks folder is the proof of work. A buyer can inspect exactly what they're getting, at what cost, running on what harness. That's auditable, forkable, sovereign.

## The Benchmark Connection

Benchmarking which harness+hook combination produces the best output for a task type *is* the competitive advantage in entity flavor engineering. A well-tuned flavor ships with:

- Hooks tested against known benchmarks
- Harness assignments optimized for cost/quality tradeoff
- Encoded knowledge of *when* to escalate to expensive inference

This maps directly onto AutoAgent's score-driven hill-climbing — except the unit of optimization is a hook, not an `agent.py`. And the result is sovereign: it lives on disk, runs anywhere, owned by the operator.

## The Curriculum Connection

Alice's 12 levels teach the philosophy. The hooks folder is the practice.

A graduate who clones an entity flavor can read its hooks and understand exactly what the entity knows how to do. The hooks are the curriculum made operational. Learning path → encoded capability → hooks/ → shipped flavor.

## Summary

`hooks/` is not configuration. It is training, made inspectable.

The harness is the runtime — swappable, cost-optimized, not the identity.

The entity is the directory.
