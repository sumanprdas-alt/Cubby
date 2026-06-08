# Cubby — Freemium Model Evaluation

> Phase 1 deliverable. Is the freemium design correct?

---

## Current tier design (from CLAUDE.md)

| Tier | Price | Members | Storage | Key limits |
|------|-------|---------|---------|------------|
| Free | ₹0 | 3 | 500MB | Scan + manual only, 10 assistant queries/day, basic reminders |
| Family | ₹149/mo (₹1,299/yr) | 8 | 10GB | All capture channels, unlimited assistant, smart reminders, timeline |
| Family Pro | ₹299/mo (₹2,499/yr) | 15 | 50GB | WhatsApp bot, DigiLocker sync, shared timeline, export, priority OCR |

---

## Critique of current tiers

### Free tier: 3 members may be too restrictive
A nuclear family in India is typically 2 parents + 1-2 children + 1-2 pets = 4-6 members. With 3 members, a family of 4 hits the paywall on day 1 before experiencing any value. This creates friction before the "wow moment."

**Recommendation:** Increase free tier to 4 members. This covers a couple + 2 children or a couple + 1 child + 1 pet. The family of 5+ hits the paywall, which is a natural upgrade trigger.

### 500MB storage is generous enough
A scanned document photo is ~2-5MB. At 500MB, that's 100-250 documents. Most families won't hit this in the free tier within 6 months. Storage is not the right gate for conversion.

**Recommendation:** Keep 500MB. It's generous enough to not be frustrating but small enough to be a theoretical limit.

### 10 assistant queries/day is too generous for free
The assistant is the highest-cost feature (each query = Claude API call). 10 queries/day × 30 days = 300 queries/month per free user. At ~$0.01-0.02 per query, that's $3-6/month per free user in AI costs alone — well above the ₹15/mo ($0.18) cost target.

**Recommendation:** Reduce free tier to 5 assistant queries/day. Or better: 20 queries/month (not daily), which naturally throttles heavy free users while still letting casual users experience the feature.

### "Scan + manual only" for free is the right gate
Restricting capture channels (no email forwarding, no WhatsApp, no share sheet from other apps) in the free tier is smart. These are the channels that make Cubby effortless. Making families manually scan or type creates a natural friction that the paid tier removes.

**Wait — this may backfire.** If free users can only scan manually, they won't add enough documents to experience the AI magic. The data network effect moat requires volume. Restricting capture in the free tier may prevent the very behavior that makes users want to upgrade.

**Recommendation:** Allow share sheet capture in free tier (it's zero-cost — just receiving an image). Gate email forwarding and WhatsApp bot in paid tiers. Share sheet is the "taste of magic" that drives upgrades.

---

## Revised tier recommendation

| Tier | Price | Members | Storage | Key features |
|------|-------|---------|---------|-------------|
| **Free** | ₹0 | 4 members | 500MB | Scan + share sheet capture, 20 assistant queries/month, basic reminders, inbox with AI classification |
| **Family** | ₹129/mo (₹999/yr) | 8 members | 10GB | All capture channels (email forwarding), unlimited assistant, smart reminders, timeline, family activity feed |
| **Family Pro** | ₹249/mo (₹1,999/yr) | 15 members | 50GB | WhatsApp bot, DigiLocker sync, shared timeline, full export, priority OCR, emergency card sharing |

Changes from current:
- Free: 3 → 4 members. 10/day → 20/month assistant queries. Added share sheet capture.
- Family: ₹149 → ₹129/mo (₹1,299 → ₹999/yr). More competitive against Spotify/Netflix pricing tier.
- Family Pro: ₹299 → ₹249/mo (₹2,499 → ₹1,999/yr). Round numbers that feel less premium-corporate.

---

## Conversion trigger analysis

| Trigger | Free → Family conversion likelihood | Notes |
|---------|--------------------------------------|-------|
| Member limit (4 → needs 5+) | HIGH | Most nuclear families + pet = 5+ members |
| Assistant query limit (20/mo) | MEDIUM | Power users hit this fast, casual users don't |
| Email forwarding | MEDIUM | Convenience upgrade for tech-savvy parents |
| Storage limit (500MB) | LOW | Takes 6+ months to hit for most families |
| Smart reminders | MEDIUM | Basic vs smart reminders is a clear value difference |
| Timeline | LOW | Nice-to-have, not a must-have |

**Primary conversion trigger:** Member limit + assistant queries.
**Secondary:** Email forwarding + smart reminders.

---

## Cost per free user

| Cost component | Per free user/month |
|---------------|-------------------|
| Supabase (database/sync) | ~₹0.50 |
| Cloudflare R2 (storage) | ~₹0.25 |
| Google Cloud Vision (avg 5 scans/mo) | ~₹0.60 |
| Claude API (avg 10 queries/mo) | ~₹8.00 |
| Firebase (auth + FCM) | ~₹0.10 |
| **Total** | **~₹9.45/mo** |

This is under the ₹15/mo target. However, heavy free users who hit 20 assistant queries could push to ₹16+/mo. The 20/month cap is essential for cost control.

---

## LTV:CAC modeling

**Assumptions:**
- 10% free-to-paid conversion by month 6
- ₹129/mo average revenue per paying user
- 5% monthly churn on paid
- Average paid lifetime: 20 months
- LTV: ₹129 × 20 = ₹2,580

**CAC targets:**
- For 3:1 LTV:CAC → CAC must be < ₹860
- Instagram CPI (cost per install) in India: ₹30-80
- If 10% of installs convert to paid: effective CAC = ₹300-800
- This is achievable but tight. Need to optimize conversion funnel.

---

## Evaluation checkpoints

| Checkpoint | When | What to measure |
|-----------|------|----------------|
| Pre-launch | Phase 5 | Validate tier limits with 10 beta families |
| Beta | Sprint 7 | Track which limits actually trigger upgrade intent |
| Month 1 | Post-launch | Free-to-paid conversion rate, cost per free user |
| Month 3 | Ongoing | Churn by tier, feature usage by tier, LTV:CAC |
| Month 6 | Re-evaluate | A/B test pricing (₹99 vs ₹129 vs ₹149) |

---

*Next: API and Integration Audit → /docs/product/api-integration-audit.md*
