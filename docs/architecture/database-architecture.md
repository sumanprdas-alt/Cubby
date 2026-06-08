# Cubby — Database Architecture & Entity Relationship Model

> Step 2 deliverable.

---

## Database strategy

**Local (Drift/SQLite):** Primary data store. All reads and writes go through Drift. App works fully offline from this database.

**Remote (Supabase/PostgreSQL):** Sync target. Mirrors local data for multi-device access, backup, and server-side queries. Row-level security isolates families.

**Object storage (Cloudflare R2):** Document images and files. Referenced by URL in FamilyItem records.

---

## Entity relationship model

```
┌─────────────┐
│   Family     │
│─────────────│
│ id (UUID)    │
│ name         │
│ created_at   │
│ created_by   │◄──── owner (User)
│ plan_tier    │      free | family | pro
│ storage_used │
└──────┬──────┘
       │ 1:N
       ▼
┌──────────────────┐
│  FamilyMember     │
│──────────────────│
│ id (UUID)         │
│ family_id (FK)    │
│ type              │ person | pet
│ name              │
│ avatar_color      │
│ role              │ parent|child|grandparent|caregiver (persons)
│ species           │ dog|cat|bird|fish|other (pets only, nullable)
│ breed             │ (pets only, nullable)
│ date_of_birth     │
│ blood_group       │ (nullable)
│ allergies         │ (nullable)
│ emergency_contact │ (nullable)
│ medical_conditions│ (nullable)
│ custom_fields     │ JSON (user-defined key-value pairs)
│ created_at        │
│ updated_at        │
│ is_active         │ (soft delete)
└──────┬───────────┘
       │ N:M (via FamilyItemLink)
       ▼
┌──────────────────────┐
│  FamilyItem           │
│──────────────────────│
│ id (UUID)             │
│ family_id (FK)        │
│ title                 │ AI-generated or user-edited
│ document_type         │ enum (see below)
│ status                │ queued | pending | confirmed | archived
│ confidence            │ high | medium | low
│ source                │ camera | gallery | share_sheet | email | manual
│ file_path             │ local file path
│ cubby_filename        │ AI-generated structured name: {type}_{date}_{hash}.{ext}
│ original_filename     │ original name from device (e.g. IMG_4532.jpg)
│ remote_url            │ R2 URL (after sync)
│ thumbnail_path        │ local thumbnail
│ extracted_fields      │ JSON { key: value }
│ raw_ai_response       │ JSON (full Claude response for debugging)
│ notes                 │ user-added notes (nullable)
│ tags                  │ JSON array of user tags
│ expiry_date           │ (nullable, extracted by AI)
│ event_date            │ (nullable, extracted by AI)
│ created_at            │
│ updated_at            │
│ confirmed_at          │ (nullable)
│ is_deleted            │ (soft delete)
└──────┬───────────────┘
       │ 1:N
       ▼
┌──────────────────────┐     ┌──────────────────────┐
│  FamilyItemLink       │     │  Reminder             │
│──────────────────────│     │──────────────────────│
│ id (UUID)             │     │ id (UUID)             │
│ family_item_id (FK)   │     │ family_id (FK)        │
│ family_member_id (FK) │     │ family_item_id (FK)   │ nullable (manual reminders)
│ linked_by             │     │ family_member_id (FK) │ nullable
│ created_at            │     │ title                 │
└──────────────────────┘     │ body                  │
                              │ due_date              │
                              │ remind_at             │ when to fire notification
                              │ rule_type             │ passport|visa|insurance|vaccination|medication|tenancy|custom
                              │ status                │ pending | dismissed | completed
                              │ created_at            │
                              │ updated_at            │
                              └──────────────────────┘

┌──────────────────────┐
│  UserCorrection       │
│──────────────────────│
│ id (UUID)             │
│ family_item_id (FK)   │
│ original_type         │ what AI classified as
│ corrected_type        │ what user changed it to
│ original_person       │ who AI suggested
│ corrected_person      │ who user selected
│ corrected_fields      │ JSON of field corrections
│ created_at            │
└──────────────────────┘

┌──────────────────────┐
│  SyncQueue            │
│──────────────────────│
│ id (UUID)             │
│ table_name            │
│ record_id             │
│ operation             │ insert | update | delete
│ payload               │ JSON
│ status                │ pending | synced | failed
│ retry_count           │
│ created_at            │
│ synced_at             │ nullable
└──────────────────────┘
```

