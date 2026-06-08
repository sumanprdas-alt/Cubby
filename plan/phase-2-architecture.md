# Phase 2: Architecture Design — Claude Code Session Prompt

Paste this into Claude Code in a new session:

---

```
Read:
- CLAUDE.md
- /docs/product/*
- /docs/research/*

Assume all reviewed documents are approved.

Design the complete system architecture for Cubby.

Key constraints:
- Pets are FamilyMembers with type:pet. Single entity model, not separate tables.
- Offline-first architecture. Full functionality without connectivity.
- Hybrid search: Drift FTS5 (local) + Meilisearch (cloud keyword) + pgvector (semantic).
- All orchestrators from CLAUDE.md must be architecturally specified.
- AI eval datasets must be part of the architecture (where they live, how they run, CI integration).
- Freemium tier enforcement must be architecturally clean (not scattered if-checks).

Produce:

1. System architecture — High-level diagram (Mermaid), component interactions, data flow
2. Database architecture — Schema design, entity tables, relationships, migration strategy
3. Entity relationship model — FamilyMember (person+pet unified), FamilyItem, Reminder, all relationships
4. API architecture — REST endpoints, versioning, rate limiting, error handling, auth middleware
5. Search architecture — Hybrid search pipeline, indexing strategy, entity-aware filtering, offline search
6. AI architecture — All orchestrators specified: InboxOrchestrator, SearchOrchestrator, AssistantOrchestrator, ReminderOrchestrator, ClassificationOrchestrator, EmbeddingOrchestrator. Include fallback strategies, retry logic, cost optimization.
7. Authentication architecture — Phone OTP flow, family creation, member invitation, session management, token refresh
8. Permissions model — Role definitions (parent/child/grandparent/caregiver), per-item access, sharing rules
9. Security architecture — E2E encryption flow, key management, biometric lock, audit logging, data export
10. Mobile architecture — Flutter module structure, Riverpod provider tree, offline sync strategy, Drift schema, local vs cloud data
11. Notification architecture — Push (FCM/APNs), local scheduling, in-app notifications, reminder delivery pipeline
12. Analytics architecture — Event taxonomy, funnel tracking, freemium conversion analytics, AI eval dashboards
13. Observability architecture — Structured logging, error tracking (Sentry), performance monitoring, AI pipeline observability

Store outputs in:
/docs/architecture

Do not write application code.
Focus on long-term scalability and maintainability.
```
