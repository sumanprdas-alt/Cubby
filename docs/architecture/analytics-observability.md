# Cubby — Analytics & Observability Architecture

> Step 2 deliverable.

---

## Analytics (PostHog)

### Why PostHog
- Self-hostable (data stays in-region for UAE/India compliance)
- Flutter SDK available
- Event tracking, funnels, retention, feature flags
- Free tier: 1M events/month

### Core event taxonomy

**Onboarding funnel:**
- `onboarding_started`
- `onboarding_auth_completed` { method: phone|google|apple }
- `onboarding_family_created` { member_count }
- `onboarding_first_capture` { source: camera|gallery|share_sheet }
- `onboarding_first_item_confirmed`
- `onboarding_completed` { items_count, duration_seconds }
- `onboarding_abandoned` { step, duration_seconds }

**Capture & inbox:**
- `item_captured` { source, document_type }
- `item_ai_processed` { document_type, confidence, duration_ms }
- `item_confirmed` { was_edited: bool, corrections: [field_names] }
- `item_discarded` { document_type, reason? }
- `item_viewed` { document_type }

**Search & assistant:**
- `search_performed` { query_length, results_count, had_entity_filter }
- `search_result_tapped` { rank, document_type }
- `assistant_query` { query_length }
- `assistant_response` { duration_ms, citations_count, was_helpful? }

**Reminders:**
- `reminder_generated` { rule_type, days_until_due }
- `reminder_tapped`
- `reminder_dismissed`
- `reminder_completed`

**Engagement:**
- `app_opened` { source: direct|notification|deep_link }
- `session_duration` { seconds }
- `tab_viewed` { tab_name }
- `member_profile_viewed` { member_type: person|pet }

**Monetization:**
- `paywall_shown` { trigger: member_limit|assistant_limit|storage_limit }
- `upgrade_tapped` { from_tier, trigger }
- `subscription_started` { tier, price, period: monthly|annual }
- `subscription_cancelled` { tier, reason? }

### Key dashboards

1. **Onboarding funnel** — step-by-step drop-off rates
2. **Capture funnel** — capture → AI processed → confirmed → (edited?)
3. **Retention** — D1, D7, D30 by cohort
4. **AI accuracy** — confirmation-without-edit rate as a proxy
5. **Freemium conversion** — paywall triggers → upgrade rates
6. **Cost tracking** — AI API spend per family per month

### User properties
- `family_id`, `role`, `plan_tier`, `member_count`, `item_count`, `signup_date`, `country`
- No PII in analytics (no names, phone numbers, or document contents)

---

## Observability

### Error tracking (Sentry)

- `sentry_flutter` SDK integrated from Sprint 1
- Captures: crashes, unhandled exceptions, ANRs, slow frames
- Custom breadcrumbs for: AI API calls, sync operations, capture pipeline stages
- Environment tags: `beta`, `staging`, `production`
- Alert on: crash-free rate < 99%, new error types, AI pipeline failures

### Structured logging

```dart
// Logger wrapper — no print() anywhere
class AppLogger {
  static void info(String message, {Map<String, dynamic>? data});
  static void warn(String message, {Map<String, dynamic>? data});
  static void error(String message, {Object? error, StackTrace? stack});
  static void ai(String operation, {Duration? duration, bool? success, Map<String, dynamic>? data});
}
```

Log destinations:
- **Debug:** console (dev only)
- **Production:** Sentry breadcrumbs (errors), PostHog events (analytics)
- No third-party logging service for MVP. Sentry + PostHog cover the needs.

### Performance monitoring

| Metric | How measured | Alert threshold |
|--------|------------|-----------------|
| App cold start | Sentry performance | > 3 seconds |
| AI classification latency | Custom Sentry span | > 10 seconds |
| Search latency | Custom Sentry span | > 500ms |
| Sync duration | Custom Sentry span | > 30 seconds |
| Frame rendering | Sentry frame tracking | < 55 FPS sustained |

### Health checks

Supabase Edge Function: `/health` endpoint
- Database connectivity
- R2 storage accessibility
- Claude API reachability
- FCM service status
- Returns: `{ status: 'ok' | 'degraded' | 'down', services: {...} }`

Checked every 5 minutes via external monitoring (UptimeRobot or similar).

---

*See also: system-architecture.md, ai-architecture.md*
