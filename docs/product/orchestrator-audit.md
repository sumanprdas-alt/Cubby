# Cubby — Orchestrator Audit

> Phase 1 deliverable. Validates orchestrator designs, identifies gaps.

---

## Existing orchestrators (from CLAUDE.md)

### InboxOrchestrator ✅ Well-designed, needs decomposition
**Current spec:** Receives raw input → OCR → classifies → extracts entities → links to family members → creates FamilyItem with status `pending`.

**Critique:** This orchestrator does too much in a single pipeline. If OCR succeeds but classification fails, the entire pipeline fails. If classification succeeds but entity linking is wrong, there's no way to retry just the linking step.

**Recommendation:** Decompose into a multi-stage pipeline with independent retry:
```
Input → PreprocessingStage (edge detection, deskew, contrast)
      → OCRStage (Google Cloud Vision)
      → ClassificationStage (Claude API → document type + confidence)
      → ExtractionStage (Claude API → metadata fields, dates, names)
      → LinkingStage (match extracted names to family members)
      → FamilyItem created with status 'pending'
```
Each stage saves intermediate results. If Stage 3 fails, Stages 1-2 don't need to re-run. Each stage has its own eval dataset.

### SearchOrchestrator ✅ Validated
**Current spec:** Keyword + semantic hybrid search, entity-aware filtering, result ranking.

**Critique:** Sound design. For MVP, simplify to keyword-only (Drift FTS5). Add semantic search in Sprint 3+ when embedding pipeline is ready.

**Recommendation:** Add a QueryParserStage that extracts entity references from the query ("Aarav's vaccination card" → entity: Aarav, type: vaccination) before running search. This enables entity-aware filtering without semantic search.

### AssistantOrchestrator ✅ Validated with cost concern
**Current spec:** Natural language query → search → Claude API with results → cited answer.

**Critique:** Each assistant query sends search results + query to Claude, costing ~$0.01-0.03 per query. At 20 queries/month for free users, this is manageable. But the context window usage needs careful management — don't send all 50 search results, send top 5-10.

**Recommendation:** Add a result-pruning stage: SearchOrchestrator returns top 20 → AssistantOrchestrator re-ranks to top 5 → sends top 5 to Claude. Also cache frequent queries ("Which passports expire this year?" is the same query every time, just needs date awareness).

### ReminderOrchestrator ✅ Validated
**Current spec:** Scans FamilyItem metadata for dates, auto-generates reminders.

**Critique:** Sound design. Runs locally, no API cost. The rule set (passport 90/60/30d, insurance 60/30d, etc.) should be configurable, not hardcoded.

**Recommendation:** Store reminder rules as a configuration object, not code. This allows adding new document-type rules without code changes. Also add duplicate suppression — if a passport expiry reminder already exists, don't create another.

### ClassificationOrchestrator ⚠️ Redundant — merge into InboxOrchestrator
**Current spec:** Listed as a separate orchestrator for document type classification.

**Critique:** This is a sub-pipeline of InboxOrchestrator, not a standalone orchestrator. Having it separate creates confusion about which orchestrator "owns" classification.

**Recommendation:** Make ClassificationStage a stage within InboxOrchestrator's pipeline, not a separate orchestrator.

### EmbeddingOrchestrator ⚠️ Defer
**Current spec:** Generates vector embeddings for semantic search.

**Critique:** Premature for MVP. Semantic search is Sprint 3+ at earliest. Adding an embedding pipeline before keyword search is proven adds complexity without value.

**Recommendation:** Defer entirely. When needed, it runs as a background job after a FamilyItem is confirmed (not part of the inbox pipeline). Embedding generation should be async and non-blocking.

### NotificationOrchestrator ✅ Validated
**Current spec:** Delivers reminders via push, local, and in-app notifications.

**Critique:** Sound design. Needs a delivery preference layer — users should control which notification types they receive.

### SyncOrchestrator ✅ Validated with concern
**Current spec:** Offline-first sync, conflict resolution, multi-device state.

**Critique:** Conflict resolution strategy is not specified. Last-write-wins is simplest but can lose data. For family data, losing data is worse than having duplicates.

