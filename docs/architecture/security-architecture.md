# Cubby — Security Architecture

> Step 2 deliverable.

---

## Threat model

Cubby stores highly sensitive personal data: identity documents, medical records, financial information, children's records. A breach would be catastrophic for user trust. Security is not a feature — it's survival.

### Top threats
1. **Unauthorized access** — someone gains access to another family's data
2. **Device theft** — physical access to unlocked phone with app open
3. **API key exposure** — Claude API key or Supabase credentials leaked
4. **Data breach** — server-side database compromise
5. **Man-in-middle** — interception of document uploads
6. **Insider threat** — team member accessing production data

---

## Security layers

### Transport security
- TLS 1.3 for all network communication
- Certificate pinning on critical API endpoints (Supabase, Claude)
- No HTTP fallback

### Data at rest
- **Local (device):** Flutter Secure Storage for credentials (Keychain/Keystore). Drift database on encrypted device storage. Document files in app sandbox (not accessible to other apps).
- **Remote (Supabase):** PostgreSQL encryption at rest (AES-256, managed by Supabase). Cloudflare R2 server-side encryption.
- **Client-side encryption:** Deferred to post-MVP. When implemented, documents encrypted with family-specific key before upload. Key derived from user password + device key. Stored in Keychain/Keystore.

### Authentication security
- Firebase Phone OTP — no passwords to leak
- Biometric lock on app open (configurable timeout)
- Session tokens stored in Secure Storage, not SharedPreferences
- JWT expiry: 1 hour (access), 30 days (refresh)

### Authorization security
- Supabase Row-Level Security: every query filtered by family_id
- RLS policies tested in CI (no query should ever return cross-family data)
- API endpoints validate auth token before any operation

### API key security
- Claude API key: stored in Supabase Edge Function environment variables, never in client app
- Classification calls proxied through Edge Function (client → Edge Function → Claude)
- Or: Claude API key encrypted in client with runtime decryption (less secure, simpler for MVP)
- **MVP decision:** Proxy through Edge Function. Adds ~100ms latency but eliminates key exposure risk.

---

## Audit logging

Every data access logged:
```json
{
  "user_id": "uuid",
  "action": "view | create | edit | delete | export",
  "resource": "family_item",
  "resource_id": "uuid",
  "timestamp": "ISO-8601",
  "ip_address": "optional",
  "device_id": "optional"
}
```

Logs stored in Supabase. Retained for 1 year. Accessible to family owner in settings.

---

## Compliance

### UAE data protection (Federal Decree-Law No. 45 of 2021)
- Explicit consent for data processing (obtained during onboarding)
- Right to access personal data (in-app data export)
- Right to erasure (account deletion with full data wipe within 30 days)
- Data Processing Impact Assessment for health data

### India DPDPA (for Phase 1 expansion)
- Verifiable parental consent for children's data
- Data Protection Officer designation
- Breach notification within 72 hours
- Data localization requirements evaluated per category

### App Store requirements
- Apple: privacy nutrition labels, App Tracking Transparency (not applicable — no tracking), HealthKit justification (post-MVP)
- Google Play: data safety section, camera/gallery permission justification

---

## Incident response

1. **Detection:** Sentry alerts on anomalous error patterns. Supabase audit log monitoring.
2. **Containment:** Rotate compromised API keys. Revoke affected sessions.
3. **Notification:** Notify affected families within 72 hours per UAE/DPDPA requirements.
4. **Recovery:** Restore from Supabase backups. Forensic analysis.
5. **Post-mortem:** Document incident, fix root cause, update security architecture.

---

*See also: authentication-permissions.md, api-architecture.md*
