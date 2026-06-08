# Cubby — MVP Build Plan

> This replaces Steps 4, 5, 6, 7 with one actionable document.
> Goal: Working app tested with your own family in Dubai. Then expand to ~20 families.

---

## MVP scope

**In:**
- Sign-in (phone OTP — identity + multi-device sync)
- Onboarding (family setup, add members + vehicles + properties, first capture)
- Family Profiles (people, pets, vehicles, properties)
- Family Inbox (camera + gallery + share sheet → Claude Vision → confirm/edit)
- Smart Vault (browse, view, search, edit, delete items)
- Family Assistant (natural language queries with cited answers)
- Reminders (auto-generated from document dates)

**Out (build later, based on real feedback):**
- Freemium gates / payment tiers / Stripe
- WhatsApp Business API bot (share sheet already captures from WhatsApp)
- DigiLocker (India-only, irrelevant for Dubai)
- Email forwarding
- Semantic search / embeddings
- Client-side encryption
- Calendar sync
- Export / data portability
- Grandparent / caregiver / child roles (all users are "parent" in beta)
- Any growth / marketing features

---

## Sprint plan (6 sprints, 1 week each)

### Sprint 1: Skeleton + Auth
Build the app shell that everything else plugs into.

- Flutter project scaffold (folder structure per mobile-architecture.md)
- Drift database setup (all tables from database-architecture.md)
- go_router navigation with bottom tab bar (Home, Inbox, Capture, People, Assistant)
- Firebase Phone OTP sign-in (UAE +971)
- Supabase project setup + JWT exchange Edge Function
- Sentry + PostHog integration
- Family creation flow (name + add members)
- Entity models: FamilyMember (person + pet), Vehicle, Property
- Family invitation flow: generate invite link → share via WhatsApp/SMS → recipient signs in with phone OTP → joins family. Works across countries (any phone number).

**Done when:** User can sign in, create family, add members (people, pets), add a vehicle and property, invite a family member in another country who can sign in and see the same vault, and navigate between tabs.

**Tests:** Auth flow widget test, FamilyMember/Vehicle/Property model unit tests, Drift table creation test, invite link generation test.

### Sprint 2: Capture + AI Classification
The core magic — photograph a document, AI reads it.

- Camera screen with document edge detection
- Gallery picker (multi-select)
- Claude API client (proxied through Supabase Edge Function)
- InboxOrchestrator: image OR text → Claude → parse JSON → create FamilyItem or Event (pending)
- Supports: camera photos, gallery images, shared images, shared text (from WhatsApp messages, emails, etc.)
- Inbox screen: list of pending items as cards (type badge, title, person, confidence)
- Confirm / edit / discard actions
- FamilyItemLink: link items to members
- Offline queue: save captures locally when offline, process when online
- Duplicate detection: perceptual hash (pHash) on capture → compare against existing items → warn user if match found ("This looks similar to [item]. Keep or discard?"). Runs locally, no API cost.

**Done when:** User photographs a document, AI classifies it correctly, user confirms, item appears in vault linked to correct person. If same document is captured again, user gets a duplicate warning.

**Tests:** InboxOrchestrator unit test with mock Claude response, FamilyItem model tests, Inbox UI widget test.

### Sprint 3: Vault + Search
Browse and find everything.

- Vault browsing: items grouped by recent on home, by type on person profile
- Item detail screen: full-screen image viewer (pinch-to-zoom), metadata card, edit/share/delete
- Outbound sharing: tap Share on any item → system share sheet → WhatsApp, email, AirDrop, any app. Shares the original document image/PDF.
- Drift FTS5 search index setup
- SearchOrchestrator: QueryParser (entity extraction) + FTS5 search
- Search UI: search bar, results with snippets, entity filter chips
- Person profile screen: avatar, emergency card, linked items grouped by type

**Done when:** User can browse vault by person, search "Arjun's visa" and find it, view document full-screen.

**Tests:** SearchOrchestrator unit test, FTS5 index test, Person profile widget test.

### Sprint 4: Assistant + Reminders
Intelligence layer.

- AssistantOrchestrator: search → prune to top 5 → Claude → cited answer
- Assistant UI: chat-style screen, example queries, typing indicator, citation links
- ReminderOrchestrator: scan confirmed items for dates → create reminders per rules
- Manual event creation: People → person → "+" → add event (title, date, time, remind before, notes). Same data model as auto-reminders, just user-created.
- Events from shared text: WhatsApp message shared → AI detects date/appointment → creates event in inbox for confirmation
- Reminders UI: list sorted by urgency, complete/dismiss/snooze actions. Shows both auto-reminders and manual events.
- Home screen: show top 3 reminders + recent items + assistant search bar
- Local notifications for due reminders

**Done when:** User asks "When does our visa expire?" and gets correct cited answer. Reminders auto-generate from document expiry dates. User can manually add a school meeting. User shares a WhatsApp message with a date and it creates an event. Assistant answers "What's coming up for Ria?" with both auto and manual events.

**Tests:** AssistantOrchestrator unit test with mock search + mock Claude, ReminderOrchestrator rule tests, reminder notification scheduling test.

### Sprint 5: Share Sheet + Sync + Polish
Real-world capture and multi-device.

