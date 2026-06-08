# Feature Spec: Family Timeline

> Module 4. Chronological life events per member and per family.

---

## Goals
- Build a living chronological record of each family member's life events
- Become more valuable over time as more events accumulate
- Surface patterns and history that families would otherwise forget

## User stories
- As a parent, I want to see a timeline of all events for my child so I can track their milestones
- As a user, I want to filter the timeline by person or event type
- As a user, I want to see the whole family's timeline to get a birds-eye view of our year

## User flow
**View timeline:** Timeline tab → vertical chronological list (newest first) → date labels on left, event cards on right, connected by thin vertical line → each card: type icon, title, person chip(s), date → tap card → opens item detail

**Filter:** Filter bar at top → person chips (All, Arjun, Priya, Ria, Buddy) + type filter (All, Health, Education, Travel, Identity, Insurance) → timeline updates instantly

**Person timeline:** People → member → scroll to timeline section → shows only that member's events

## Edge cases
- Item with no date → placed at created_at timestamp, not event_date
- Two events on same date → stacked vertically under same date label
- Empty timeline → "Your family's story starts here. Add your first document."
- Very long timeline (500+ events) → lazy loading, load 50 at a time on scroll
- Multiple members on same event (family trip) → shows once with multiple person chips

## Acceptance criteria
- [ ] Timeline displays as vertical chronological list with date labels
- [ ] Each event card shows: type icon, title, person chip(s), date
- [ ] Tapping a card navigates to item detail
- [ ] Filter by person (chip selector at top)
- [ ] Filter by type (dropdown or chip selector)
- [ ] Lazy loading for 50+ events
- [ ] Timeline accessible from both Timeline tab and Person profile
- [ ] Events sourced from confirmed FamilyItems with event_date or created_at

## Analytics events
- `timeline_viewed` { filter_person, filter_type, events_count }
- `timeline_event_tapped` { document_type }
- `timeline_filtered` { by: person|type }

## Permissions requirements
- Users see events for members they have visibility access to (per role)

## AI requirements
- Timeline dates come from AI-extracted `event_date` or `expiry_date` fields
- No additional AI processing needed

## Success metrics
| Metric | Target |
|--------|--------|
| Timeline views per family/week | ≥ 1 |
| Events on timeline (month 6) | ≥ 40 per family |
