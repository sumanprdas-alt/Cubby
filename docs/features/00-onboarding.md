# Feature Spec: Onboarding

> Module 0. First-run experience. The highest-stakes screen in the app.

---

## Goals
- Get new user from download to "wow moment" in under 5 minutes
- Seed vault with ≥ 3 classified, entity-linked items in first session
- Establish trust through visible AI competence and security indicators
- Minimize drop-off at each step

## User stories
- As a new user, I want to sign up with my phone number so I don't need to remember a password
- As a parent, I want to set up my family quickly so I can start adding documents
- As a new user, I want to see AI classify my first document instantly so I understand the product's value
- As a user who's unsure, I want to skip optional steps so I'm not trapped in a long setup flow

## User flow
1. Welcome screen → "Get started"
2. Phone OTP (UAE +971 pre-selected) → verify → signed in
3. Create family: name + add members (name, relationship, pet species if pet)
4. "Toss in your first document" — camera / gallery / share sheet
5. AI processes (1-3 sec) → results card with type, fields, person → confirm or edit
6. "Add a couple more?" — repeat capture 2 more times (skippable)
7. Land on populated home screen with items linked to people + any detected reminders

## Edge cases
- User has no documents on hand → show "You can add later. Here's what Cubby does:" → demo with sample data, then drop into empty home
- OTP delivery fails → retry button, option for Google/Apple sign-in
- AI classification is completely wrong → easy edit form, correction stored in FeedbackOrchestrator
- User adds 0 members beyond self → allowed, but prompt "Add family members anytime in Settings"
- User tries to add more members than free tier allows (4) → show paywall with "Unlock more with Family plan"
- Network drops during AI processing → save image locally, show "We'll process this when you're back online"
- User kills app mid-onboarding → resume where they left off (state persisted locally)

## Acceptance criteria
- [ ] Onboarding completes in < 5 minutes for a user adding 3 items
- [ ] Phone OTP works for UAE (+971) numbers
- [ ] Family creation supports 1-4 members (free tier) with name + relationship
- [ ] Pets can be added with species selector
- [ ] Camera capture produces clear image with edge detection guide
- [ ] Gallery picker supports multi-select (up to 10)
- [ ] AI classification returns results within 5 seconds
- [ ] Results card shows: document type badge, extracted fields, suggested person, confidence
- [ ] User can confirm (one tap) or edit (opens form) each item
- [ ] Confirmed items appear on home screen linked to correct family members
- [ ] Dates extracted by AI generate reminders automatically
- [ ] Onboarding state persists across app kill/restart
- [ ] "Skip" is available at every optional step
- [ ] Post-onboarding notifications fire on days 1, 3, 5 only

## Analytics events
- `onboarding_started`
- `onboarding_auth_completed` { method }
- `onboarding_family_created` { member_count, has_pets }
- `onboarding_first_capture` { source }
- `onboarding_item_confirmed` { was_edited, document_type }
- `onboarding_completed` { items_count, duration_seconds }
- `onboarding_abandoned` { step, duration_seconds }

## Permissions requirements
- Camera permission (requested at capture step, not earlier)
- Photo gallery permission (requested at capture step)
- Notification permission (requested after onboarding completion)

## AI requirements
- Claude Vision multimodal classifies captured documents
- Confidence ≥ medium for auto-suggestion of person link
- System prompt tuned for Dubai/UAE document types
- Eval: 200+ Dubai document samples, F1 > 85% on classification

## Success metrics
| Metric | Target |
|--------|--------|
| Onboarding completion rate | > 70% |
| Items added in first session | ≥ 3 (median) |
| Time to first confirmed item | < 3 minutes |
| D1 retention (users who return) | > 60% |
| Auth step drop-off | < 15% |
| Capture step drop-off | < 25% |
