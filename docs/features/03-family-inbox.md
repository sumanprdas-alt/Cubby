# Feature Spec: Family Inbox

> Module 3. AI-powered capture and classification.

---

## Goals
- Make adding documents effortless: capture → AI processes → user confirms
- Support multiple capture channels: camera, gallery, share sheet
- Build user trust in AI through transparent confidence and easy corrections

## User stories
- As a user, I want to photograph a document and have AI tell me what it is
- As a user, I want to share an image from WhatsApp and have it processed automatically
- As a user, I want to select multiple photos from my gallery for batch processing
- As a user, I want to confirm or correct AI classifications with one tap
- As a user, I want to see all unprocessed items in one place
- As a user offline, I want to capture a document and have it processed when I'm back online

## User flow
**Camera capture:** Capture button (FAB or tab) → camera with edge detection overlay → auto or manual shutter → crop/rotate review → "Processing..." (1-3 sec) → results card in inbox

**Gallery import:** Capture → "From gallery" → multi-select photos → each processes sequentially → results appear as scrollable cards → "Confirm all" or individual confirm/edit

**Share sheet:** From any app (WhatsApp, email, browser) → Share → Cubby → app opens to inbox with item processing

**Inbox review:** Inbox tab → list of pending items (newest first) → each card shows: type badge, title, source indicator, linked person chip, confidence indicator → expand to see extracted fields → "Confirm ✓" or "Edit ✏️" or "Discard 🗑"

**Batch confirm:** When multiple items pending → "Confirm all (5 items)" button at bottom

## Edge cases
- AI timeout (> 10 sec) → "Taking longer than usual... try again?" with retry
- Confidence: low → card styled differently, "We need your help" badge, show top 2-3 type suggestions as tappable chips
- Document is not a document (photo of a sunset) → type: "other", confidence: low, let user discard
- Same document captured twice → DuplicateDetectionOrchestrator flags, "This looks similar to [item]. Keep or discard?"
- Item pending for > 30 days without confirmation → auto-archive with notification
- 10+ items pending → inbox becomes scrollable with count badge on tab
- Offline capture → image saved locally, "queued" badge, processes when online

## Acceptance criteria
- [ ] Camera opens with document edge detection overlay
- [ ] Gallery picker supports multi-select (up to 10 images)
- [ ] Share sheet integration receives images and PDFs from other apps
- [ ] AI classification completes within 5 seconds (online)
- [ ] Results card shows: type badge, title, extracted fields, suggested person, confidence
- [ ] One-tap confirm moves item to vault (status: confirmed)
- [ ] Edit form allows changing: title, type, linked persons, extracted fields
- [ ] Discard removes item permanently
- [ ] Batch confirm available when 2+ items pending
- [ ] Offline capture saves locally with "queued" indicator
- [ ] Queued items process automatically when connectivity returns
- [ ] User corrections stored in UserCorrection table (FeedbackOrchestrator)
- [ ] Inbox badge shows pending count on tab bar

## Analytics events
- `capture_started` { source: camera|gallery|share_sheet }
- `capture_completed` { source, image_count }
- `item_ai_processed` { document_type, confidence, duration_ms }
- `item_confirmed` { was_edited, corrections }
- `item_discarded` { document_type }
- `batch_confirmed` { count }
- `duplicate_detected` { action: kept|discarded }
- `offline_capture` { }
- `offline_items_processed` { count }

## Permissions requirements
- All family members with app access can capture and confirm items
- Camera and gallery permissions requested at first capture, not at install

## AI requirements
- Claude Vision (multimodal) classifies in single API call
- System prompt tuned for Dubai/UAE document types
- Confidence levels mapped to UI: high → auto-suggest, medium → suggest with review prompt, low → ask user
- Eval: classification F1 > 85%, field extraction accuracy > 80%

## Success metrics
| Metric | Target |
|--------|--------|
| Capture-to-confirmed time | < 30 seconds (share sheet), < 60 seconds (camera) |
| Confirm-without-edit rate | > 80% (proxy for AI accuracy) |
| Items captured per family/week | > 2 (after month 1) |
| Offline queue processing success | > 95% |
