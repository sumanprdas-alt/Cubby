# Cubby — API Architecture

> Step 2 deliverable.

---

## API strategy

Cubby uses **Supabase as the primary backend** for MVP. No custom backend server. This reduces infrastructure complexity and accelerates development.

Supabase provides: PostgreSQL (with RLS), Auth, Realtime subscriptions, Edge Functions (for server-side logic), and Storage.

Custom backend (Fastify/Hono) is deferred until Supabase Edge Functions are insufficient — likely when WhatsApp bot, email ingestion, or webhook processing require always-on server processes.

---

## API layers

### Layer 1: Direct Supabase client (Flutter → Supabase)
- CRUD operations on all tables via `supabase_flutter` package
- Row-level security handles authorization server-side
- Realtime subscriptions for multi-device sync
- Used for: family CRUD, member CRUD, item CRUD, reminders, search (server-side)

### Layer 2: Supabase Edge Functions (server-side logic)
- Triggered by database webhooks or called directly from client
- Used for: AI processing pipeline (when server-side processing is needed), scheduled reminder checks, data export generation
- Runtime: Deno (Supabase default)

### Layer 3: External APIs (called from client)
- Claude API: called directly from mobile app for classification and assistant (API key stored securely, or proxied through Edge Function)
- Firebase Auth: called via Firebase SDK
- Firebase Cloud Messaging: server-side token management via Edge Function

---

## API endpoints (Supabase RPC + Edge Functions)

### Family management
```
POST   /families                    → Create family
GET    /families/:id                → Get family details
PATCH  /families/:id                → Update family
DELETE /families/:id                → Soft-delete family

POST   /families/:id/members        → Add member
GET    /families/:id/members         → List members
PATCH  /members/:id                  → Update member
DELETE /members/:id                  → Soft-delete member

POST   /families/:id/invite          → Generate invite link
POST   /families/:id/join            → Accept invite
```

### Items (vault)
```
POST   /items                        → Create item (from AI pipeline or manual)
GET    /items?family_id=X            → List items (with filters: member, type, status)
GET    /items/:id                    → Get item detail
PATCH  /items/:id                    → Update item (confirm, edit metadata)
DELETE /items/:id                    → Soft-delete item

POST   /items/:id/links              → Link item to member
DELETE /items/:id/links/:member_id   → Unlink item from member
```

### Search
```
POST   /search                       → Full-text search (server-side, for cross-device)
  body: { query, family_id, member_id?, type?, date_range? }
  response: { results: [{ item, rank, snippet }] }
```

### Assistant
```
POST   /assistant                    → Edge Function: runs search + Claude
  body: { query, family_id, conversation_history? }
  response: { answer, citations: [{ item_id, excerpt }] }
```

### Reminders
```
GET    /reminders?family_id=X        → List reminders (with filters: status, member, date_range)
PATCH  /reminders/:id                → Update status (dismiss, complete)
POST   /reminders                    → Create manual reminder
```

### Files
```
POST   /files/upload                 → Upload document to R2 (via Supabase Storage or Edge Function)
GET    /files/:id                    → Get signed download URL
DELETE /files/:id                    → Delete file
```

---

## Authentication flow

All API calls include Supabase auth token (JWT) in Authorization header. RLS policies ensure users can only access their own family's data.

```
Client → Firebase Phone OTP → Firebase ID token
Client → Exchange Firebase token for Supabase session (via Edge Function)
Client → All subsequent calls use Supabase JWT
```

---

## Rate limiting

| Endpoint | Free tier | Family tier | Pro tier |
|----------|----------|-------------|---------|
| /assistant | 20/month | Unlimited | Unlimited |
| /items (create) | 50/month | 500/month | 2000/month |
| /search | 100/day | Unlimited | Unlimited |
| /files/upload | 500MB total | 10GB total | 50GB total |

Rate limits enforced via Supabase RLS + Edge Function middleware.

---

## Error handling

All API responses follow consistent format:
```json
{
  "data": { ... } | null,
  "error": {
    "code": "ITEM_NOT_FOUND",
    "message": "The requested item does not exist or you don't have access.",
    "status": 404
  } | null
}
```

Error codes: AUTH_REQUIRED, AUTH_EXPIRED, FORBIDDEN, NOT_FOUND, RATE_LIMITED, VALIDATION_ERROR, AI_UNAVAILABLE, SYNC_CONFLICT, STORAGE_FULL, SERVER_ERROR.

---

*See also: authentication-architecture.md, security-architecture.md*
