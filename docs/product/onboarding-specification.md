# Cubby — Onboarding Flow Specification

> Addresses the #1 product risk: the empty vault problem.
> Designed for Dubai beta launch. English-speaking families.

---

## Goal

A new user goes from download → first "wow moment" in under 5 minutes.
By the end of onboarding, the family has at least 3 classified, entity-linked items in their vault.

---

## Success metrics

| Metric | Target |
|--------|--------|
| Onboarding completion rate | > 70% |
| Time from app open to first item confirmed | < 3 minutes |
| Items in vault after first session | ≥ 3 |
| Day-1 retention (return within 24 hours) | > 60% |
| Day-7 retention | > 40% |

---

## Flow

### Screen 1: Welcome (5 seconds)
- Cubby logo + tagline: "Your family's everything, in one place."
- Single button: "Get started"
- No sign-up wall. Let them see what it does first.

### Screen 2: Sign in (30 seconds)
- Phone number input with UAE country code pre-selected (+971)
- "Send OTP" → 6-digit code → auto-verify
- Fallback: "Sign in with Google" / "Sign in with Apple"
- After auth: "Welcome! Let's set up your family."

### Screen 3: Create your family (60 seconds)
- Family name field (pre-filled with "The [surname] Family" from auth profile if available)
- "Who's in your family?" — add members as cards:
  - Tap "Add member" → Name + Relationship picker (Spouse, Child, Parent, Grandparent, Pet)
  - For pets: species picker (Dog, Cat, Bird, Fish, Other)
  - Each member gets an auto-assigned color avatar (initial letter)
  - Minimum: 1 member besides self. Maximum: free tier limit (4 total including self).
- "You can add more later" — don't block progress

### Screen 4: The magic moment — "Toss in your first document" (90 seconds)
This is the most important screen in the entire app.

- Headline: "Let's see the magic. Grab any family document."
- Three capture options as large tappable cards:
  1. **📷 Take a photo** — opens camera with document edge detection
  2. **🖼 Pick from gallery** — opens photo picker (multi-select enabled for bulk)
  3. **📄 Share from another app** — shows instructions: "In WhatsApp or any app, tap Share → Cubby"
- Subtext: "Passport, visa, prescription, school report, insurance — anything works."

**What happens after capture:**
1. Image appears on screen with a subtle scanning animation
2. "Reading your document..." (1-3 seconds — Claude Vision API call)
3. Results appear in a card:
   - Document type badge (e.g., "🛂 Passport", "💊 Prescription", "📋 Insurance Policy")
   - Extracted key fields (name, expiry date, ID number — whatever Claude found)
   - "Belongs to: [family member chips]" — AI's best guess, tappable to change
   - Confidence indicator (subtle, not a percentage — just "✓ High confidence" or "Review suggested")
4. Two buttons: **"Looks good ✓"** (confirms) or **"Edit"** (opens edit form)

If the user taps "Looks good" — celebration micro-animation. Item slides into the vault.

### Screen 5: "Add a couple more?" (60 seconds, optional but encouraged)
- "Nice! That's your first item. Families with 5+ items get the most out of Cubby."
- Same capture interface — camera, gallery (multi-select), or share
- Counter: "2 of 3 items added" with a gentle progress indicator
- Each item processes and confirms inline (no separate screens)
- "Skip for now" always visible — never trap the user

### Screen 6: Your family is ready (10 seconds)
- Shows the family home screen with:
  - Family members across the top (avatar chips)
  - The items they just added, linked to the right people
  - One smart reminder if any dates were extracted ("Arjun's visa expires in 47 days")
  - Assistant bar at bottom: "Try asking: When does our visa expire?"
- "Start exploring ↓" — drops them into the live app

---

## Capture flow detail (reused throughout the app, not just onboarding)

### Camera capture
1. Camera opens with document edge detection overlay (rectangle guide)
2. Auto-capture when document is steady and edges are detected (or manual shutter button)
3. Crop/rotate review screen (keep it fast — auto-crop should be good enough 90% of the time)
4. "Processing..." → Claude Vision API → results card

### Gallery import (bulk)
1. System photo picker opens with multi-select enabled
2. User selects 1-10 images
3. Each image processes sequentially through InboxOrchestrator
4. Results appear as a scrollable list of cards, each with confirm/edit
5. "Confirm all" button at bottom for batch confirmation

