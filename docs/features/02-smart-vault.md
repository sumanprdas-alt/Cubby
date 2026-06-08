# Feature Spec: Smart Vault

> Module 2. Entity-linked document storage, auto-organized by AI.

---

## Goals
- Store all family documents with zero folder management
- Every item linked to one or more family members automatically
- Fast retrieval: find any document in < 10 seconds

## User stories
- As a parent, I want all documents organized by person so I find Arjun's visa by going to Arjun, not "Travel Documents"
- As a user, I want to view any document full-screen with pinch-to-zoom
- As a user, I want to search across all documents by keyword
- As a parent, I want to see how much storage I'm using
- As a user, I want to edit a document's title, type, or person link if AI got it wrong
- As a user, I want to share a document from Cubby to WhatsApp, email, or any app so I can send it to someone who needs it
- As a user, I want to delete documents I no longer need
- As a user, I want to add notes to a document for context

## User flow
**Browse vault:** Home → scroll items grouped by recent, or People → member → see their items grouped by type (identity, health, education, travel, insurance, other)

**View document:** Tap item → Document detail screen: full-screen image/PDF viewer (pinch-to-zoom), metadata card below (type badge, title, extracted fields, linked members as chips, dates, notes), action buttons (Edit, Share, Delete)

**Edit item:** Detail screen → Edit → change title, type, linked persons, notes, tags → Save

**Delete item:** Detail screen → Delete → "Are you sure? This will be permanently removed after 30 days." → Confirm → soft-delete

**Search:** Search bar → type query → FTS5 results with snippets → tap result → detail screen

## Edge cases
- Item linked to multiple people (e.g., family health insurance policy) → shows under all linked members
- Document with no extractable text (blurry photo) → stored with "Unclassified" type, user can manually edit
- PDF documents → rendered via PDF viewer, not image viewer
- Very large images (> 10MB) → compressed before storage, original available on demand
- Storage limit reached → banner: "You've used 500MB. Upgrade for more storage." Block new captures until upgraded or items deleted.
- Duplicate detection → "This looks similar to [item]. Is it a duplicate?" → user confirms or keeps both

## Acceptance criteria
- [ ] Items display as cards with: thumbnail, title, type badge, linked member chips, date
- [ ] Tapping item opens full-screen viewer (image: pinch-to-zoom, PDF: rendered pages)
- [ ] Metadata card below viewer shows all extracted fields
- [ ] Items can be edited: title, document_type, linked persons, notes, tags
- [ ] Items can be deleted with 30-day soft-delete recovery
- [ ] Items can be shared (export original image/PDF)
- [ ] Items are searchable via FTS5 (title, type, extracted text, notes, tags, member names)
- [ ] Storage usage displayed in Settings
- [ ] Free tier enforces 500MB limit

## Analytics events
- `item_viewed` { document_type, source_screen }
- `item_edited` { fields_changed }
- `item_deleted` { document_type }
- `item_shared` { document_type, method }
- `storage_limit_shown`

## Permissions requirements
- Parents see all items. Children see only items linked to themselves.
- Only item creator or parents can edit/delete items.

## AI requirements
- Items classified and entity-linked by InboxOrchestrator before entering vault
- FTS5 index includes AI-extracted text for searchability

## Success metrics
| Metric | Target |
|--------|--------|
| Items per family (month 3) | ≥ 15 |
| Items per family (month 6) | ≥ 40 |
| Document retrieval time | < 10 seconds (tap to view) |
| Search success rate | > 70% (user finds what they need) |
