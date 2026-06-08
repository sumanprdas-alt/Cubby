# CLAUDE.md

## Project: Cubby

> Formerly Cubby. Brand name: Cubby.
> "Cubby it" — put it in. "Check Cubby" — get it out.

You are the founding product team, staff engineer, architect, designer, CTO and principal engineer responsible for creating this company from zero to launch.

Do not behave like a coding assistant.
Behave like a founder-level team building a venture-scale product.
Challenge assumptions where appropriate.
Recommend better solutions when they exist.

Your job is not simply to write code.
Your job is to design, architect, validate, build and ship the best possible version of this product.

---

## Mission

Build the family cubby — one place for everything that matters.

Families today manage their lives across dozens of disconnected systems: WhatsApp, Gmail, Outlook, Apple Notes, Google Drive, Dropbox, Calendar apps, school portals, hospital portals, insurance systems, government portals, physical folders.

Critical information is fragmented. The problem is not storage. The problem is: remembering, organizing, retrieving, acting.

Cubby should become the single source of truth for everything important in a family's life.

---

## Product Vision

Cubby combines: Apple Wallet + ChatGPT + Notion + Google Calendar + Dropbox into one family cubbyhole.

The product functions as:
- Family Vault — "cubby that visa"
- Family Timeline — everything that happened
- Family Assistant — "hey Cubby, when does our insurance expire?"
- Family Brain — remembers so you don't have to

The long-term vision is an autonomous family executive assistant.

---

## Product Principles

### Principle 1: No folders
Users should never manage folders. The system organizes information automatically around entities (people, pets, vehicles, properties).

### Principle 2: Capture > Storage
The biggest risk to product success is ingestion friction. Minimize user effort. Maximize automation. Everything enters through a Family Inbox where AI processes, classifies, links, and files automatically.

### Principle 3: Search > Navigation
Users should ask questions, not browse. The AI assistant is the primary interface.

### Principle 4: Mobile-first
The primary experience is mobile. Desktop is secondary.

### Principle 5: Trust is everything
Security and privacy are first-class concerns. End-to-end encryption. Biometric lock. Audit logs.

### Principle 6: AI where possible, offline where not
AI is a core system capability — classification, entity extraction, relationship mapping, and assistant answers all run through AI when online. When offline, the app works fully for browsing, viewing, local search (keyword), and reminders. AI processing queues offline and runs when connectivity returns. The app must never feel broken without internet — just less intelligent.

---

## Target Audience

### Beta launch: Dubai
- English-speaking families in Dubai / UAE
- Expat and local nuclear families
- Age 25-60, smartphone-savvy
- Document types: Emirates ID, visa copies, MOHAP health cards, tenancy contracts (Ejari), school reports, insurance policies, vehicle registration (Mulkiya), pet vaccination records, travel bookings
- Secondary: Grandparents, caregivers, domestic helpers (limited access)

### Phase 1 expansion
- India Tier 1 cities (Bangalore, Mumbai, Delhi NCR, Hyderabad, Chennai)
- India Tier 2 cities (Pune, Ahmedabad, Jaipur, Kochi)
- English-speaking families only — no regional language support in Phase 1
- Age 25-60, parents in nuclear families

---

## Core Entities

Design the system around entities. Not files. Not folders.

```
Family
├── FamilyMember
│   ├── type: person
│   │   ├── role: parent | child | grandparent | caregiver
│   │   └── ...person-specific fields
│   └── type: pet
│       ├── species: dog | cat | bird | fish | other
│       └── ...pet-specific fields
├── Vehicle
│   ├── make, model, year, plate_number
│   ├── registration_expiry (Mulkiya)
│   ├── insurance_expiry
│   └── linked FamilyItems (registration, insurance, fines)
├── Property
│   ├── name, address, type (rent | own)
│   ├── tenancy_start, tenancy_end (Ejari)
│   ├── landlord_name, landlord_contact
│   └── linked FamilyItems (tenancy contract, DEWA bills, maintenance)
```

IMPORTANT: Pets are family members. They are NOT a separate entity class. A pet is a FamilyMember with `type: pet` and a species tag. The system treats them identically in terms of documents, timelines, health records, reminders, and vault items. Do not create separate pet tiers in pricing (e.g. "6 people + 2 pets"). Count all family members equally.

Vehicle and Property are top-level entities under Family. FamilyItems can link to Vehicles and Properties just like they link to FamilyMembers. A Mulkiya links to a Vehicle. An Ejari links to a Property. Reminders auto-generate from their expiry dates.

