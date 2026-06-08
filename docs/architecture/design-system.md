# Cubby — Visual Design System

> Design direction for Dubai beta. Implements product principles: calm, minimal, warm, fast, trustworthy.

---

## Design DNA

Cubby should feel like a well-organized kitchen drawer — everything has its place, you open it, grab what you need, close it. Not a filing cabinet. Not a dashboard. Not an enterprise app. A warm, calm place where your family's important things live.

**Inspiration blend:** Apple Health (card-based, clean hierarchy) + Linear (speed, minimal chrome) + Headspace (warmth, calm tones) + WhatsApp (familiar, mobile-native)

**What it is NOT:** Enterprise document management. Blue-and-gray SaaS. Folder-based file browser. Notification-heavy engagement machine.

---

## Color palette

| Token | Hex | Usage |
|-------|-----|-------|
| Canvas | #F8F7F4 | App background (warm off-white, not clinical white) |
| Card | #FFFFFF | Card surfaces, modals, sheets |
| Primary | #1B6B5A | CTAs, active tab, FAB, links, positive actions |
| Primary soft | #E8F5F0 | Primary badges, selected states, tinted backgrounds |
| Amber | #C67A1A | Warnings, expiry approaching, medium confidence |
| Red | #C62828 | Urgent, errors, overdue, emergency card |
| Blue | #1565C0 | Info badges, passport/ID type |
| Purple | #6A1B9A | Education type badges |
| Ink | #1C1C1E | Primary text |
| Ink secondary | #636366 | Secondary text, section labels |
| Ink tertiary | #AEAEB2 | Meta text, placeholders, hints |
| Border | #E5E5EA | Card borders, dividers |

