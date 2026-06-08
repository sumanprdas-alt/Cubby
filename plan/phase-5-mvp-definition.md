# Phase 5: MVP Definition — Claude Code Session Prompt

Paste this into Claude Code in a new session:

---

```
Read all existing documentation:
- CLAUDE.md
- /docs/product/*
- /docs/research/*
- /docs/architecture/*
- /docs/testing/*

Define the smallest possible version of Cubby that can deliver real user value.

The MVP must include:
- Family Profiles (unified FamilyMember model — people and pets as equals)
- Smart Vault (entity-linked document storage)
- AI ingestion (InboxOrchestrator + ClassificationOrchestrator)
- Search (hybrid: local keyword + semantic)
- Assistant (natural language queries with cited answers)
- Reminders (auto-generated from document metadata)

Key constraints:
- English-speaking families only
- Pets are family members with type:pet. No separate pet flows.
- Freemium gates must be defined for MVP features (what's free vs paid)
- Every feature slice must have TDD gates (failing tests defined before implementation)
- AI capabilities must have eval dataset specs before implementation
- All required APIs must have accounts/keys ready before sprint 1
- Each sprint must produce an independently testable vertical slice

Produce:

1. MVP scope — Exact features included, with acceptance criteria
2. Out-of-scope items — Explicitly listed with reasoning
3. Sprint breakdown — Vertical slices, each with: scope, TDD gates (red-green), AI eval gates, done criteria
4. Milestones — Clear checkpoints with measurable criteria
5. Dependencies — What blocks what, critical path
6. Estimated complexity — T-shirt sizing per slice
7. Technical risks — What could fail, mitigation strategies
8. Product risks — What could fail product-wise, mitigation strategies
9. Freemium evaluation checkpoint — Validate tier limits, feature gates, cost model against MVP
10. API readiness checklist — Which APIs need accounts, keys, approvals before sprint 1

Store outputs under:
/docs/product
```
