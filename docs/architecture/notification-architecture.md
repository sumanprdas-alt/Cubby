# Cubby — Notification Architecture

> Step 2 deliverable.

---

## Notification channels

| Channel | Technology | Works offline | Use case |
|---------|-----------|--------------|----------|
| Push | Firebase Cloud Messaging (FCM) + APNs | No | Reminders, family activity |
| Local | flutter_local_notifications | Yes | Scheduled reminders, offline capture complete |
| In-app | Riverpod state (badge count, inbox banner) | Yes | Inbox pending count, sync status |

---

## Notification types

| Type | Channel | Frequency | User can disable |
|------|---------|-----------|-----------------|
| **Reminder** — "Arjun's visa expires in 30 days" | Push + local | Per reminder rule (90/60/30/14/7 days) | Per category |
| **Inbox processed** — "3 items ready for review" | Push | Batched (max 1/hour) | Yes |
| **Family activity** — "Priya added 2 documents" | In-app only (MVP) | Real-time when viewing | Yes |
| **Onboarding nudge** — "Try sharing from WhatsApp" | Push | Days 1, 3, 5 only | Auto-stops after day 7 |
| **Offline queue processed** — "5 items processed while you were offline" | Local + in-app | On connectivity restore | No |

### What we NEVER send
- "You haven't opened Cubby in X days" (guilt notifications)
- Marketing or promotional content
- Cross-sell / upsell pushes
- Social/engagement gamification ("You're on a 5-day streak!")

---

## Reminder notification pipeline

```
ReminderOrchestrator (runs daily at 8am local time via local scheduling)
  │
  ▼
Query Drift: reminders WHERE status = pending AND remind_at <= now + 24h
  │
  ▼
For each due reminder:
  - Schedule local notification at remind_at time
  - If push available: schedule FCM via Edge Function
  - Set reminder status to 'notified'
  │
  ▼
User taps notification → deep link to item detail
  - "Dismiss" → status = dismissed
  - "Done" → status = completed
  - Snooze (7 days) → update remind_at
```

---

## FCM setup

- FCM token registered on app start, stored in Supabase user_devices table
- Edge Function sends push via FCM HTTP v1 API
- Token refreshed on each app start
- Multiple devices per user supported (same notification to all devices)
- Notification payload includes deep link path for navigation

---

## Notification preferences (stored locally + synced)

```json
{
  "reminders_enabled": true,
  "reminder_categories": {
    "passport": true,
    "visa": true,
    "insurance": true,
    "vaccination": true,
    "medication": true,
    "tenancy": true
  },
  "inbox_notifications": true,
  "family_activity": false,
  "quiet_hours": { "start": "22:00", "end": "07:00" }
}
```

---

*See also: mobile-architecture.md, system-architecture.md*
