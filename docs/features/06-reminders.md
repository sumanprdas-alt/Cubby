# Feature Spec: Reminders & Events

> Module 6. Auto-generated from documents + manual events + shared text events.

---

## Goals
- Ensure families never miss critical deadlines (visa expiry, insurance renewal, vaccinations)
- Generate reminders automatically from AI-extracted dates — zero manual setup
- Support manual event creation for school meetings, doctor appointments, holidays, etc.
- Detect events from shared WhatsApp messages and create them automatically

## User stories
- As a user, I want reminders auto-created when I add a document with an expiry date
- As a user, I want to see all upcoming reminders and events sorted by urgency
- As a user, I want to dismiss, complete, or snooze a reminder
- As a user, I want to manually add an event like a school meeting or doctor appointment
- As a user, I want to share a WhatsApp message about a school meeting and have Cubby create an event from it
- As a user, I want push notifications for upcoming deadlines and events

## User flow
**Auto-generation:** Item confirmed with expiry_date → ReminderOrchestrator checks rule table → creates reminders at defined intervals → reminders appear on home screen and reminders list

**Manual event:** People → person → "+" → "Add event" → Title, Date, Time (optional), Remind before (1 day default), Notes → Save → event appears in reminders list and on person's profile

**Event from shared text:** User shares WhatsApp message → InboxOrchestrator detects event language + date → creates event in inbox → user confirms and assigns person (one tap) → event appears in reminders

**View reminders:** Home screen shows top 3 urgent reminders/events → "See all" → Reminders screen → sorted by due_date (urgent first) → each card: icon, title, person chip, due date, days remaining

**Act on reminder:** Tap reminder → options: "Done ✓" (completed), "Dismiss" (won't do), "Snooze 7 days" (reschedule) → tap body to see linked document or event detail

**Create manual:** Reminders screen → "+" → title, due date, optional person link, optional note → Save

## Reminder rules (configurable)

| Document type | Remind at | Repeat |
|--------------|-----------|--------|
| Passport | 90, 60, 30 days before expiry | No |
| Visa | 90, 60, 30 days before expiry | No |
| Emirates ID | 60, 30 days before expiry | No |
| Insurance policy | 60, 30 days before expiry | No |
| Vehicle registration | 60, 30 days before expiry | No |
| Tenancy/Ejari | 90, 60, 30 days before end date | No |
| Vaccination (next due) | 14, 7 days before due date | No |
| Medication refill | 7 days before estimated run-out | No |
| Pet vaccination | 14, 7 days before next due | No |

## Edge cases
- Document has no expiry date → no auto-reminder generated
- Same expiry creates duplicate reminder → DuplicateDetectionOrchestrator prevents this
- Reminder for a deleted document → auto-dismiss the reminder
- User dismisses all reminders for a document → don't re-generate (store suppression flag)
- Past-due reminder → show as "Overdue" with red styling, don't auto-dismiss
- Manual reminder with no person link → shows in general reminders, not under any member

## Acceptance criteria
- [ ] Reminders auto-generated when item with expiry_date is confirmed
- [ ] Reminder rules follow the table above (configurable)
- [ ] Reminders list sorted by due_date, urgent first
- [ ] Each reminder shows: title, person chip, days remaining, urgency color
- [ ] Tap reminder → Done / Dismiss / Snooze options
- [ ] Tap reminder body → navigates to linked document
- [ ] Manual reminder creation with title, date, optional person
- [ ] Push notification fires at remind_at time
- [ ] No duplicate reminders for same document + same interval
- [ ] Overdue reminders styled with red indicator
- [ ] Reminders work fully offline (stored in local Drift)

## Analytics events
- `reminder_generated` { rule_type, days_until_due, auto_or_manual }
- `reminder_tapped` { rule_type }
- `reminder_completed` { rule_type }
- `reminder_dismissed` { rule_type }
- `reminder_snoozed` { rule_type, snooze_days }
- `reminder_notification_tapped`

## Permissions requirements
- All family members see reminders for members they can view
- Only parents can dismiss/complete reminders for children's items

## AI requirements
- ReminderOrchestrator is rules-based, no AI needed
- Relies on AI-extracted expiry_date and event_date from InboxOrchestrator

## Success metrics
| Metric | Target |
|--------|--------|
| Auto-generated reminders per family (month 3) | ≥ 5 |
| Reminder completion rate | > 60% |
| Zero missed critical deadlines (for active users) | 100% |
| Reminder precision (no false reminders) | > 95% |
