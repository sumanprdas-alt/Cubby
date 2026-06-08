# Cubby — Risks and Failure Modes

> Phase 1 deliverable. What can kill this product.

---

## Product risks

### RISK 1: Empty vault problem (Severity: Critical)
**What:** Users download the app, see an empty screen, don't know where to start, and churn within 24 hours.
**Why it's critical:** Every competitor suffers from this. The app delivers zero value until the user puts in effort. This is the #1 reason family apps fail.
**Mitigation:** Design a guided vault-seeding onboarding that gets 3-5 items in within the first session. DigiLocker auto-import for Indian users gives instant value. Bulk gallery import lets users select existing document photos.
**Metric:** Day-1 retention must exceed 60%. If below 40%, the product is dead.

### RISK 2: Ingestion friction despite AI (Severity: High)
**What:** Even with AI-powered inbox, the effort of photographing, scanning, or forwarding documents is too high. Users do it once during onboarding and never again.
**Why it's critical:** A vault that stops growing stops being useful. If families add 3 items at onboarding and never return, the product becomes a static archive, not an operating system.
**Mitigation:** Proactive capture prompts ("You visited Apollo Hospital yesterday — got any prescriptions?"). Email forwarding pipeline (zero-effort capture). Calendar integration surfaces upcoming events that might generate documents. Share sheet makes capture as easy as sharing to WhatsApp.
**Metric:** Items added per family per week must be > 2 after month 1. If < 1, the flywheel is broken.

### RISK 3: AI accuracy below trust threshold (Severity: High)
**What:** OCR misreads a passport number. Classification puts a prescription under "Insurance." Entity linking assigns Aarav's report card to Ria. User loses trust in AI and switches to manual everything, defeating the product's core value.
**Why it's critical:** One wrong classification in a critical moment (at hospital, at airport) destroys trust permanently.
**Mitigation:** Always show confidence scores. Never auto-confirm — everything goes through inbox with user confirmation. Invest heavily in AI eval datasets for Indian documents (messy handwriting, regional hospital formats, government document variations). Target > 90% classification accuracy before launch.
**Metric:** Inbox confirm-without-edit rate > 80%. If users edit more than 20% of AI classifications, the AI isn't good enough.

