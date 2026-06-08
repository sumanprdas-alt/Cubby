# Cubby — Product Moat Analysis

> Phase 1 deliverable. What makes Cubby defensible.

---

## Moat assessment

### 1. Data network effect (STRONG — primary moat)
Every document a family adds makes the product more valuable. More documents = better search results, smarter assistant answers, more accurate reminders, richer timelines. A family with 200 items in their vault will never switch to a competitor because the migration cost is too high and the new product starts at zero intelligence.

**Strength:** Grows stronger with time. Switching cost increases monthly.
**Risk:** Requires families to actually keep adding documents. If ingestion stalls, the data moat never forms.

### 2. Entity graph (STRONG — unique differentiator)
No competitor builds relationships between documents and people. Cubby knows that "this prescription belongs to Aarav, prescribed by Dr. Mehta, for the same condition as the lab report from March." This entity graph becomes a proprietary knowledge base about each family that no competitor can replicate without the same architecture.

**Strength:** Architecturally unique. Can't be copied with a UI reskin.
**Risk:** Requires AI accuracy above 90% to build reliably. Garbage in = garbage graph.

### 3. AI classification accuracy (MEDIUM — improves with scale)
Every manual correction a user makes feeds back into the classification model. At 1,000 families with 100 items each, Cubby has 100K labeled training samples for Indian documents — a dataset no competitor has.

**Strength:** Self-improving. Scale creates accuracy which creates trust which creates more scale.
**Risk:** Requires explicit feedback loop architecture. Users must be able to correct AI easily.

### 4. India/MEA-specific document intelligence (MEDIUM — geographic moat)
Indian documents are uniquely messy: handwritten prescriptions in mixed languages, thermal-printed bills, government certificates with stamps and seals, school report cards in varied formats. A system trained on Indian documents is meaningfully better at processing Indian documents than a global tool.

**Strength:** Global competitors won't prioritize Indian document formats.
**Risk:** Only defensible in India/MEA. Doesn't transfer to US/EU expansion.

### 5. DigiLocker integration (MEDIUM — regulatory moat)
Deep DigiLocker integration requires government API approval and compliance. Once Cubby has this integration, it creates a credentialed position that new entrants must also navigate.

**Strength:** Approval process is slow (2-4 weeks), creating a time advantage.
**Risk:** DigiLocker could restrict API access or build their own family features.

### 6. Brand trust with family data (WEAK initially — grows over time)
Trust with sensitive family documents (Aadhaar, medical records, financial documents) takes time to build. Once established, families won't casually switch to a less-trusted alternative.

**Strength:** Defensive moat. Hard for new entrants to earn trust quickly.
**Risk:** One data breach destroys this moat permanently.

---

## What is NOT a moat

- **Features:** Reminders, search, timeline — all replicable. Features are table stakes, not moats.
- **Flutter tech stack:** Technology choices are not defensible. Any team can build a Flutter app.
- **AI integration:** Using Claude API is not a moat. Anyone can call the same API. The moat is the proprietary eval datasets and classification accuracy built from real Indian documents.
- **Pricing:** ₹149/mo is not defensible. Competitors can undercut.

---

## Moat investment priority

1. **Data network effect** — Invest heavily in ingestion friction reduction. More documents = stronger moat.
2. **Entity graph** — Invest in classification accuracy and entity extraction. The graph is the product.
3. **India-specific AI training** — Build eval datasets from real user data (with consent). This is the only AI moat.
4. **DigiLocker integration** — Get approval early. Be the best DigiLocker-connected family app.
5. **Brand trust** — Invest in visible security, SOC 2 certification, transparent privacy policy.

---

*Next: ICP Analysis → /docs/research/icp-analysis.md*
