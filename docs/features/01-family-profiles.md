# Feature Spec: Family Profiles

> Module 1. Family setup, member management, roles.

---

## Goals
- Let families model their real family structure (people + pets) in the app
- Provide a rich profile for each member that serves as their "home page"
- Enable multi-user access with appropriate permissions

## User stories
- As a parent, I want to add all family members so documents can be linked to the right person
- As a parent, I want to see all of Aarav's documents in one place when I visit his profile
- As a parent, I want to add our pet so their vaccination and vet records are tracked too
- As a parent, I want to invite my spouse so we both have access to the family vault
- As a parent, I want to edit member details (blood group, allergies) for emergency situations
- As a user, I want to see an emergency card for any family member with critical health info

## User flow
**Add member:** People tab → "+" → Name, relationship (Spouse/Child/Parent/Grandparent/Pet) → if pet: species + breed → optional: DOB, blood group, allergies → Save → member appears in list

**View member:** People tab → tap member → Profile screen: avatar, name, role/species, age, emergency card (blood group, allergies, conditions), linked items grouped by type (documents, health, education, travel, insurance), timeline of recent events

**Invite family member:** Settings → Family → "Invite" → generates deep link → share via WhatsApp/SMS → recipient signs up → auto-joins family

**Edit member:** Profile screen → edit icon → update any field → Save

**Emergency card:** Profile screen → red-tinted card at top showing blood group, allergies, medical conditions, emergency contact. Tappable to expand. Shareable as image.

## Edge cases
- Duplicate member names (two family members named "Arjun") → differentiate by role/age badge
- Pet with no health records → show empty state: "Add Buddy's first vet record"
- Member removal → confirm dialog: "Remove [name]? Their documents will remain but be unlinked." → soft-delete member, items persist
- Family name change → editable in Settings → Family
- User tries to add 5th member on free tier → paywall
- Invitee already has their own family → currently not supported (one family per user for MVP). Show error with "Contact support."

## Acceptance criteria
- [ ] Members display as scrollable avatar chips on People screen
- [ ] Tapping a member shows their profile with linked items grouped by document type
- [ ] Emergency card shows blood group, allergies, conditions, emergency contact
- [ ] Emergency card is shareable as an image
- [ ] Members can be added with: name, relationship, optional (DOB, blood group, allergies, custom fields)
- [ ] Pets use the same member model with type:pet, species, breed fields
- [ ] Invite generates a shareable deep link
- [ ] Invited user joins the family upon sign-up with the link
- [ ] Member edit saves to Drift and queues sync
- [ ] Member removal is soft-delete (items remain, member is hidden)
- [ ] Free tier enforces 4-member limit

## Analytics events
- `member_added` { type: person|pet, relationship }
- `member_profile_viewed` { member_type }
- `member_edited` { fields_changed }
- `member_removed`
- `invite_sent` { method: link|whatsapp|sms }
- `invite_accepted`
- `emergency_card_viewed`
- `emergency_card_shared`

## Permissions requirements
- Only parents/owner can add/remove members
- Only parents/owner can invite new users
- All members can view profiles (filtered by role visibility rules)
- Only parents can edit another member's profile

## AI requirements
- None directly. Member names are used by InboxOrchestrator for person-matching.

## Success metrics
| Metric | Target |
|--------|--------|
| Avg members per family | ≥ 3 |
| Families with pets | > 20% |
| Invite acceptance rate | > 50% |
| Emergency card shares | > 10% of families/month |

---

## Family Invitation Flow (MVP)

### How it works
1. Parent opens People → "Invite family member"
2. Enters invitee's phone number (any country code: +971, +91, +44, +1, etc.)
3. App generates a unique invite deep link containing family_id + invite_token
4. Parent shares link via WhatsApp, SMS, email, or copy-paste
5. Invitee taps link → opens Cubby (or App Store if not installed)
6. Invitee signs in with their own phone OTP
7. Invitee auto-joins the family with role: Parent (MVP default)
8. Primary parent sees a confirmation: "[Name] has joined your family"
9. Invitee immediately sees the full family vault

### Edge cases
- Invitee already has a Cubby account with their own family → not supported in MVP. Show: "This phone number is already linked to another family."
- Invite link expires after 7 days → show "This invite has expired. Ask [parent] to send a new one."
- Invitee in a different timezone → no impact, all timestamps stored in UTC, displayed in local time
- Invite revoked before accepted → link returns "This invite is no longer valid."
- Multiple pending invites → each generates a unique link, all valid until expired or revoked

### Technical implementation
- Invite stored in Supabase: `family_invites` table (family_id, phone_number, token, status, expires_at)
- Deep link format: `cubby.app/join?token=xxx` (handled by app_links / uni_links)
- On sign-in, check if user's phone matches any pending invite → auto-join
- FCM notification to primary parent when invite is accepted

### Acceptance criteria
- [ ] "Invite family member" button in People screen
- [ ] Phone number input with international country code picker
- [ ] Generate shareable deep link
- [ ] Share via system share sheet (WhatsApp, SMS, etc.)
- [ ] Invitee taps link → signs in → auto-joins family
- [ ] Primary parent receives notification on invite acceptance
- [ ] Invite expires after 7 days
- [ ] Invitee sees full family vault immediately after joining
- [ ] Works across countries (tested with +971 and +91 numbers)