### RISK 4: Single-user syndrome (Severity: Medium)
**What:** One parent (usually the mother, based on family organizer research) does all the document management. The other parent and children never open the app. The product becomes a solo tool, not a family OS.
**Why it's critical:** Multi-user engagement is essential for retention and word-of-mouth. If only one person uses it, it's just a better Google Drive, not a family platform.
**Mitigation:** Family activity feed ("Priya added Aarav's report card"). Shared reminders. Role-appropriate views (children see their own items, not parents' financials). Make retrieval a multi-user action ("Ask dad to share the insurance card from Cubby").

### RISK 5: No habit loop (Severity: Medium)
**What:** Document management is not a daily activity. Users open the app only when they need a specific document (at the airport, at the hospital, at school). Between those moments, they forget Cubby exists.
**Why it's critical:** Low engagement = high churn = unsustainable business.
**Mitigation:** Smart reminders create recurring touchpoints. "Arjun's car insurance expires in 30 days." "Ria's vaccination is due next week." The assistant can surface proactive insights ("You have 3 passports expiring within 6 months"). Weekly digest notification summarizing family activity.

---

## Technical risks

### RISK 6: OCR quality for Indian documents (Severity: High)
**What:** Indian documents vary wildly — handwritten prescriptions, thermal-printed bills that fade, government certificates in mixed Hindi/English, school report cards with stamp marks and poor photocopies.
**Why:** Google Cloud Vision is optimized for clean printed English text. Real Indian documents are messy. OCR accuracy may be significantly lower than expected.
**Mitigation:** Build an eval dataset from real Indian documents (200+ samples across 10 document types). Benchmark Google Cloud Vision vs. alternatives. Accept that some document types will need manual fallback. Don't promise "zero effort" — promise "minimal effort."

### RISK 7: Claude API cost at scale (Severity: Medium)
**What:** At 1000 families doing 15 scans/month each, the AI cost is manageable (~$150/mo). But at 25,000 families (month 12 target), costs scale to ~$3,750/mo for classification alone, plus assistant queries.
**Why:** AI costs are variable per-user, not fixed infrastructure. Each new family adds marginal cost. If free-tier users generate disproportionate AI usage, unit economics break.
**Mitigation:** Implement aggressive caching (same document types produce similar classifications). Use lightweight rules for simple document types (passport = specific format = skip Claude). Rate-limit free-tier assistant queries (10/day). Track cost-per-family-per-month as a KPI from day 1. Consider fine-tuning a smaller model for classification once eval datasets are large enough.

### RISK 8: Client-side encryption key management (Severity: Medium)
**What:** The spec calls for client-side encryption before upload. This means encryption keys must be managed on-device. If a user loses their phone and hasn't set up backup, their documents are unrecoverable.
**Why:** Key management in consumer apps is notoriously hard. Users don't understand encryption. "My documents are gone" is a catastrophic trust failure.
**Mitigation:** Server-side encryption (AES-256 at rest, TLS in transit) is sufficient for MVP. Client-side encryption is a premium/Pro feature for users who explicitly want zero-knowledge storage. Don't make it the default.

### RISK 9: App Store rejection (Severity: Medium)
**What:** Apple App Store review may flag health data handling, biometric usage, or notification patterns. Google Play may flag document scanning permissions.
**Why:** Both stores have strict policies around health data (HealthKit requires specific privacy justifications) and camera/gallery access. Indian apps handling financial documents face additional scrutiny.
**Mitigation:** Prepare App Store privacy descriptions early. Justify every permission with clear user-facing copy. Submit a minimal build for review first to identify issues before the full launch.

---

## Market risks

### RISK 10: DigiLocker launches "Family Locker" (Severity: High)
**What:** DigiLocker is reportedly building a "Family Locker" feature that lets families share government documents within a single account. If launched with good UX, it eliminates a significant portion of Cubby's value proposition for Indian users.
**Why:** DigiLocker has 430M+ users in India. It's free. Government-backed. If it offers family sharing, the "store government documents" JTBD is solved.
**Mitigation:** Cubby must differentiate beyond document storage. The AI assistant, smart reminders, health tracking, and timeline features are the moat, not raw storage. DigiLocker won't build an AI assistant or proactive reminders. Position Cubby as "the brain" and DigiLocker as "the locker" — integrate, don't compete.

### RISK 11: Google/Apple builds a native family vault (Severity: Medium)
**What:** Apple already has Family Sharing, Health, and Wallet. Google has Family Link and Google Drive. Either could launch a unified "family documents" feature.
**Why:** Platform features are free, pre-installed, and deeply integrated. A native family vault would be nearly impossible to compete with on distribution.
**Mitigation:** Move fast. Build a loyal user base before platforms move. Focus on India/MEA-specific value (DigiLocker, Indian document types, Razorpay, Hindi prescriptions) that global platforms won't prioritize. The AI assistant layer is the defensible moat.

### RISK 12: Privacy backlash (Severity: Medium)
**What:** Indian families are sensitive about storing personal documents (Aadhaar, PAN, medical records) in a startup's app. "What if they get hacked?" is a real concern.
**Why:** India has seen high-profile data breaches. Trust in startups with personal data is low. DPDPA regulations add compliance burden.
**Mitigation:** Visible security indicators in the UI (lock icons, encryption badges). SOC 2 certification early. Transparent privacy policy in simple language. Option to self-host or use local-only mode. Never monetize user data.

---

## Regulatory risks

### RISK 13: DPDPA compliance (Severity: Medium)
India's Digital Personal Data Protection Act requires explicit consent for data processing, right to erasure, data portability, and breach notification. Cubby handles sensitive personal data (health records, identity documents, financial information) which triggers higher compliance requirements.
**Mitigation:** Build consent management into onboarding. Implement account deletion with full data erasure within 72 hours. Maintain audit logs. Designate a Data Protection Officer before launch.

### RISK 14: Storing children's data (Severity: Medium)
DPDPA has specific provisions for children's data (verifiable parental consent). Cubby stores children's school records, health records, and identity documents.
**Mitigation:** The family creation flow inherently provides parental consent (parent creates the family, adds children). Document this in the privacy policy. Restrict children's role to read-only by default.

---

*Next: Competitive Landscape → /docs/research/competitive-landscape.md*
