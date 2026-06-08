# Cubby — Jobs To Be Done Analysis

> Phase 1 deliverable. What families are hiring Cubby to do.

---

## Core Jobs

### Job 1: "Help me find that document RIGHT NOW" (Retrieval under pressure)
**Context:** Standing at the hospital reception. At the immigration counter. School office asking for a certificate. Insurance company asking for a policy number.
**Current solution:** Scroll through WhatsApp, search camera roll, call spouse, go home to check the drawer.
**Emotional state:** Stressed, embarrassed, time-pressured.
**Hiring criteria:** Speed of retrieval. Must be < 10 seconds from app open to document on screen.
**Cubby solution:** Tap person → see all their documents → tap the one needed. Or ask assistant: "Show Aarav's vaccination card."
**Success metric:** Time from app open to document displayed < 10 seconds.

### Job 2: "Make sure I don't forget critical deadlines" (Proactive reminder)
**Context:** Passport expiring in 2 months. Car insurance renewal next week. Ria's vaccination due date. Medication refill needed.
**Current solution:** Mental note. Maybe a calendar reminder if someone remembers to set one. Often missed.
**Emotional state:** Anxious about forgetting. Relieved when reminded.
**Hiring criteria:** Automatic. Zero effort. Reliable. Timely (not too early, not too late).
**Cubby solution:** ReminderOrchestrator auto-detects dates from documents and generates reminders at appropriate intervals.
**Success metric:** Zero missed critical deadlines for active users.

### Job 3: "Get this document out of my hands and into a safe place" (Capture and forget)
**Context:** Just received a prescription from the doctor. Got a booking confirmation email. School sent Ria's report card. Downloaded insurance policy PDF.
**Current solution:** Photo in camera roll (lost in 1000 other photos). Forward to WhatsApp (buried in 50 messages). Save to Google Drive (wrong folder).
**Emotional state:** "I should save this properly" → "I'll do it later" → forgets.
**Hiring criteria:** Must be faster than taking a photo and saving to gallery. Zero cognitive overhead. No "which folder?" decisions.
**Cubby solution:** Share sheet → Cubby. Or camera scan. AI processes, classifies, links to the right person. User confirms with one tap.
**Success metric:** Capture-to-confirmed time < 30 seconds for share sheet, < 60 seconds for camera scan.

### Job 4: "Tell me what's going on with my family's health/school/documents" (Family intelligence)
**Context:** "When was Buddy's last vaccination?" "What medication is Aarav taking?" "Which documents expire this year?" "How many doctor visits did Priya have this year?"
**Current solution:** No solution. This information is scattered and aggregating it manually is impractical.
**Emotional state:** Curious, planning, sometimes worried.
**Hiring criteria:** Natural language query. Accurate answers. Cited sources (show me the actual document).
**Cubby solution:** AssistantOrchestrator — hybrid search + Claude-powered answers with citations.
**Success metric:** Assistant answers factual queries with > 95% accuracy, citing specific FamilyItems.

### Job 5: "Give me peace of mind that everything important is safe and organized" (Emotional security)
**Context:** Not a specific moment. An ongoing anxiety. "What if there's a fire?" "What if I lose my phone?" "What if something happens to me — will my family find the documents they need?"
**Current solution:** Physical backup copies. Mental inventory. Hope.
**Emotional state:** Background anxiety. Desire for control and preparedness.
**Hiring criteria:** Encrypted backup. Multi-device sync. Family access if something happens. Visible security.
**Cubby solution:** Cloud-synced, encrypted vault. Family member access with role-based permissions. Emergency card with critical info.
**Success metric:** User feels confident saying "Everything important is in Cubby."

---

## Supporting jobs

### Job 6: "Help me share documents with specific people securely" (Controlled sharing)
**Context:** Sharing insurance details with grandparents. Sending school certificates to the admissions office. Sharing pet records with the pet sitter.
**Current solution:** WhatsApp forward (uncontrolled). Email attachment (insecure). USB drive (physical).
**Cubby solution:** Share specific items or groups of items with specific people, with optional expiry.

### Job 7: "Show me my family's history over time" (Timeline/nostalgia)
**Context:** "When did we go to that Goa resort?" "When did Aarav start at this school?" "What was Ria's weight at her last checkup?"
**Current solution:** Scroll through photos. Check old calendar entries. Ask family members.
**Cubby solution:** Family Timeline — chronological view of all events, filterable by person.

### Job 8: "Help me prepare for an upcoming event" (Proactive preparation)
**Context:** Trip next week — do we have all passports? Doctor appointment tomorrow — bring last blood report. School admission — need birth certificate, photos, previous report cards.
**Current solution:** Manual checklist. Mental recall. "Did you remember to bring...?"
**Cubby solution:** (Future) Event-linked document checklists. "For your Goa trip, here are the documents you might need: passports (all valid), travel insurance (expires in 3 months), hotel booking confirmation."

---

## Job priority for MVP

| Priority | Job | MVP scope |
|----------|-----|-----------|
| 1 | Retrieval under pressure | People → documents → view. Assistant search. |
| 2 | Capture and forget | Camera scan + share sheet → InboxOrchestrator → confirm |
| 3 | Proactive reminders | ReminderOrchestrator auto-generates from dates |
| 4 | Family intelligence | Assistant with hybrid search + cited answers |
| 5 | Emotional security | Cloud sync + encryption + family access |

Jobs 6-8 are post-MVP.

---

*Next: Freemium Model Evaluation → /docs/product/freemium-evaluation.md*
