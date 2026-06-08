# Cubby — Authentication & Permissions Architecture

> Step 2 deliverable.

---

## Authentication

### Primary: Firebase Phone OTP
1. User enters phone number (+971 pre-selected for Dubai beta)
2. Firebase sends SMS OTP (6 digits)
3. User enters code → Firebase verifies → returns Firebase ID token
4. App exchanges Firebase token for Supabase session via Edge Function
5. Supabase JWT used for all subsequent API calls
6. Session stored securely in Flutter Secure Storage (Keychain on iOS, Keystore on Android)

### Secondary: Google / Apple Sign-In
- Available as alternative auth methods
- Firebase handles OAuth flow
- Same token exchange to Supabase

### Session management
- JWT expires after 1 hour, auto-refreshed via Supabase client
- Refresh token expires after 30 days (re-auth required)
- Biometric lock (Face ID / fingerprint) on app open — local only, doesn't affect server session
- App lock timeout: configurable (immediate, 1 min, 5 min, 30 min)

### Family creation flow
```
New user authenticates
  → Check: does user belong to a family?
  → No → Onboarding: create family + add members
  → Yes → Load family data from Supabase
```

### Family invitation flow
```
Parent A taps "Invite family member" → generates invite link (deep link with family_id + invite_token)
  → Share via WhatsApp/SMS/copy
Parent B opens link → authenticates → joins family with assigned role
  → Parent A confirms the join (security: prevent unauthorized joins)
```

---

## Permissions model

### Roles

| Role | Create items | View items | Edit items | Delete items | Manage members | Manage family | View financials |
|------|-------------|-----------|-----------|-------------|---------------|--------------|----------------|
| **Owner** (family creator) | ✅ | ✅ All | ✅ All | ✅ All | ✅ | ✅ | ✅ |
| **Parent** | ✅ | ✅ All | ✅ Own + children's | ✅ Own | ✅ Add/remove non-parents | ❌ | ✅ |
| **Grandparent** | ✅ Own | ✅ Configurable per member | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Caregiver** | ✅ Scoped | ✅ Scoped members only | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Child** (13+) | ✅ Own | ✅ Own items only | ✅ Own | ❌ | ❌ | ❌ | ❌ |

### Item visibility rules
- Items linked to a person are visible to that person (if they have app access) and all parents
- Financial documents (bill, receipt, bank_statement, tax_document) are parent-only by default
- Health documents are visible to the linked person + parents
- Pet documents are visible to all family members
- Grandparent/caregiver visibility is configurable per member by parents

### Enforcement
- **Server-side:** Supabase RLS policies check `auth.uid()` → user's role → apply visibility rules
- **Client-side:** Riverpod providers filter UI based on role (defense in depth, not sole enforcement)
- **Audit log:** Every item view/edit/delete logged with user_id and timestamp

---

## MVP simplification

For Dubai beta with < 50 families:
- Only **Owner** and **Parent** roles implemented
- Child/grandparent/caregiver roles deferred
- All parents see all items (no financial document gating)
- Invitation flow works but no role selection (invitee = Parent by default)

Roles expanded post-MVP when multi-generational families join.

---

*See also: security-architecture.md, api-architecture.md*