The warm canvas (#F8F7F4) is deliberate — it separates Cubby from clinical white (#FFFFFF) apps and gives a subtle warmth that feels "home-like."

---

## Member avatar colors

Auto-assigned to family members in this order:

| Order | Color | Hex |
|-------|-------|-----|
| 1 | Forest green | #1B6B5A |
| 2 | Warm brown | #6B4C1B |
| 3 | Purple | #5A1B6B |
| 4 | Amber | #C67A1A |
| 5 | Blue | #1565C0 |
| 6 | Red | #C62828 |
| 7 | Green | #2E7D32 |
| 8 | Deep brown | #4E342E |

Avatars: 48px circle with member initial (white, 16px, weight 500). No photos in MVP — initials are faster to render, consistent, and avoid the "upload a photo" friction.

Pets show a subtle paw icon next to their name chip.

---

## Typography

System fonts only (SF Pro on iOS, Roboto on Android). No custom fonts for MVP — reduces binary size and ensures native feel.

| Level | Size | Weight | Color | Usage |
|-------|------|--------|-------|-------|
| Screen title | 24px | 500 | Ink | "The Sharma Family", "Inbox", "Ask Cubby" |
| Item title | 15px | 500 | Ink | Document names in cards |
| Body | 14px | 400 | Ink | Descriptions, extracted fields, assistant answers |
| Section label | 13px | 500 | Ink secondary | "UPCOMING", "IDENTITY", "HEALTH" — always uppercase with 0.3px tracking |
| Meta | 12px | 400 | Ink tertiary | "Visa · Yesterday · Camera", timestamps, type labels |
| Micro | 11px | 500 | Varies | Badges, confidence indicators, tiny labels |

---

## Core components

### Document type badges
Soft tinted pill with matching text color. Each document category has a color family:

| Category | Background | Text | Types |
|----------|-----------|------|-------|
| Identity | #E8F5F0 | #1B6B5A | Visa, Emirates ID, driving license |
| Passport | #E3F2FD | #1565C0 | Passport |
| Health | #FFF3E8 | #C67A1A | Prescription, lab report, health card |
| Insurance | #FCE4EC | #C62828 | Insurance policy, insurance card |
| Education | #F3E5F5 | #6A1B9A | School report, certificate |
| Property | #FFF8E1 | #F57F17 | Tenancy/Ejari, vehicle registration |
| Travel | #E8F5F0 | #1B6B5A | Booking, boarding pass |
| Other | #F0F0F0 | #636366 | Unclassified, other |

### Confidence indicators
| Level | Style | Behavior |
|-------|-------|----------|
| High | Green badge with check icon | Auto-suggest person, ready to confirm |
| Medium | Amber badge "Review suggested" | Show with gentle warning, user should check fields |
| Low | Gray badge "Needs help" | Show alternative type suggestions, ask who it belongs to |

### Person chips
Rounded pill (20px radius) with mini avatar (20px circle) + name. Selected state: green tinted background with primary border. Used in inbox cards for "Belongs to" and in search for entity filter.

### Buttons
| Type | Style | Usage |
|------|-------|-------|
| Primary | #1B6B5A fill, white text, 10px radius | "Looks good ✓", main CTAs |
| Secondary | #F0F0F0 fill, ink text | Edit, secondary actions |
| Icon | #F0F0F0 fill, 48x48, centered icon | Edit, delete, share alongside primary |
| Outline | Transparent, 0.5px border | Tertiary actions, settings |

### Cards
- Background: #FFFFFF
- Border: 0.5px solid #E5E5EA
- Radius: 12px (list items), 16px (inbox cards), 14px (emergency card)
- No shadows. Ever. Flat surfaces only.
- Internal dividers: 0.5px solid #E5E5EA (hairline)

---

## Screen inventory

### Tab bar (bottom navigation)
5 tabs: Home, Inbox, Cubby (capture FAB), People, Ask

- Active tab: primary color icon + label (weight 500)
- Inactive: tertiary gray icon + label
- Cubby (center): elevated 44px circle FAB, primary fill, camera icon, extends above tab bar with 4px F8F7F4 ring
- Inbox tab: red badge (16px circle) with pending count when items exist

### Home screen
- Greeting: "Good morning" (13px secondary) + family name (24px title)
- Search bar: rounded, placeholder "Ask anything or search..."
- Member row: horizontal scroll of avatar circles + names
- Reminders section: "UPCOMING" label, reminder cards (amber for urgent, white for normal)
- Recent items section: grouped list card of latest vault items

### Inbox screen
- Header: "Inbox" + pending count + "Confirm all" button (when 2+ items)
- Cards: large (16px radius), each with:
  - Image preview area (120px height, tinted gradient background, type icon centered)
  - Confidence badge (top right of preview)
  - Source indicator (top left: camera, share sheet, gallery)
  - Type badge + title
  - Extracted fields grid (2 columns)
  - Person link with family member chips
  - Action row: [Looks good ✓] [Edit] [Delete]
- Medium/low confidence: amber/gray styling, warning banner, person selector chips

### Capture screen
- Camera with document edge detection overlay (thin green rectangle guide)
- Auto-capture when edges detected + steady
- Manual shutter button
- Gallery option (multi-select up to 10)
- Processing animation: subtle pulse on captured image while AI runs

### Person detail screen
- Back nav: "< People" with primary color
- Profile header: 64px avatar + name + role/age + item count
- Emergency card: red-tinted card with blood group, allergies, conditions, emergency contact, share button
- Items grouped by type: IDENTITY, HEALTH, EDUCATION, VEHICLE, INSURANCE, TRAVEL, OTHER
- Each group: section label (uppercase, secondary) + list card with items

### Assistant screen
- Chat-style UI
- User messages: primary green bubble (right-aligned, 16px radius with 4px bottom-right)
- Assistant messages: white bubble with border (left-aligned, 16px radius with 4px bottom-left)
- Citations: tappable cards within assistant messages (tinted background, chevron indicator)
- Example queries: shown when chat is empty, tappable pills
- Input: rounded (24px), placeholder "Ask about your family...", primary send button (circle)

### Reminders screen
- List sorted by due date (urgent first)
- Urgent cards: amber tint
- Overdue cards: red tint
- Normal cards: white
- Each card: type icon, title, person chip, days remaining (with color coding)
- Actions: complete (✓), dismiss, snooze (7 days)

### Settings screen
- Family management (add/remove members, invite)
- Storage usage (bar chart)
- Notification preferences (toggles per category)
- Account (sign out, delete account)
- About

---

## Anti-patterns (never do these)

1. No enterprise-style dashboards with metrics and charts
2. No folder navigation or breadcrumbs
3. No red notification badges except inbox pending count
4. No "you haven't opened the app" notifications
5. No skeleton loading screens — use simple subtle pulse animation
6. No complex multi-step forms — one screen per action
7. No dark backgrounds on main screens (canvas is always warm off-white)
8. No custom fonts — system fonts only
9. No shadows or gradients — flat surfaces only
10. No more than 3 colors on any single screen (primary + one semantic + neutral)

---

## Spacing system

- Screen padding: 24px horizontal
- Section gap: 20px vertical
- Card internal padding: 12-16px
- List item height: ~56px (icon row) or ~44px (compact)
- Between section label and content: 10px
- Tab bar height: ~80px (includes safe area)
- Search bar height: 44px

---

## Motion

- Screen transitions: 300ms standard iOS/Android slide
- Card confirm animation: subtle scale(0.98) → green flash → slide right to exit inbox
- AI processing: gentle pulse animation on captured image (opacity 0.7-1.0, 1.5s cycle)
- Tab switching: instant (no animation between tabs)
- Pull-to-refresh: standard platform behavior
- No bouncy animations, no spring physics, no particle effects

---

*This design system should feel invisible. If someone notices the design, it's too loud. The family's documents should be the protagonist, not the UI.*