---

## Document type enum

```dart
enum DocumentType {
  // Identity
  passport,
  emiratesId,
  visa,
  nationalId,
  drivingLicense,
  birthCertificate,

  // Health
  prescription,
  labReport,
  vaccinationRecord,
  healthCard,
  medicalReport,
  dischargeSummary,

  // Insurance
  insurancePolicy,
  insuranceClaim,
  insuranceCard,

  // Education
  schoolReport,
  certificate,
  admissionLetter,
  feeReceipt,

  // Property & Vehicle
  tenancyContract,   // Ejari
  vehicleRegistration, // Mulkiya
  propertyDocument,

  // Travel
  bookingConfirmation,
  boardingPass,
  travelInsurance,

  // Financial
  bill,
  receipt,
  invoice,
  bankStatement,
  taxDocument,

  // Pet
  petVaccination,
  petMedical,
  petRegistration,

  // Other
  other,
}
```

---

## Drift table definitions (local)

```
Tables:
  families
  family_members
  family_items
  family_item_links      (junction: item ↔ member)
  reminders
  user_corrections       (AI feedback loop)
  sync_queue             (offline sync buffer)
  search_index           (FTS5 virtual table on family_items)
```

FTS5 index covers: `title`, `document_type`, `extracted_fields` (flattened text), `notes`, `tags`.

---

## Supabase schema (remote mirror)

Same structure as Drift tables but with:
- Row-level security: every query filtered by `family_id` matching authenticated user's family
- `updated_at` trigger for sync conflict detection
- Storage bucket per family for R2 file references
- Realtime subscriptions on `family_items` and `reminders` for multi-device updates

---

## Migration strategy

- Drift handles local schema migrations (versioned, auto-applied on app start)
- Supabase migrations managed via Supabase CLI (`supabase db push`)
- Schema versions tracked in both systems
- Breaking changes require app version gate (force update if schema incompatible)

---

## Data lifecycle

| Stage | Storage | Duration |
|-------|---------|----------|
| Captured (pre-AI) | Local file cache + Drift (status: queued) | Until AI processes |
| Pending (AI processed, unconfirmed) | Drift (status: pending) | Until user confirms or 30 days (auto-archive) |
| Confirmed | Drift + Supabase + R2 | Indefinite |
| Archived | Drift + Supabase (flagged) | Indefinite, hidden from default views |
| Deleted | Soft-deleted locally, hard-deleted from R2 after 30 days | 30-day recovery window |

---

## File naming convention

Original filenames from devices (IMG_4532.jpg, WhatsApp Image 2026-06-08.jpg) are meaningless. Cubby auto-generates structured names based on AI classification.

### Storage path (R2 and local cache)
```
/{family_id}/
  /member_{entity_id}/
    {document_type}_{key_date}_{short_hash}.{ext}
  /vehicle_{entity_id}/
    {document_type}_{key_date}_{short_hash}.{ext}
  /property_{entity_id}/
    {document_type}_{key_date}_{short_hash}.{ext}
```

Examples:
- `member_a1b2/visa_2026-07-14_a3f8.jpg`
- `member_a1b2/prescription_2026-06-02_d4e9.jpg`
- `member_c3d4/pet-vaccination_2026-09-28_f1a3.jpg`
- `vehicle_e5f6/vehicle-registration_2026-10-18_c7d2.jpg`
- `property_g7h8/tenancy-contract_2027-03-15_e5f8.jpg`

### Display title (what the user sees)
AI-generated from document content: "Arjun Sharma — UAE Visa"
Editable by user. Stored in `title` field.

### Search priority
1. AI title + extracted fields (primary — "visa", "Arjun", "employment")
2. Document type enum (secondary — searching "visa" matches type directly)
3. Original filename (fallback — user remembers "it was that PDF called policy_renewal")

All three are indexed in FTS5.

---

*See also: api-architecture.md, security-architecture.md*
