# Cubby — API and Integration Audit

> Phase 1 deliverable. Validates APIs from CLAUDE.md and identifies gaps.

---

## Tier 1 APIs (MVP) — Audit

### Google Cloud Vision ✅ Validated
- **Status:** Production-ready. Well-documented. Pay-per-use.
- **Concern:** Accuracy on handwritten Indian prescriptions and thermal-printed bills needs eval dataset benchmarking. May need preprocessing (contrast enhancement, deskewing) before sending to API.
- **Alternative to evaluate:** Azure AI Vision (sometimes better on handwritten text). Benchmark both against the same 200-document eval dataset.
- **Action:** Create GCV account. Benchmark against Indian document samples before committing.

### Claude API (Anthropic) ✅ Validated
- **Status:** Production-ready. Excellent for classification, extraction, and conversational assistant.
- **Concern:** Cost at scale. Sonnet for classification (~$3/MTok input) is reasonable, but assistant queries with full context (search results + conversation history) can be expensive.
- **Optimization:** Use structured output mode for classification (reduces output tokens). Cache system prompts. Batch classification requests where possible.
- **Alternative:** Consider Haiku for simple classification tasks (cheaper). Sonnet for assistant. Never Opus unless query complexity demands it.
- **Action:** Create Anthropic account. Design prompt templates for classification and assistant. Benchmark cost per query type.

### Firebase Auth ✅ Validated
- **Status:** Production-ready. Phone OTP is the right primary auth for India/MEA.
- **Concern:** Free tier is 10K monthly verifications. At scale (25K families), this may not be enough (users re-auth after app reinstall, new device setup, etc.).
- **Action:** Monitor verification volume. Budget for paid tier if needed (~$0.06/verification beyond free tier).

### Firebase Cloud Messaging ✅ Validated
- **Status:** Free. Reliable for push notifications on both iOS and Android.
- **Concern:** None for MVP.
- **Action:** Set up FCM project alongside Firebase Auth.

### Supabase ✅ Validated with concerns
- **Status:** Production-ready. Good for PostgreSQL + Auth + Realtime + Storage.
- **Concern 1:** Row-level security (RLS) policies can become complex with family-level access patterns. Need careful design.
- **Concern 2:** Supabase Realtime for multi-device sync adds cost at scale.
- **Concern 3:** Vendor lock-in. Supabase is built on PostgreSQL, so migration is possible but not trivial.
- **Alternative:** Consider self-hosted PostgreSQL + custom API from the start if the team has backend experience. Supabase is faster for MVP.
- **Action:** Start with Supabase Pro ($25/mo). Design RLS policies for family-level isolation during architecture phase.

### Cloudflare R2 ✅ Validated
- **Status:** S3-compatible. Cheapest object storage option. No egress fees.
- **Concern:** None for MVP.
- **Action:** Set up R2 bucket with encryption at rest.

### Meilisearch Cloud ✅ Validated with alternative
- **Status:** Good for keyword search. Typo-tolerant. Fast.
- **Concern:** Adding Meilisearch as a separate service increases infrastructure complexity. For MVP with < 1000 families, Drift FTS5 (local SQLite full-text search) may be sufficient for keyword search.
- **Recommendation:** Start with Drift FTS5 (local, zero cost, offline-capable). Add Meilisearch when cloud search is needed for cross-device queries or when local search performance degrades.
- **Action:** Defer Meilisearch to Sprint 3+. Use Drift FTS5 for MVP keyword search.

---

## Tier 2 APIs — Audit

### DigiLocker API ⚠️ Needs early action
- **Status:** Government API. Free but requires partner registration.
- **Concern:** API reliability is inconsistent (timeouts, downtime). Approval process is bureaucratic (2-4 weeks minimum, sometimes months). The "Family Locker" feature in development may change the API surface.
- **Action:** START THE APPLICATION PROCESS NOW. Don't wait for Sprint 5. The approval timeline is unpredictable. Apply in Phase 0/1 even though integration is post-MVP.

