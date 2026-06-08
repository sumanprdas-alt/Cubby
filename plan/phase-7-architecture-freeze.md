# Phase 7: Architecture Freeze — Claude Code Session Prompt

Paste this into Claude Code in a new session:

---

```
Read all project documentation:
- CLAUDE.md
- /docs/product/*
- /docs/research/*
- /docs/architecture/*
- /docs/testing/*

Based on all approved documentation, create Architecture Decision Records (ADRs).

These documents become project laws.
Future implementation must not violate them without explicit founder approval.

Create the following ADRs:

001-product-principles
  - No folders, entities not files, inbox-first, search > navigation, mobile-first, trust, AI-core
  - Pets are family members (type:pet), not a separate concept

002-mobile-architecture
  - Flutter, Riverpod, Drift, offline-first, go_router, freezed models
  - Module structure, provider tree, local-first sync

003-backend-architecture
  - Supabase/PostgreSQL, Fastify/Hono, row-level security
  - API versioning, rate limiting, error handling

004-search-strategy
  - Hybrid: Drift FTS5 (local) + Meilisearch (cloud keyword) + pgvector (semantic)
  - Entity-aware filtering, offline search capability

005-ai-strategy
  - Claude API (Sonnet primary, Opus for complex)
  - Orchestrator pipeline architecture
  - Eval framework with red-green gates
  - Cost optimization, fallback strategies

006-security-strategy
  - AES-256 encryption, client-side encryption before upload
  - Biometric lock, RBAC, audit logs
  - DPDPA + GDPR compliance

007-testing-strategy
  - Red-Green TDD mandatory
  - Coverage targets: 80%+ models/services
  - AI eval datasets with regression detection
  - CI gates: lint → unit → integration → AI eval → build

008-design-system
  - Color palette, typography, component library
  - Apple Wallet + Linear + Headspace inspired
  - Anti-patterns documented

009-permissions-model
  - Roles: parent (full), child (limited), grandparent (configurable read), caregiver (scoped)
  - Per-item sharing, family invitation flow

010-monetization-strategy
  - Freemium: Free (3 members, 500MB) → Family (8 members, 10GB) → Pro (15 members, 50GB)
  - Members = people + pets equally counted
  - Conversion triggers, cost-per-free-user targets, evaluation cadence

Store all ADRs in:
/docs/decisions

Each ADR should follow this format:
- Title
- Status (Accepted)
- Context (why this decision matters)
- Decision (what we chose)
- Consequences (tradeoffs)
- Alternatives considered (what we rejected and why)
```