**Recommendation:** Use "create-both-and-flag" for conflicts — if two devices modify the same item offline, create both versions and flag for user resolution. This is safer than last-write-wins for critical documents.

### EncryptionOrchestrator ✅ Validated — simplify for MVP
**Current spec:** Client-side AES-256 encryption/decryption.

**Critique:** Client-side encryption adds key management complexity. For MVP, server-side encryption (Supabase handles this) is sufficient.

**Recommendation:** Use server-side encryption for MVP. Add client-side encryption as a Pro feature when the team has capacity to build proper key management (key backup, key recovery, device transfer).

---

## Missing orchestrators

### OnboardingOrchestrator — ADD
**Responsibility:** Manages the first-run vault-seeding flow. Guides the user through family setup → member creation → initial document capture → first AI processing → inbox confirmation.
**Why it matters:** Onboarding is the highest-stakes user flow. It needs its own orchestration to handle: DigiLocker import, gallery bulk import, guided scan, and progress tracking ("3 of 5 documents processed").
**APIs used:** Firebase Auth, DigiLocker (optional), Google Cloud Vision, Claude API.

### FeedbackOrchestrator — ADD
**Responsibility:** When a user corrects an AI classification (changes document type, re-links to different person), this orchestrator captures the correction and feeds it back into the system. Over time, corrections become training data for better classification.
**Why it matters:** This is how the AI moat builds. Without explicit feedback capture, corrections are lost.
**APIs used:** Local (Drift) for storing corrections. Future: fine-tuning pipeline.

### ExportOrchestrator — ADD
**Responsibility:** Generates a full data export (all documents + metadata as JSON + original files in a zip) for DPDPA compliance and user peace of mind.
**Why it matters:** Regulatory requirement (right to data portability). Also a trust signal — "your data is always yours."
**APIs used:** Local file system, Cloudflare R2 (download originals).

### DuplicateDetectionOrchestrator — ADD
**Responsibility:** When a new FamilyItem is created, checks for duplicates (same document scanned twice, same email forwarded twice). Uses image hash comparison and metadata matching.
**Why it matters:** Without this, families will end up with duplicate items that clutter the vault and confuse the assistant.
**APIs used:** Local (perceptual hashing, metadata comparison).

---

## Revised orchestrator map

| Orchestrator | MVP | Pipeline stages | Key APIs |
|-------------|-----|----------------|----------|
| InboxOrchestrator | ✅ | Preprocessing → OCR → Classification → Extraction → Linking → Create FamilyItem | GCV, Claude |
| SearchOrchestrator | ✅ | QueryParsing → KeywordSearch → (SemanticSearch) → EntityFilter → Rank | Drift FTS5, (pgvector) |
| AssistantOrchestrator | ✅ | Search → PruneResults → Claude → FormatCitation | SearchOrchestrator, Claude |
| ReminderOrchestrator | ✅ | ScanMetadata → MatchRules → CreateReminder → DedupCheck | Local (Drift) |
| NotificationOrchestrator | ✅ | CheckDueReminders → ResolvePreferences → Deliver | FCM, local |
| SyncOrchestrator | ✅ | DetectChanges → ResolveConflicts → Push/Pull | Supabase |
| OnboardingOrchestrator | ✅ | FamilySetup → MemberCreate → VaultSeed → FirstProcess | Firebase, GCV, Claude |
| FeedbackOrchestrator | ✅ | CaptureCorrection → StoreLabel → (FutureFinetuning) | Local |
| DuplicateDetectionOrchestrator | ✅ | HashImage → CompareMetadata → FlagDuplicate | Local |
| EncryptionOrchestrator | Sprint 5+ | Encrypt → Upload / Download → Decrypt | Local (dart:crypto) |
| EmbeddingOrchestrator | Sprint 3+ | GenerateEmbedding → StoreVector → IndexUpdate | Voyage/Cohere |
| ExportOrchestrator | Sprint 5+ | GatherItems → DownloadFiles → PackageZip → Deliver | R2, local |

---

*Next: Recommendations → /docs/product/recommendations.md*