### Share sheet capture
1. User shares an image/PDF from any app (WhatsApp, email, browser) to Cubby
2. App opens to inbox with the shared item processing
3. Same results card and confirm/edit flow

---

## OnboardingOrchestrator pipeline

```
Step 1: Auth
  → Firebase Phone OTP or Google/Apple sign-in
  → Create user record in Supabase
  
Step 2: Family setup
  → Create Family entity
  → Create FamilyMember entities (self + added members)
  → Store locally in Drift + sync to Supabase
  
Step 3: First capture
  → User takes photo / picks from gallery
  → Image sent to Claude Vision API (multimodal):
      System prompt: "You are Cubby document classifier. 
      Read this document image. Return JSON with:
      - document_type (passport | visa | emirates_id | health_card | 
        prescription | lab_report | insurance | school_report | 
        tenancy_contract | vehicle_registration | vaccination_record |
        booking_confirmation | certificate | bill | receipt | other)
      - confidence (high | medium | low)
      - extracted_fields: { key: value } — dates, names, numbers, amounts
      - suggested_person: name if identifiable from document
      - expiry_date: if found
      - title: short descriptive title"
  → Parse response
  → Match suggested_person against family members (fuzzy name match)
  → Create FamilyItem with status 'pending'
  → Show results card for user confirmation

Step 4: Confirm
  → User taps "Looks good" or edits
  → FamilyItem status → 'confirmed'
  → If dates found → ReminderOrchestrator creates reminders
  → If user corrected classification → FeedbackOrchestrator stores correction
  → Sync to Supabase

Step 5: Repeat for 2-3 more items

Step 6: Land on home screen
  → Show populated family view
  → Items linked to people
  → Reminders visible if dates were found
```

---

## Dubai-specific document types

The AI classifier should be tuned for these Dubai/UAE document types in the beta:

| Document type | Common formats | Key fields to extract |
|--------------|---------------|----------------------|
| Emirates ID | Card photo (front/back) | Name, ID number, expiry date, nationality |
| Visa | PDF or photo | Name, visa number, expiry date, sponsor, visa type |
| MOHAP Health Card | Card photo | Name, card number, insurance provider |
| Tenancy contract (Ejari) | PDF | Property, landlord, tenant, start/end dates, rent amount |
| School report | PDF or photo | Student name, school, grade, term, marks |
| Insurance policy | PDF | Policy number, insurer, coverage type, expiry, premium |
| Vehicle registration (Mulkiya) | Card photo | Owner, plate number, make/model, expiry |
| Prescription | Photo (often handwritten) | Patient name, medications, doctor name, date |
| Lab report | PDF or photo | Patient name, tests, results, date, lab name |
| Vaccination record | Card or PDF | Name, vaccine, date, next due, clinic |
| Booking confirmation | Email screenshot or PDF | Hotel/airline, dates, confirmation number, passenger names |
| Pet vaccination | Card or PDF | Pet name, vaccine, date, vet name, next due |

---

## Error handling during onboarding

| Scenario | User sees |
|----------|----------|
| Claude API timeout | "Taking a moment to read this... try again?" with retry button |
| Low confidence classification | Card with "We're not 100% sure — is this a [type A] or [type B]?" with tappable options |
| Can't identify any text | "We couldn't read this clearly. You can add details manually." with edit form |
| No person match found | "Who does this belong to?" with family member chips |
| Network offline during capture | Image saved locally. "We'll process this when you're back online." Badge on inbox. |

---

## Post-onboarding hooks (first 7 days)

| Day | Notification | Purpose |
|-----|-------------|---------|
| Day 0 (evening) | "Your family vault has [N] items. Add a few more to unlock smart reminders." | Re-engage same day |
| Day 1 | "💡 Tip: Share any document from WhatsApp → Cubby. We'll sort it automatically." | Teach share sheet |
| Day 3 | "📋 [Name]'s [document] expires in [X] days." (if applicable) | Show reminder value |
| Day 5 | "Try asking Cubby: 'When does our insurance expire?'" | Teach assistant |
| Day 7 | Nothing (respect the calm principle) | — |

No more than 1 notification per day. Never "you haven't opened the app" guilt notifications.

---

*This onboarding flow is a first-class product surface — it gets the same design attention as the home screen.*
