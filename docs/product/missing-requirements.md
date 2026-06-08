# Cubby — Missing Requirements

> Phase 1 deliverable. Requirements not currently in CLAUDE.md.

---

## Critical missing requirements (must address before architecture)

### 1. Onboarding and vault-seeding flow
The app is useless at zero documents. The first 5 minutes determine retention.

Required:
- Step 1: Phone OTP sign-in (30 seconds)
- Step 2: Create family, add members by name + relationship (60 seconds)
- Step 3: "Seed your vault" — offer three paths: (a) bulk camera scan, (b) import from gallery, (c) connect DigiLocker
- Step 4: Watch AI process 3-5 items in real-time (the "wow moment")
- Step 5: Confirm AI-classified items in inbox
- First value: user sees a person's profile page populated with linked documents

Success metric: 80%+ of users who start onboarding complete vault seeding with at least 3 items.

### 2. Multi-device and multi-user sync
Two parents will use the app simultaneously. The spec mentions Supabase for sync but doesn't specify:
- Real-time updates (when Parent A adds a document, Parent B sees it immediately)
- Conflict resolution (last-write-wins? merge? prompt user?)
- Offline sync queue (what happens when both parents add items offline, then come online?)
- Device-specific state (which tab is open, scroll position — don't sync this)

### 3. Data migration / import
Families have existing documents scattered across:
- Google Drive / iCloud / Dropbox (PDFs, photos of documents)
- WhatsApp media gallery (screenshots, forwarded documents)
- Camera roll (photos of prescriptions, bills, certificates)
- Email attachments (booking confirmations, insurance policies)
- Physical papers (the hardest — requires scanning)

Required:
- Gallery import: select multiple photos → batch process through InboxOrchestrator
- Cloud import: connect Google Drive, select a folder → batch import
- Email forwarding: dedicated email address (familyname@familyos.in) that processes attachments
- Bulk scan mode: rapid-fire camera scanning with auto-edge-detection

### 4. Error handling and low-confidence flows
When AI classification confidence is below threshold:
- Show item in inbox with "Needs your help" badge
- Present top 3 classification suggestions for user to pick
- Ask "Who does this belong to?" with family member chips
- Learn from corrections to improve future classification

When OCR fails entirely:
- Still store the image/document
- Tag as "Unprocessed" with option to retry
- Allow manual metadata entry

When assistant can't answer:
- "I don't have enough information to answer that. Try adding more documents about [topic]."
- Never hallucinate. Ever.

### 5. Document viewing and detail screen
The spec focuses on ingestion and retrieval but doesn't spec the document detail view:
- Full-screen document viewer (pinch-to-zoom for images, PDF renderer for PDFs)
- Extracted metadata in a clean card below the document
- "Linked to: [person chips]" with ability to re-link
- "Category: [type badge]" with ability to re-classify
- "Dates found: [date chips]" (expiry, appointment, etc.)
- Share button (export original file, not the metadata)
- Delete with confirmation
- Edit metadata (title, notes, custom tags)

### 6. Notifications strategy
Beyond reminder notifications, define when the app should notify:
- "3 new items processed in your inbox" (batch, not per-item)
- "Arjun's passport expires in 30 days" (reminder)
- "[Parent B] added 5 documents" (family activity, configurable)
- Never: marketing, engagement nudges, "you haven't opened the app" — these violate the "calm" principle

### 7. Account management and family administration
- Invite family members via phone number or link
- Remove family members (with confirmation + option to transfer their items)
- Transfer family ownership (if primary parent changes)
- Account deletion (DPDPA compliance — must delete all data within 72 hours)
- Export all data (zip of all documents + metadata JSON)

### 8. Search result presentation
The spec says hybrid search but doesn't spec what results look like:
- Result card: document thumbnail + title + person pill + date + relevance snippet
- Group by person or by type (toggle)
- Filter chips: person, type, date range
- "No results" state with helpful suggestions

### 9. Settings and preferences
- Notification preferences (per category: reminders, family activity, inbox)
- Biometric lock toggle
- Default capture method
- Storage usage dashboard
- Connected accounts (DigiLocker, Google, Apple)
- Subscription management
- Language (English only Phase 1, but the setting should exist for future)

### 10. Family member detail editing
- Edit name, photo, date of birth, blood group, allergies, emergency contact
- For pets: species, breed, vet name, vet phone
- Medical conditions (visible on emergency card)
- Custom fields (user-defined key-value pairs for edge cases)

---

## Important but deferrable (post-MVP)

- Shared family notes (free-text notes linked to a person or event)
- Photo memories (non-document photos with timeline integration)
- Family tree visualization
- Bill tracking and payment reminders (UPI deep links)
- Medication interaction warnings (cross-reference multiple family members' prescriptions)
- Emergency mode (single screen showing critical info for all family members — blood groups, allergies, emergency contacts, insurance)
- Family analytics ("You added 47 documents this month, most were health-related")

---

*Next: Risks and Failure Modes → /docs/research/risks-and-failure-modes.md*