- Share sheet integration (iOS Share Extension, Android intent filter)
- SyncOrchestrator: Drift → Supabase sync (metadata), R2 upload (files)
- Supabase Realtime subscription for multi-device updates
- FeedbackOrchestrator (store user corrections)
- Image compression + thumbnail generation
- Error states: AI timeout, low confidence, no results, offline indicators

**Done when:** User shares image from WhatsApp → Cubby processes it. Two parents see same data on two phones.

**Tests:** Share sheet integration test, sync conflict test, duplicate detection test.

### Sprint 6: Onboarding + Beta Prep
First impressions and ship.

- Full onboarding flow (per onboarding-specification.md)
- Guided vault-seeding (capture 3+ items in first session)
- Post-onboarding notification sequence (days 1, 3, 5)
- Push notification setup (FCM)
- Settings screen (family management, storage, notification preferences)
- App icon, splash screen, basic branding
- TestFlight (iOS) + Play Console internal testing (Android) setup
- Bug bash and performance audit

**Done when:** Your family downloads the app, goes through onboarding, adds 3 documents, sees them classified and linked, gets a reminder, asks the assistant a question — all in under 5 minutes.

**Tests:** Onboarding completion end-to-end test, full capture-to-vault flow test.

---

## Engineering standards (lean)

### Code rules
- Dart/Flutter conventions (effective_dart linter)
- Max 300 lines per file
- No `print()` — use `AppLogger`
- All models: freezed + json_serializable
- All state: Riverpod providers
- All navigation: go_router
- All DB access: Drift DAOs

### Testing (pragmatic TDD)
- Write tests for orchestrators and models (these are the brain)
- Write widget tests for critical flows (onboarding, capture, confirm)
- Don't write tests for pure UI layout (colors, padding) — waste of time at this stage
- AI eval: build a dataset of 50 Dubai documents, run classification accuracy check before launch
- Target: 70%+ coverage on services/models. Don't chase 100%.

### Git workflow
- `main` branch = latest stable
- Feature branches: `feature/sprint1-auth`, `feature/sprint2-capture`
- Conventional commits: `feat:`, `fix:`, `docs:`
- PR with 1-line description before merge
- No formal code review process for solo/duo dev — just don't push broken main

### CI (GitHub Actions, set up in Sprint 1)
```
on push to main:
  - flutter analyze
  - flutter test
  - build APK (Android)
```
iOS builds via TestFlight manual upload for beta. Automate later.

---

## API accounts to create (this week)

| Service | Action | URL |
|---------|--------|-----|
| Anthropic (Claude) | Create account, get API key | console.anthropic.com |
| Firebase | Create project, enable Phone Auth + FCM | console.firebase.google.com |
| Supabase | Create project (Pro plan $25/mo) | supabase.com |
| Cloudflare | Create account, set up R2 bucket | dash.cloudflare.com |
| Sentry | Create Flutter project | sentry.io |
| PostHog | Create project (cloud free tier) | posthog.com |
| Apple Developer | Enroll ($99/yr) for TestFlight | developer.apple.com |
| Google Play Console | Register ($25 one-time) | play.google.com/console |

---

## Architecture decisions (the short version)

These are the rules. Don't break them without a reason.

1. **Entities, not folders.** Everything links to FamilyMembers, Vehicles, or Properties. No folder hierarchies.
2. **Pets = members.** type:pet on FamilyMember. Same model, same vault, same reminders.
3. **Claude Vision for everything.** One API call per document. No separate OCR service.
4. **Local-first with online AI.** Drift for all reads/writes. AI queues offline. Browse/search always work.
5. **Supabase is the backend.** No custom server. Edge Functions for server-side logic.
6. **Keyword search only (MVP).** Drift FTS5. No Meilisearch, no pgvector, no embeddings.
7. **Parents-only roles (beta).** Everyone is a parent. Role system exists in data model but not enforced in UI.
8. **No payments in beta.** Everything free. No freemium gates. No Stripe. Just sign-in for identity.
9. **Server-side encryption only.** No client-side key management. Supabase + R2 handle encryption at rest.
10. **Ship fast.** If a feature isn't in the sprint plan, it doesn't exist yet.

---

## Beta launch criteria (end of Sprint 6)

- [ ] Your family can sign in and set up the family with members, pets, vehicles, property
- [ ] Camera capture → AI classification → confirm works end-to-end
- [ ] Share sheet capture works from WhatsApp and other apps
- [ ] Search finds documents by keyword and person name
- [ ] Assistant answers factual queries with citations
- [ ] Reminders auto-generate from expiry dates
- [ ] Two devices see same family data (sync works)
- [ ] Push notifications fire for due reminders
- [ ] No crash on common flows (monitored by Sentry)
- [ ] AI classification accuracy > 80% on Dubai document types (50-doc eval set)

---

## Post-beta priorities (based on real usage)

| Priority | Feature | When |
|----------|---------|------|
| 1 | Fix whatever your family complains about most | Immediately |
| 2 | Invite 10-20 more families in Dubai | When stable |
| 3 | Email forwarding pipeline | When share sheet isn't enough |
| 4 | Freemium gates + Stripe | When you have enough users to monetize |
| 5 | Grandparent / caregiver / child roles | When multi-gen families join |
| 6 | India expansion + DigiLocker | When Dubai is working |
| 7 | Semantic search | When keyword search isn't enough |

---

*Stop planning. Start building. Test with your family. Learn. Then expand.*
