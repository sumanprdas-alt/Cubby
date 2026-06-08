# Cubby — Product Critique

> Phase 1 deliverable. Challenges assumptions in CLAUDE.md.

---

## What the spec gets right

The three architectural bets — entities not folders, inbox-first capture, assistant as primary interface — are the strongest ideas in the spec. They represent genuine differentiation from every competitor in the market. No family app today does all three.

The insight that the problem is "remembering, organizing, retrieving, acting" rather than storage is correct. Storage is solved. Retrieval is not.

The decision to treat pets as equal family members (type:pet) is smart. It simplifies the data model, simplifies pricing, and avoids awkward UX around "add a pet" being a second-class flow.

---

## Assumptions that need challenging

### 1. "AI assistant is the primary interface" may not match real behavior

The spec says search > navigation and positions the assistant as the main way people interact. But family document retrieval is often contextual and urgent — "show me the insurance card NOW at the hospital reception." In these moments, people will not type a query. They'll want to tap a person → see their documents → tap the one they need. Three taps, zero typing.

**Recommendation:** The assistant should be a power-user feature and a discovery mechanism, not the primary interface. Navigation (people → documents) is the primary path for urgent retrieval. Assistant is for complex queries ("which passports expire this year?") and ambient discovery.

### 2. Inbox-first assumes families will change behavior

The spec assumes families will "toss things into the inbox" regularly. But document capture is not a daily habit for most families. It happens in bursts: post-hospital visit, post-travel, post-school-results-day, when renewing insurance. The inbox will be empty most days.

**Recommendation:** Design for burst capture, not daily drip. The onboarding should focus on a "vault seeding" session where families dump 20-30 existing documents in one sitting. Post-onboarding, the inbox should surface proactively — "You visited Dr. Mehta yesterday. Got a prescription to scan?"

### 3. Nine modules is too many for a founding team

Family Profiles, Smart Vault, Family Inbox, Family Timeline, Family Assistant, Reminders, Health Hub, Education Hub, Travel Hub. That's nine modules before a single line of code. Even with the MVP scoping Phase 3 down, the cognitive overhead of designing for nine modules influences architecture decisions prematurely.

**Recommendation:** MVP should have exactly four surfaces: Inbox, People (with linked items), Assistant, and Reminders. Health/Education/Travel are just filtered views of a person's FamilyItems, not separate modules. The "hub" concept adds navigation complexity that contradicts Principle 3.

### 4. Offline-first with AI-core creates a fundamental tension

The spec says "offline-first: full functionality without connectivity" and also "AI is core — every document is OCR'd, classified, entity-extracted." These two statements are in direct conflict. OCR, classification, entity extraction, and assistant queries all require API calls. Offline-first means the AI pipeline cannot run.

**Recommendation:** Reframe as "offline-resilient" rather than "offline-first." The app works offline for browsing, searching (local FTS), and viewing existing items. AI processing queues offline and runs when connectivity returns. The assistant degrades gracefully to local search when offline.

### 5. The ₹149/mo price point may be too high for Indian Tier 2

The spec targets Tier 1 and Tier 2 cities. In Tier 2 India, ₹149/mo is a meaningful spend for a utility app. Spotify Premium is ₹119/mo. Netflix Mobile is ₹149/mo. Competing with entertainment subscriptions for wallet share is hard. Families may not perceive document management as worth the same as streaming entertainment.

**Recommendation:** Consider ₹99/mo for the Family tier and ₹199/mo for Pro. Or offer a lifetime plan (₹2,999 one-time) for price-sensitive Tier 2 users who resist recurring charges. A/B test during beta.

### 6. The spec underestimates the onboarding cliff

The biggest risk is not ingestion friction during use — it's the initial vault-seeding experience. A family downloading Cubby has zero documents in it. The app is empty and useless. The time from download to "first value moment" is critical. If it takes more than 5 minutes to see the app do something magical, they'll churn.

**Recommendation:** The onboarding must deliver a "wow moment" within 90 seconds. Options: (a) connect DigiLocker and auto-pull government documents, (b) bulk-scan 5 documents from camera roll, (c) forward one WhatsApp message and watch AI process it instantly. The first session should end with at least 5 items in the vault.

### 7. WhatsApp as an ingestion channel is overestimated for MVP

The spec positions WhatsApp forwarding as a key capture channel. But WhatsApp Business API requires Meta approval (2-4 weeks), per-conversation pricing, and a verified business number. For MVP, this adds complexity without proportional user value.

**Recommendation:** Defer WhatsApp bot to Sprint 5+. For MVP, the share sheet (system-level share from any app including WhatsApp) gives 80% of the same benefit with 10% of the effort. Users share a WhatsApp image → Cubby processes it. No bot needed.

### 8. "Apple Wallet-inspired" design may confuse in India/MEA

Apple Wallet is a strong design reference for card-based, glanceable UI. But Apple Wallet penetration in India is low compared to Google Pay / PhonePe. The mental model of "wallet = cards I flip through" may not resonate with the ICP the way it does in the US.

**Recommendation:** Keep the card-based, glanceable aesthetic, but reference it internally as "card-stack" not "wallet." The UX metaphor for Indian users should be more like "everything about Arjun, at a glance" than "flip through your wallet."

---

## Critical gaps in the spec

1. **No onboarding flow specified.** This is the highest-risk UX surface and it's not mentioned.
2. **No data migration path.** How do families move existing documents from Google Drive, iCloud, or WhatsApp into Cubby?
3. **No multi-device story.** What happens when both parents use the app? Who sees what? Real-time sync UX?
4. **No deletion/archival policy.** What happens to old documents? Auto-archive after X years?
5. **No conflict resolution.** When two parents edit the same item simultaneously, who wins?
6. **No export/portability.** The spec mentions "data portability" under security but doesn't spec the export format or flow.
7. **No error states.** What does the user see when OCR fails? When classification confidence is low? When the assistant can't find an answer?
8. **No notification strategy beyond reminders.** When should the app interrupt the user vs. stay silent?

---

*Next: Missing Requirements → /docs/product/missing-requirements.md*