Universal object: `FamilyItem` — every document, record, appointment, or piece of information. Each FamilyItem links to one or more entities (members, vehicles, properties).

---

## Core Modules

0. **Onboarding** — First-run vault-seeding flow. Family setup → member creation → guided capture → first AI processing → inbox confirmation. Must deliver "wow moment" within 3 minutes. See /docs/product/onboarding-specification.md.
1. **Family Profiles** — Family setup, member management, roles, permissions
2. **Smart Vault** — Entity-linked document storage, auto-organized by AI
3. **Family Inbox** — Toss-in capture point. AI processes, classifies, links, files. User confirms.
4. **Family Timeline** — Chronological life events per member and per family
5. **Family Assistant** — Natural language queries across all family data with cited answers
6. **Reminders** — Auto-generated from document metadata (passport expiry, visa expiry, insurance renewal, vaccination schedules, medication refills, tenancy/Ejari renewal)
7. **Health Hub** — Filtered view of health-related FamilyItems per member (prescriptions, lab reports, vaccinations, medications)
8. **Education Hub** — Filtered view of education-related FamilyItems per child (school reports, certificates)
9. **Travel Hub** — Filtered view of travel-related FamilyItems (bookings, travel documents)

Note: Hubs 7-9 are filtered views of a person's FamilyItems, not separate modules. They share the same data model and UI patterns. For MVP, the People → Person detail screen shows items grouped by type, which IS the hub view.

---

## Design Direction

### Inspiration
Apple Wallet (card-based, glanceable) + Linear (minimal, fast) + Notion (flexible) + ChatGPT (conversational) + Headspace (warm, calm)

### Characteristics
- Minimal — no clutter, no enterprise dashboards
- Warm — not cold/corporate; this is about family
- Calm — no anxiety-inducing red badges everywhere
- Premium — feels like a luxury product, not a utility
- Fast — every interaction under 200ms perceived latency
- Trustworthy — security is visible, not hidden

### Anti-patterns to avoid
- Complex folder navigation
- Excessive card grids
- Enterprise dashboard aesthetics
- Too many form fields
- Notification overload

---

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Mobile | Flutter 3.x (iOS + Android) | |
| State | Riverpod 3.x | |
| Local DB | Drift (SQLite) for structured data + FTS5 search | |
| Backend | Supabase (PostgreSQL + Realtime + Edge Functions) | See Neon note below |
| Database | PostgreSQL with row-level security | |
| Object Storage | Cloudflare R2 | S3-compatible, no egress fees |
| AI | Claude API (Anthropic) — multimodal vision + classification + assistant | Single provider for all AI |
| Auth | Firebase Phone OTP (primary), Google/Apple (secondary) | Works for UAE +971 and India +91 |
| Notifications | Firebase Cloud Messaging + APNs + local scheduling | |
| Payments | Stripe | Global: works in UAE, India, and expansion markets |
| Analytics | PostHog | Self-hostable for data residency |
| Error tracking | Sentry | sentry_flutter SDK |

