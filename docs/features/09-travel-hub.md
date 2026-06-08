# Feature Spec: Travel Hub

> Module 9. Filtered view of travel-related FamilyItems.
> NOT a separate module — accessible from home screen or as a filtered view.

---

## Goals
- Surface all travel documents in one view for trip preparation
- Make passport/visa status visible at a glance
- Store booking confirmations for easy retrieval

## User stories
- As a parent planning a trip, I want to see all family passports and their expiry status
- As a traveler, I want to find our hotel booking confirmation quickly at check-in
- As a user, I want to see all travel insurance policies in one place

## User flow
**Access:** Home → travel section (if travel items exist), or search "travel" → filtered results. Shows:
1. **Passport status** — all family passports with expiry dates, color-coded (green: > 6 months, amber: 3-6 months, red: < 3 months)
2. **Visa status** — active visas with expiry dates
3. **Upcoming trips** — booking confirmations sorted by event_date
4. **Travel insurance** — active policies

## Document types included
`passport`, `visa`, `bookingConfirmation`, `boardingPass`, `travelInsurance`

## Edge cases
- No travel documents → not shown as a section on home
- Expired passport → red badge: "EXPIRED" — strongest reminder trigger
- Booking in the past → moved to "Past trips" (collapsed section)

## Acceptance criteria
- [ ] Travel section visible when family has ≥ 1 travel document
- [ ] Passport/visa cards show expiry with color-coded urgency
- [ ] Booking confirmations sorted by date (upcoming first)
- [ ] Past bookings accessible but collapsed

## Analytics events
- `travel_hub_viewed`
- `travel_item_viewed` { document_type }

## AI requirements
- Passport/visa expiry extraction (InboxOrchestrator)
- Booking date and confirmation number extraction

## Success metrics
| Metric | Target |
|--------|--------|
| Families with ≥ 1 travel document | > 50% (Dubai = expat families, high travel) |
