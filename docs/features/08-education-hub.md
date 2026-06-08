# Feature Spec: Education Hub

> Module 8. Filtered view of education-related FamilyItems per child.
> NOT a separate module — filtered view within Person detail screen.

---

## Goals
- Surface all education records for a child in one view
- Track academic progress over time
- Store certificates and achievements

## User stories
- As a parent, I want to see all of Ria's school reports in chronological order
- As a parent applying to a new school, I want quick access to all education certificates
- As a parent, I want to track which term reports I've received and which are missing

## User flow
**Access:** People → child member → education section. Shows:
1. **Current school** — extracted from most recent school report (school name, grade/year)
2. **Reports** — chronological list of school reports, sorted by term/date
3. **Certificates** — certificates, awards, admission letters
4. **Fee receipts** — fee-related documents

**Quick filters:** All, Reports, Certificates, Fee Receipts

## Document types included
`schoolReport`, `certificate`, `admissionLetter`, `feeReceipt`

## Edge cases
- No education records → "No education records for [name]. Scan a school report to get started."
- Education section only appears for members with role: child (not shown for adults or pets)
- Multiple schools (child transferred) → group by school name if extractable

## Acceptance criteria
- [ ] Education section visible within child member profiles only
- [ ] Education items filtered by education-related document types
- [ ] Quick filter chips for sub-types
- [ ] Chronological ordering by event_date

## Analytics events
- `education_hub_viewed` { member_id }
- `education_item_viewed` { document_type }

## AI requirements
- School name and grade extraction from report images (InboxOrchestrator)

## Success metrics
| Metric | Target |
|--------|--------|
| Families with children who have ≥ 1 education item | > 30% |
