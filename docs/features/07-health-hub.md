# Feature Spec: Health Hub

> Module 7. Filtered view of health-related FamilyItems per member.
> NOT a separate module — this is a filtered view within the Person detail screen.

---

## Goals
- Surface all health information for a family member in one view
- Make critical health data (medications, allergies, blood group) instantly accessible
- Track vaccination schedules and medication refills

## User stories
- As a parent, I want to see all of Aarav's health records in one place
- As a parent at a hospital, I want to quickly show the doctor Aarav's current medications and allergies
- As a pet owner, I want to see Buddy's vaccination history and next due dates

## User flow
**Access:** People → member → health section (within profile, not a separate tab). Shows:
1. **Emergency card** — blood group, allergies, medical conditions (always visible at top)
2. **Active medications** — extracted from recent prescriptions (name, dosage, frequency, refill date)
3. **Recent records** — list of health-related FamilyItems: prescriptions, lab reports, vaccination records, medical reports, discharge summaries
4. **Quick filters** — chips: All, Prescriptions, Lab Reports, Vaccinations, Medical Reports

**View record:** Tap any health item → standard item detail screen (full-screen viewer + metadata)

## Document types included
`prescription`, `labReport`, `vaccinationRecord`, `healthCard`, `medicalReport`, `dischargeSummary`, `petVaccination`, `petMedical`

## Edge cases
- No health records yet → "No health records for [name]. Scan a prescription or lab report to get started."
- Medication from old prescription (> 6 months) → greyed out with "May be outdated" label
- Pet health view → same layout but "Emergency card" shows species, breed, vet name, vet phone instead of blood group

## Acceptance criteria
- [ ] Health section visible within member profile
- [ ] Emergency card displays blood group, allergies, conditions
- [ ] Health items filtered from vault by health-related document types
- [ ] Quick filter chips for sub-types
- [ ] Active medications list extracted from recent prescriptions
- [ ] Vaccination records show next-due dates where available

## Analytics events
- `health_hub_viewed` { member_type: person|pet }
- `health_item_viewed` { document_type }

## AI requirements
- Medication extraction from prescription images (part of InboxOrchestrator)
- Vaccination next-due date extraction

## Success metrics
| Metric | Target |
|--------|--------|
| Families with ≥ 1 health item | > 40% |
| Health hub views per family/month | ≥ 2 |
