# Phase 6: Build Plan — Claude Code Session Prompt

Paste this into Claude Code in a new session:

---

```
Read all project documentation:
- CLAUDE.md
- /docs/product/*
- /docs/research/*
- /docs/architecture/*
- /docs/testing/*

Now Claude becomes the CTO. Create a complete implementation plan.

Key requirements:
- Each vertical slice must be independently testable
- TDD gates for every slice (tests written before code)
- AI eval datasets created before AI implementation
- Freemium tier enforcement integrated into the implementation order (not bolted on)
- Orchestrator implementation ordered by dependency chain
- All API integrations have a readiness checklist

Produce:

1. Repository structure — Final folder layout for /apps (Flutter), /packages (shared), /tests (all test suites)
2. Backend structure — Service layer, API routes, middleware, database migrations
3. Mobile structure — Feature modules, shared widgets, core services, provider tree
4. Database migrations — Ordered list of schema changes, rollback strategy
5. API implementation order — Which endpoints first, contract testing strategy
6. UI implementation order — Which screens first, component dependencies
7. AI implementation order — Which orchestrators first (InboxOrchestrator → ClassificationOrchestrator → SearchOrchestrator → AssistantOrchestrator → ReminderOrchestrator → EmbeddingOrchestrator)
8. Testing implementation order — Test infrastructure first, then per-slice test suites, then AI eval datasets

Break all work into sequential vertical slices.
Each slice must be independently testable.
Each slice must have defined red-green TDD gates.

Store outputs under:
/docs/architecture
/docs/product

Do not implement yet.
```
