# Cubby — Competitive Landscape

> Phase 1 deliverable. Direct and indirect competitors.

---

## Direct competitors (family organization apps)

### Cozi
- **What it does:** Shared family calendar, shopping lists, to-do lists, meal planner, recipe box
- **Users:** 12M+ families (primarily US/Western markets)
- **Pricing:** Free with Cozi Gold (~$40/yr) for ad-free + premium features
- **Strengths:** Established brand, simple, works for basic calendar sharing
- **Weaknesses:** 2.1-star Trustpilot rating. Manual entry for everything. No document storage. No AI. No OCR. Aging UI. Cut free tier in 2024 causing user exodus.
- **Threat to Cubby:** Low. Different problem space. Cozi is a calendar, not a vault.

### Nori
- **What it does:** AI-powered family organizer — voice, photo, email input for calendar, tasks, meals
- **Users:** 20,000+ families, 1M+ events scheduled
- **Pricing:** Freemium (details unclear)
- **Strengths:** AI-first input (voice, photo, email forwarding). Auto-detects events from email. Modern UX.
- **Weaknesses:** Calendar-focused, not document-focused. No vault/storage. No entity-based architecture. No health or document management.
- **Threat to Cubby:** Medium. Nori validates the "AI auto-detects from email" approach that Cubby's InboxOrchestrator does. But Nori is a calendar tool, not a document/vault tool. Watch closely.

### FamilyWall
- **What it does:** Shared calendar, tasks, location tracking, messaging
- **Pricing:** Premium from $4.99/mo
- **Strengths:** Location sharing (family safety angle). Messaging built in.
- **Weaknesses:** Manual entry. No document management. No AI. Not India-focused.
- **Threat to Cubby:** Low.

### Homsy
- **What it does:** Household task management — chore tracking, shared calendar, meal planning
- **Strengths:** Excellent at making household work visible and shared (addresses mental load problem)
- **Weaknesses:** Chore/task focused. No document storage or management.
- **Threat to Cubby:** Low. Different problem space.

### FamCal
- **What it does:** Family calendar with color-coding, no email required for kids
- **Strengths:** Simple, family-friendly. Good for families with young children.
- **Weaknesses:** Calendar only. Manual entry. No intelligence.
- **Threat to Cubby:** Low.

---

## Direct competitors (document storage for families — India)

### DigiLocker (Government of India)
- **What it does:** Digital wallet for government-issued documents (Aadhaar, PAN, driving license, education certificates)
- **Users:** 430M+ (India only)
- **Pricing:** Free
- **Strengths:** Government-backed. 9.4 billion documents issued. Trusted. Pre-loaded with government documents via API. "Family Locker" feature reportedly in development.
- **Weaknesses:** Government documents only. No private documents (prescriptions, insurance, bills). Terrible UX. Individual accounts only (no family sharing today). No AI. No search beyond basic. No reminders. No timeline.
- **Threat to Cubby:** HIGH for government document storage. LOW for everything else. Strategy: integrate with DigiLocker, don't compete. Pull government documents into Cubby automatically.

### Smarana
- **What it does:** Digital document vault with secure storage, AI organization, legacy planning, timeline views
- **Users:** Unknown (India-focused startup, launched 2025)
- **Pricing:** Free + premium (₹500-5,000/yr)
- **Strengths:** India-focused. Device-level encryption. Legacy/estate planning (unique feature). AI auto-tagging. Offline-capable. Positioned against DigiLocker.
- **Weaknesses:** Individual-focused, not truly family-first. No entity-based architecture. No AI assistant with natural language queries. No smart reminders from document metadata. No inbox-first capture flow.
- **Threat to Cubby:** MEDIUM-HIGH. Closest direct competitor in India. Smarana is solving the same "store important documents" problem. But Cubby's entity model, AI assistant, and family-first design are differentiated.

### Lakshmi Vaults
- **What it does:** Document and password vault with family sharing
- **Pricing:** Free
- **Strengths:** Family sharing built in. Password manager included. AWS-backed encryption.
- **Weaknesses:** Minimal AI. Basic storage. Small user base. Limited features.
- **Threat to Cubby:** Low.

### Famli
- **What it does:** Family wealth management — track mutual funds, bank accounts, cards, loans. AI insights and goal planning.
- **Users:** Unknown (India-focused, SEBI-registered)
- **Pricing:** Unknown
- **Strengths:** Financial focus with family context. Document vault included. AI insights. Indian market specific.
- **Weaknesses:** Finance-focused, not general family administration. Doesn't handle health, education, or travel documents meaningfully. Wealth management is a narrower wedge.
- **Threat to Cubby:** Medium. Famli owns the "family financial documents" space. Cubby should not try to compete on financial advice/tracking. Instead, complement — store the documents, don't analyze the finances.

---

## Indirect competitors (how families solve this today)

### WhatsApp groups / forwards
- **How families use it:** Forward booking confirmations, prescriptions, school notices to a "family group." Screenshot important documents and save to gallery.
- **Why it works:** Zero friction. Everyone already uses WhatsApp.
- **Why it fails:** Impossible to search. Documents buried in chat history. No organization. No reminders. Images compress and lose quality.
- **Cubby strategy:** Make WhatsApp a capture channel (share sheet), not a competitor. "Stop scrolling through WhatsApp looking for that document. Forward it to Cubby once, find it forever."

### Google Drive / iCloud / Dropbox
- **How families use it:** Create folders for "Important Documents," scan and upload PDFs.
- **Why it works:** Reliable storage. Cross-device sync. Free tier is generous.
- **Why it fails:** Folder management is manual. No intelligence. No reminders. No entity linking. Finding "Aarav's vaccination record" means remembering which folder it's in.
- **Cubby strategy:** "Google Drive stores your files. Cubby understands your family."

### Physical folders and drawers
- **How families use it:** Plastic folders labeled "Insurance," "School," "Medical." Filed in a drawer or cupboard.
- **Why it works:** Simple. Tangible. No technology barrier.
- **Why it fails:** Not accessible when away from home. Fire/flood risk. Can't search. Can't share. Can't remind.
- **Cubby strategy:** The digitization value prop is strongest here. Target families who still use physical files as the ICP most likely to experience a "wow moment."

### Apple Notes / Google Keep
- **How families use it:** Quick notes about appointments, medication schedules, emergency contacts.
- **Why it works:** Fast. Simple. Syncs across devices.
- **Why it fails:** Unstructured. No document scanning. No AI classification. No entity linking.
- **Cubby strategy:** Replace the scattered notes with structured, searchable, entity-linked data.

---

## Competitive positioning map

```
                    Family-first ←————————————→ Individual
                    
    AI-powered  ↑   [Cubby]                  [Smarana]
                |   [Nori]                       
                |                                [Famli]
                |   
                |   [Homsy]     [Cozi]           [DigiLocker]
                |   [FamilyWall][FamCal]         [Google Drive]
    Manual      ↓                                [Lakshmi Vaults]
```

Cubby occupies a unique position: AI-powered AND family-first. No competitor is in this quadrant today.

---

*Next: Product Moat Analysis → /docs/research/product-moat-analysis.md*