### Deferred (not in MVP)
- Meilisearch (cloud keyword search — using Drift FTS5 locally for MVP)
- pgvector / embeddings (semantic search — deferred until keyword search isn't enough)
- Whisper API (voice input)
- BullMQ (async queue — Edge Functions handle async for MVP scale)

### Database: Supabase vs Neon

**Current choice: Supabase** — gives you PostgreSQL + Realtime subscriptions + Edge Functions + auto-generated REST API in one platform. Fastest path to MVP for a small team. $25/mo Pro plan.

**Alternative: Neon** — serverless PostgreSQL with auto-scaling (scales to zero = cheaper for beta), branching (instant dev/staging databases), and better connection pooling. But Neon is database-only — you'd need to add Cloudflare Workers for edge functions and build your own realtime sync (or defer multi-device sync to post-beta).

Neon stack would be: Neon (DB) + Cloudflare Workers (API/edge functions) + Cloudflare R2 (storage) + Firebase (auth/push). Cleaner separation of concerns, potentially cheaper, but more setup work.

**Decision:** Start with Supabase for speed. Evaluate Neon migration after beta if Supabase's pricing or limitations become a concern. The data model is standard PostgreSQL — migration between Supabase and Neon is straightforward.

---

## APIs and Integrations Inventory

### Tier 1 — MVP Required

| API / Service | Purpose | Endpoint / SDK | Pricing | Lead Time | Risk |
|--------------|---------|---------------|---------|-----------|------|
| Claude API (Anthropic) | Vision (reads documents from images), classification, entity extraction, assistant, parsing — single API for all AI | `api.anthropic.com/v1/messages` | ~$3/MTok input, ~$15/MTok output (Sonnet) | 1 day | Low |
| Firebase Auth | Phone OTP (UAE +971, India +91), Google/Apple sign-in | Native SDK | Free (10K/month) | 1-2 days | Low |
| Firebase Cloud Messaging | Push notifications | Native SDK | Free | 1 day | Low |
| Supabase / PostgreSQL | Database, real-time sync, Edge Functions | `supabase.co` | $25/mo (Pro) | 1 day | Low |
| Cloudflare R2 | Encrypted document storage | S3-compatible API | $0.015/GB/mo | 1 day | Low |
| Sentry | Error tracking + performance monitoring | `sentry.io` | Free (5K events/mo) | 1 day | Low |
| PostHog | Analytics + event tracking | `posthog.com` | Free (1M events/mo) | 1 day | Low |

### Tier 2 — Post-Beta

| API / Service | Purpose | Notes |
|--------------|---------|-------|
| Stripe | Subscription payments (UAE + India + global) | Only when freemium gates are implemented |
| WhatsApp Business API | Document forwarding bot | Not needed — share sheet covers WhatsApp capture for beta |
| Google Calendar API | Two-way calendar sync | |
| Gmail API | Parse forwarded emails | |
| DigiLocker | Indian government documents | India expansion only, not relevant for Dubai |
| Apple HealthKit | Sync medications, vitals | |
| Google Health Connect | Android health data | |

### Tier 3 — Future

| API / Service | Purpose | Notes |
|--------------|---------|-------|
| ABHA / Health ID | Indian health records | Government API — slow approval |
| UPI deep links | Bill payment reminders | Deep link only, no API needed |
| School portal APIs | Auto-sync report cards | No standard API — scraping or partnerships |

---

## Orchestrators

Orchestrators are the AI-powered pipelines that process data through the system.

| Orchestrator | Responsibility | APIs Used | Requires Network |
|-------------|---------------|-----------|-----------------|
| InboxOrchestrator | Receives raw input (photo, screenshot, share sheet image, PDF). Sends image to Claude Vision API which reads the document, classifies type, extracts metadata (dates, names, amounts), and suggests family member links — all in a single API call. Creates FamilyItem with status `pending`. | Claude API (multimodal) | Yes (queue offline) |
| SearchOrchestrator | Handles keyword search with entity-aware filtering and result ranking. Uses local Drift FTS5 for offline search. | Drift FTS5 (local) | No |
| AssistantOrchestrator | Takes natural language query, runs search, sends query + top results to Claude, returns cited answer | SearchOrchestrator, Claude API | Yes (search local, answer needs API) |
| ReminderOrchestrator | Scans FamilyItem metadata for dates, auto-generates reminders based on configurable rules (passport 90/60/30d, visa 90/60/30d, insurance 60/30d, vaccination 14/7d, medication 7d, tenancy/Ejari 60/30d) | Local (Drift) | No |
| NotificationOrchestrator | Delivers reminders and alerts via push, local, and in-app notifications | FCM, APNs, local notifications | Partial |
| SyncOrchestrator | Handles offline-resilient sync, conflict resolution (create-both-and-flag), multi-device state | Supabase Realtime | Yes |
| OnboardingOrchestrator | Manages first-run vault-seeding: family setup → member creation → bulk capture → first AI processing → inbox confirmation | Firebase Auth, Claude API | Partial |
| FeedbackOrchestrator | Captures user corrections to AI classifications, stores as labeled training data for future accuracy improvements | Local (Drift) | No |
| DuplicateDetectionOrchestrator | When new FamilyItem is created, checks for duplicates via image hash + metadata matching | Local | No |

---

## Security Model

- AES-256 encryption at rest, TLS 1.3 in transit
- Client-side encryption for documents before upload
- Biometric lock (fingerprint / Face ID)
- Role-based access: parent (full), child (limited), grandparent (read-only configurable), caregiver (scoped)
- Audit logs for all document access
- Data portability (full export)
- DPDPA (India) + GDPR compliant
- SOC 2 Type II target for enterprise expansion

---

## Monetization — Freemium Model (Post-Beta)

NOT in MVP. NOT in beta. Build this only after real users exist.

Beta: everything free, unlimited, no gates, no payment flows. Sign-in exists for identity and multi-device sync only.

### Future tiers (design only — do not implement until post-beta)

| Tier | Price (Dubai) | Price (India) | Includes |
|------|--------------|---------------|---------|
| **Free** | $0 | ₹0 | 4 family members, 500MB storage, scan + share sheet capture, 20 assistant queries/month, basic reminders |
| **Family** | $9.99/mo ($89/yr) | ₹129/mo (₹999/yr) | 8 family members, 10GB, all capture channels, unlimited assistant, smart reminders, timeline |
| **Family Pro** | $19.99/mo ($179/yr) | ₹249/mo (₹1,999/yr) | 15 family members, 50GB, WhatsApp bot, shared timeline, export, priority processing |

Vehicle and Property entities are free for all tiers — they don't count toward member limits.

Evaluate tiers only after beta feedback. Real usage data > guesses.

---

## AI Evaluation Framework

Every AI capability ships with eval datasets. Red-Green TDD applies to AI: write failing eval first, then implement until it passes.

| Capability | Eval Metric | Threshold | Eval Dataset Size |
|-----------|------------|-----------|------------------|
| OCR accuracy | Character error rate | < 5% | 200+ documents |
| Document classification | F1 score | > 90% | 500+ classified items |
| Entity extraction | Precision / recall | > 85% | 300+ items |
| Person/pet matching | Accuracy | > 90% | 200+ items |
| Reminder generation | Precision | > 95% (no false reminders) | 100+ items with dates |
| Assistant retrieval | MRR@5 | > 0.8 | 200+ queries |
| Assistant factual accuracy | Accuracy | > 95% | 200+ queries |
| Hallucination rate | False claims | < 2% | 200+ queries |
| Duplicate detection | F1 score | > 88% | 150+ item pairs |

Eval workflow:
1. Define eval dataset (golden set of inputs + expected outputs)
2. Run eval — all tests should FAIL (red)
3. Implement AI capability
4. Run eval — tests should PASS (green)
5. On every model update or prompt change, re-run full eval suite
6. Track eval scores over time — no regressions allowed

---

## Coding Standards

- Dart/Flutter conventions (effective_dart)
- Max file length: 300 lines. Split into widgets/mixins if longer.
- Every public API has dartdoc comments
- No `print()` — use `logger` package
- No hardcoded strings — use constants or l10n
- All colors from `AppColors`, all text styles from `AppTypography`
- State: Riverpod providers only. No setState except in trivial local widget state.
- Navigation: go_router only. No Navigator.push.
- Models: freezed + json_serializable. No hand-written fromJson/toJson.
- Database: Drift DAOs. No raw SQL in features.

---

## Testing Standards (Red-Green TDD)

All development follows strict Red-Green TDD:
1. Write a failing test (RED)
2. Write minimum code to pass (GREEN)
3. Refactor
4. Repeat

Coverage requirements:
- Every model has unit tests
- Every service has unit tests with mocks
- Every provider has integration tests
- Every orchestrator has integration tests with mock APIs
- Critical flows (auth, inbox, capture, assistant) have widget tests
- AI capabilities have eval datasets (see AI Evaluation Framework)
- Target: 80%+ coverage on models and services

Test naming: `test('should [expected behavior] when [condition]')`

---

## Git Conventions

- Repository: https://github.com/sumanprdas-alt/Cubby
- Branch naming: `feature/xxx`, `fix/xxx`, `docs/xxx`, `refactor/xxx`, `test/xxx`
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`)
- No direct pushes to main
- PR required for all changes
- CI must pass before merge

---

## Development Workflow

### Tools
- **Claude Code** — Product strategy, architecture, feature specs, code review, AI pipeline design
- **Cursor** — Implementation, TDD, debugging, UI building

### Workflow per feature
```
Idea
  ↓
Claude Code → Feature PRD (in /docs/features)
  ↓
Claude Code → Acceptance criteria + edge cases
  ↓
Claude Code → Architecture review (check against /docs/decisions)
  ↓
Cursor → Write failing tests (RED)
  ↓
Cursor → Implementation (GREEN)
  ↓
Cursor → Refactor
  ↓
Claude Code → Code review
  ↓
Release
```

### Session discipline
- Each Claude Code session has a specific scope (product, architecture, features, testing, or review)
- Do not mix concerns across sessions
- Every session reads CLAUDE.md first
- Every session reads all relevant /docs before producing output
- No code generation until all specs are approved

---

## Project Phases

### Phase 0: Repository Setup
- Create repo structure
- CLAUDE.md in root
- Commit

### Phase 1: Product Discovery (Claude Code)
- Product critique and assumption challenges
- Missing requirements identification
- Risk and failure mode analysis
- Competitive landscape
- Product moat analysis
- ICP analysis
- Jobs To Be Done analysis
- Freemium model evaluation
- API and integration inventory validation
- Orchestrator design validation
- Output: /docs/research and /docs/product

### Phase 2: Architecture Design (Claude Code)
- System architecture
- Database architecture and entity relationship model
- API architecture
- Search architecture (hybrid: keyword + semantic + entity-aware)
- AI architecture (orchestrators, pipelines, eval framework)
- Authentication and permissions architecture
- Security architecture
- Mobile architecture (offline-first, sync)
- Notification architecture
- Analytics and observability architecture
- Output: /docs/architecture

### Phase 3: Product Specification (Claude Code) — PAUSED
- Detailed specs for all 9 modules
- User stories, flows, edge cases, acceptance criteria
- Output: /docs/features

### Phase 4: Engineering Standards (Claude Code)
- TDD strategy and test architecture
- CI/CD strategy
- Branching and release strategy
- AI evaluation strategy
- Coding and documentation standards
- Security review process
- Output: /docs/testing and /docs/architecture

### Phase 5: MVP Definition (Claude Code)
- Smallest viable scope with real user value
- Sprint breakdown with TDD milestones
- Dependencies and risk assessment
- Freemium model evaluation checkpoint
- Output: /docs/product

### Phase 6: Build Plan (Claude Code)
- Repository structure for implementation
- Backend, mobile, database, API, UI, AI implementation order
- Sequential vertical slices (each independently testable)
- Output: /docs/architecture and /docs/product

### Phase 7: Architecture Freeze (Claude Code)
- Architecture Decision Records (ADRs)
- These become project laws
- No violations without explicit approval
- Output: /docs/decisions

### Phase 8: Implementation (Cursor)
- Read all documentation
- Follow documented decisions
- TDD — tests before implementation
- Pause when documentation is ambiguous

---

## Success Metrics

| Metric | Month 3 | Month 6 | Month 12 |
|--------|---------|---------|----------|
| Weekly active families | 500 | 5,000 | 25,000 |
| Items per family | 15 | 40 | 100+ |
| Inbox → confirmed rate | 80% | 88% | 92% |
| Assistant queries/week/family | 3 | 8 | 15 |
| Search success rate | 70% | 82% | 90% |
| Paid conversion | 5% | 10% | 15% |
| Monthly churn | 8% | 5% | 3% |
| Cost per free user | < ₹15/mo | < ₹12/mo | < ₹10/mo |
| LTV:CAC | 2:1 | 3:1 | 4:1 |

---

## Cost Projection (1000 Active Families)

| Service | Monthly Cost |
|---------|-------------|
| Claude API (15K vision+classification + 30K assistant queries) | ~$200 |
| Supabase Pro | $25 |
| Firebase (auth + FCM) | ~$10 |
| Cloudflare R2 | ~$5 |
| Sentry | Free tier |
| PostHog | Free tier |
| **Total** | **~$240/month** |
| **Per-family cost** | **~$0.24/month** |

Break-even at ~25 paying families ($9.99/mo tier, 10% conversion from 250 families).
Dubai beta with 20 families: total cost ~$5/month (negligible).

---

## File Structure

```
familyos/
├── CLAUDE.md                  — This file. Project constitution.
├── README.md                  — Public repo readme
├── docs/
│   ├── vision/                — Product vision, mission, principles
│   ├── product/               — PRD, MVP scope, sprint plans, freemium evaluation
│   ├── architecture/          — System, database, API, AI, search, mobile architecture
│   ├── features/              — Per-module specifications (1 file per feature)
│   ├── decisions/             — Architecture Decision Records (project laws)
│   ├── testing/               — TDD strategy, test architecture, CI/CD, evals
│   ├── growth/                — Growth strategy, analytics, monetization
│   └── research/              — Competitive analysis, ICP, JTBD, risks
├── plan/                      — Milestone tracker, phase status
├── apps/                      — Application code (Flutter app, backend)
├── packages/                  — Shared packages, design system
└── tests/                     — Test suites, eval datasets
```

---

*Cubby: Because your family's important stuff shouldn't be scattered across 12 apps, 3 email accounts, and a drawer full of papers.*
