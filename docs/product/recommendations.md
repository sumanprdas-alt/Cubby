# Cubby — Recommendations

> Phase 1 deliverable. Prioritized, actionable changes based on product discovery.

---

## Priority 1: Critical (must address before architecture)

### R1: Design the onboarding flow as a first-class product surface
The empty vault problem is the #1 product risk. Specify a complete onboarding flow: family creation → member setup → vault-seeding (gallery import, DigiLocker, or camera scan) → first AI processing → inbox confirmation → "wow moment." Target: user has 3+ items classified and linked within the first 5 minutes.

**Action:** Add onboarding specification to Phase 2 architecture. Add OnboardingOrchestrator.

### R2: Decompose InboxOrchestrator into staged pipeline
The current InboxOrchestrator does everything in one pass. Decompose into: Preprocessing → OCR → Classification → Extraction → Linking. Each stage independently retryable, independently testable, with its own eval dataset.

**Action:** Update orchestrator architecture in Phase 2.

### R3: Reframe "offline-first" as "offline-resilient"
The spec's "full functionality without connectivity" conflicts with AI-core. Reframe: browsing, viewing, and local search work offline. AI processing (OCR, classification, assistant) queues offline and runs when connectivity returns. Assistant degrades to local search results when offline.

**Action:** Update CLAUDE.md Principle 4 and mobile architecture in Phase 2.

### R4: Reduce modules from 9 to 4 surfaces for MVP
Health Hub, Education Hub, and Travel Hub are filtered views of a person's FamilyItems, not separate modules. MVP should have: Inbox, People (with linked items grouped by type), Assistant, and Reminders. The "hub" concept adds navigation complexity.

**Action:** Update core modules in CLAUDE.md. Reflect in Phase 5 MVP definition.

### R5: Increase free tier to 4 members, cap assistant at 20/month
3 free members forces paywall before value delivery. 10 assistant queries/day is too generous (cost problem). Change to 4 members and 20 assistant queries/month.

**Action:** Update freemium tiers in CLAUDE.md.

---

## Priority 2: Important (address during architecture/MVP phases)

### R6: Allow share sheet capture in free tier
Restricting all automated capture to paid tier prevents the data flywheel from forming. Share sheet is zero-cost to Cubby (user pushes data in). Gate email forwarding and WhatsApp bot in paid tier instead.

**Action:** Update freemium feature gates.

### R7: Add missing orchestrators
OnboardingOrchestrator, FeedbackOrchestrator, DuplicateDetectionOrchestrator, and ExportOrchestrator are missing from the spec. All are needed for a complete system.

**Action:** Add to architecture design in Phase 2.

### R8: Start DigiLocker and WhatsApp Business API applications NOW
Both have unpredictable approval timelines (2-8 weeks). Don't wait for Sprint 5 to apply.

**Action:** Submit applications this week, independent of development timeline.

### R9: Add Sentry and PostHog to Tier 1 APIs
Error tracking and analytics are not optional for production. Set up from Sprint 1.

**Action:** Add to API inventory in CLAUDE.md.

### R10: Design error states and low-confidence flows
The spec doesn't address what happens when AI fails. Specify: low-confidence classification flow (show alternatives), OCR failure flow (store image, allow retry), assistant "I don't know" flow (never hallucinate).

**Action:** Add to missing requirements. Specify in Phase 3 feature specs.

### R11: Specify multi-device sync and conflict resolution
Two parents using the app simultaneously need real-time sync. Specify conflict resolution strategy: "create-both-and-flag" for safety over last-write-wins.

**Action:** Address in Phase 2 architecture.

---

## Priority 3: Recommended (address during MVP/build phases)

### R12: Defer Meilisearch — use Drift FTS5 for MVP search
For < 1000 families with < 500 items each, local SQLite full-text search is sufficient. Adding Meilisearch as a separate service increases infra complexity without proportional benefit at MVP scale.

**Action:** Use Drift FTS5 for Sprint 1-4. Evaluate Meilisearch need at Sprint 5.

### R13: Defer semantic search and embeddings
pgvector + Voyage/Cohere embeddings are premature for MVP. Keyword search + entity-aware filtering handles most queries. Add semantic search when there's data showing keyword search isn't sufficient.

**Action:** Defer EmbeddingOrchestrator to Sprint 3+.

### R14: Use server-side encryption for MVP, client-side for Pro
Client-side encryption key management is complex and risky (key loss = data loss). Server-side AES-256 at rest + TLS 1.3 in transit is sufficient for MVP security. Offer client-side encryption as a Pro feature.

**Action:** Update security architecture in Phase 2.

### R15: Evaluate pricing with beta users before committing
₹129/mo vs ₹149/mo vs ₹99/mo — test with real families. Don't commit to pricing until beta feedback.

**Action:** Plan A/B pricing test for Sprint 7.

### R16: Consider ₹2,999 lifetime plan for Tier 2 markets
Price-sensitive Tier 2 families resist recurring charges. A one-time lifetime plan can unlock this segment. Math: if a lifetime user costs ₹9/mo in infrastructure, the plan pays for itself in ~28 months.

**Action:** Evaluate during freemium checkpoint at Month 3.

### R17: Build a "family emergency card" as a viral feature
A shareable emergency info card (all family members' blood groups, allergies, emergency contacts, insurance details) is immediately useful, unique, and shareable. This can be a free feature that drives word-of-mouth.

**Action:** Add to Sprint 4 scope (alongside People profiles).

---

## Summary of CLAUDE.md updates needed

| Section | Change |
|---------|--------|
| Product Principles | Reframe Principle 4: "offline-resilient" not "offline-first" |
| Core Modules | Reduce to 4 MVP surfaces. Hubs are filtered views, not modules. |
| Monetization | Free: 4 members, 20 queries/mo, share sheet included. Family: ₹129/mo. Pro: ₹249/mo. |
| Orchestrators | Add Onboarding, Feedback, DuplicateDetection, Export. Merge Classification into Inbox. |
| APIs | Add Sentry, PostHog, RevenueCat. Defer Meilisearch, Voyage/Cohere. |
| AI Evaluation | Add eval dataset specs per InboxOrchestrator stage, not just per capability. |

---

## Phase 1 complete.

All outputs created:
- `/docs/product/product-critique.md`
- `/docs/product/missing-requirements.md`
- `/docs/product/freemium-evaluation.md`
- `/docs/product/api-integration-audit.md`
- `/docs/product/orchestrator-audit.md`
- `/docs/product/recommendations.md`
- `/docs/research/risks-and-failure-modes.md`
- `/docs/research/competitive-landscape.md`
- `/docs/research/product-moat-analysis.md`
- `/docs/research/icp-analysis.md`
- `/docs/research/jtbd-analysis.md`

**Next step:** Review all Phase 1 outputs. Approve or request changes. Then proceed to Phase 2: Architecture Design.