### WhatsApp Business API ⚠️ Defer but apply early
- **Status:** Requires Meta Business verification. Per-conversation pricing ($0.005-0.08 per conversation depending on type).
- **Concern:** Meta approval takes 2-4 weeks. Requires a verified business phone number and business manager account.
- **Recommendation:** Apply for Meta Business verification now. Build the bot in Sprint 5+.
- **Action:** Set up Meta Business Manager. Apply for WhatsApp Business API access. Don't block MVP on this.

### Razorpay ✅ Validated
- **Status:** Standard for Indian payments. 2% fee is reasonable.
- **Concern:** Requires KYC (1-2 weeks).
- **Action:** Start KYC process during Phase 4-5. Not needed until Sprint 7.

### Whisper API ✅ Validated but reconsider
- **Status:** Good for voice-to-text. $0.006/minute.
- **Concern:** Voice input is a nice-to-have, not MVP. Adding voice capture before the text/image pipeline is proven adds complexity.
- **Recommendation:** Defer to post-MVP. Focus on image/text capture first.

### Voyage/Cohere (Embeddings) ⚠️ Reconsider approach
- **Status:** Both work for semantic search embeddings.
- **Concern:** Adding a separate embedding service for semantic search in MVP is premature. At < 1000 items per family, keyword search (Drift FTS5) handles most queries well.
- **Recommendation:** Defer semantic search to Sprint 3+. When ready, consider Anthropic's own embeddings or OpenAI embeddings (cheaper, well-documented) alongside Voyage/Cohere.
- **Action:** Don't commit to an embedding provider yet. Evaluate when semantic search is actually needed.

---

## Missing APIs (not in CLAUDE.md)

### Sentry (Error tracking) — ADD to Tier 1
- **Why:** Essential for production monitoring. Catch crashes, AI pipeline failures, and UX errors before users report them.
- **Cost:** Free tier (5K events/mo), paid from $26/mo.
- **Action:** Set up Sentry from Sprint 1. Integrate with Flutter (sentry_flutter package).

### Mixpanel or PostHog (Analytics) — ADD to Tier 1
- **Why:** Need event tracking from day 1 to measure JTBD metrics (retrieval time, capture-to-confirm time, assistant accuracy).
- **Options:** PostHog (self-hostable, privacy-friendly), Mixpanel (better for funnel analysis), Amplitude.
- **Recommendation:** PostHog for DPDPA compliance (can self-host, no data leaving India).
- **Action:** Set up analytics in Sprint 1.

### RevenueCat or Purchases (In-App Subscriptions) — ADD to Tier 1
- **Why:** Razorpay handles web payments but for App Store/Play Store, you need Apple/Google in-app purchase integration. RevenueCat abstracts this.
- **Cost:** Free up to $2.5K MRR, then 0.8%.
- **Action:** Evaluate RevenueCat vs. direct StoreKit/Google Play Billing during Phase 5.

### Image preprocessing library — ADD to Tier 1
- **Why:** Before sending to Google Cloud Vision, documents need edge detection, perspective correction, contrast enhancement, and deskewing. Raw camera photos produce bad OCR.
- **Options:** OpenCV (via flutter_opencv or native plugin), custom Dart image processing, or cloud-based preprocessing.
- **Recommendation:** Use a Flutter camera scanning package (document_scanner, edge_detection) that handles preprocessing client-side before OCR.

---

## API readiness timeline

| API | When needed | Action now | Lead time |
|-----|-----------|-----------|-----------|
| Google Cloud Vision | Sprint 2 | Create GCP project, enable API | 1 day |
| Claude API | Sprint 2 | Create Anthropic account | 1 day |
| Firebase Auth + FCM | Sprint 1 | Create Firebase project | 1 day |
| Supabase | Sprint 1 | Create Supabase project | 1 day |
| Cloudflare R2 | Sprint 2 | Create Cloudflare account | 1 day |
| Sentry | Sprint 1 | Create Sentry account | 1 day |
| PostHog | Sprint 1 | Create PostHog account (or self-host) | 1-2 days |
| DigiLocker | Sprint 5+ | **APPLY NOW** | 2-8 weeks |
| WhatsApp Business | Sprint 5+ | **Apply for Meta verification now** | 2-4 weeks |
| Razorpay | Sprint 7 | Start KYC during Phase 5 | 1-2 weeks |

---

*Next: Orchestrator Audit → /docs/product/orchestrator-audit.md*
