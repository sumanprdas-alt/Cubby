# Cubby — System Architecture

> Step 2 deliverable. High-level system design.

---

## Architecture principles

1. **Offline-resilient, AI-enhanced.** Local-first data layer (Drift/SQLite). AI features require connectivity but queue gracefully when offline.
2. **Entity-centric.** Every data operation routes through entity relationships, not folder hierarchies.
3. **Single API for AI.** Claude API (multimodal) handles vision, classification, extraction, and assistant — no OCR service dependency.
4. **Vertical slices.** Each feature is a self-contained module with its own models, services, providers, and UI.
5. **Sync as infrastructure.** Multi-device sync is invisible to the user and handled by SyncOrchestrator.

---

## System diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        MOBILE APP (Flutter)                      │
│                                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           │
│  │Onboarding│ │  Inbox   │ │ People   │ │Assistant │           │
│  │  Module   │ │  Module  │ │  Module  │ │  Module  │           │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘           │
│       │             │            │             │                  │
│  ┌────┴─────────────┴────────────┴─────────────┴──────────┐     │
│  │                   PROVIDER LAYER (Riverpod)             │     │
│  │  familyProvider | inboxProvider | searchProvider | ...   │     │
│  └────────────────────────┬───────────────────────────────┘     │
│                           │                                      │
│  ┌────────────────────────┴───────────────────────────────┐     │
│  │                   SERVICE LAYER                         │     │
│  │  InboxOrchestrator | SearchOrchestrator | ReminderOrch  │     │
│  │  AssistantOrchestrator | SyncOrchestrator | ...          │     │
│  └──────────┬────────────────────────────┬────────────────┘     │
│             │                            │                       │
│  ┌──────────┴──────────┐    ┌───────────┴────────────┐          │
│  │   LOCAL DATA LAYER  │    │   REMOTE API LAYER     │          │
│  │                     │    │                        │          │
│  │  Drift (SQLite)     │    │  Claude API (AI)       │          │
│  │  - FamilyMember     │    │  Supabase (sync/auth)  │          │
│  │  - FamilyItem       │    │  Cloudflare R2 (files) │          │
│  │  - Reminder         │    │  Firebase (push/auth)  │          │
│  │  - FTS5 index       │    │                        │          │
│  │  Local file cache   │    │                        │          │
│  └─────────────────────┘    └────────────────────────┘          │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

                              │
                    ┌─────────┴──────────┐
                    │   CLOUD SERVICES    │
                    │                    │
                    │  Supabase          │
                    │  ├── PostgreSQL    │
                    │  ├── Auth          │
                    │  ├── Realtime      │
                    │  └── Storage       │
                    │                    │
                    │  Cloudflare R2     │
                    │  └── Encrypted     │
                    │      documents     │
                    │                    │
                    │  Claude API        │
                    │  └── Vision +      │
                    │      Classification│
                    │      + Assistant   │
                    │                    │
                    │  Firebase          │
                    │  ├── Phone OTP     │
                    │  └── FCM (push)    │
                    └────────────────────┘
```

---

## Data flow: capture → vault

```
User captures image (camera / gallery / share sheet)
  │
  ▼
[Local] Save raw image to local file cache
  │
  ▼
[Online?] ──No──► Queue in Drift (status: 'queued')
  │                    │
  Yes                  └──► Process when connectivity returns
  │
  ▼
[Claude API] Send image as multimodal message
  │           System prompt: classify + extract + suggest person
  │
  ▼
[Local] Parse response → Create FamilyItem (status: 'pending')
  │       - document_type, extracted_fields, suggested_person
  │       - confidence level
  │
  ▼
[UI] Show in Inbox → User confirms / edits
  │
  ▼
[Local] FamilyItem status → 'confirmed'
  │       - Link to FamilyMember(s)
  │       - Index in FTS5
  │       - Run ReminderOrchestrator (check for dates)
  │       - Run DuplicateDetectionOrchestrator
  │
  ▼
[Sync] SyncOrchestrator pushes to Supabase
        - Metadata to PostgreSQL
        - Document image to Cloudflare R2
```

---

## Data flow: assistant query

```
User types question ("When does Arjun's visa expire?")
  │
  ▼
[Local] SearchOrchestrator
  │       - QueryParser extracts entity reference ("Arjun") + intent ("visa expire")
  │       - Drift FTS5 keyword search, filtered to Arjun's items
  │       - Return top 10 results with metadata
  │
  ▼
[Online?] ──No──► Show local search results only (no AI answer)
  │
  Yes
  │
  ▼
[Claude API] Send query + top 5 result summaries
  │           System prompt: answer using only provided data, cite sources
  │
  ▼
[UI] Show cited answer with linked FamilyItem references
```

---

## Offline behavior matrix

| Feature | Offline behavior | Degrades to |
|---------|-----------------|-------------|
| Browse vault | ✅ Full | — |
| View documents | ✅ Full (cached locally) | — |
| Search (keyword) | ✅ Full (Drift FTS5) | — |
| Reminders | ✅ Full (local) | — |
| Capture (take photo) | ✅ Saves locally, queues for AI | Manual metadata entry |
| AI classification | ❌ Queued | Badge: "Will process when online" |
| Assistant (AI answer) | ❌ Unavailable | Shows local search results instead |
| Sync to other devices | ❌ Queued | Syncs when connectivity returns |
| Push notifications | ❌ Unavailable | Local notifications still work |

---

## Module boundaries

Each feature module owns its own:
- UI screens and widgets
- Riverpod providers
- Service classes
- Does NOT own models (shared across modules) or orchestrators (shared infrastructure)

```
lib/
├── core/           ← Shared infrastructure (theme, router, utils, constants)
├── models/         ← Shared data classes (FamilyMember, FamilyItem, Reminder)
├── services/       ← Orchestrators and API clients
├── providers/      ← Riverpod providers (bridge services ↔ UI)
└── features/       ← Feature modules
    ├── onboarding/
    ├── auth/
    ├── home/
    ├── inbox/
    ├── people/
    ├── assistant/
    ├── timeline/
    ├── capture/
    ├── reminders/
    └── shell/      ← Bottom navigation container
```

---

*See also: database-architecture.md, api-architecture.md, ai-architecture.md, mobile-architecture.md*
