# Phase 1: Product Discovery — Claude Code Session Prompt

Paste this into Claude Code after opening the repository:

---

```
Read CLAUDE.md.

You are the founding product team, CPO, CTO and principal architect for Cubby.

Before proposing any implementation, perform a full product discovery exercise.

Your task is to challenge assumptions, identify risks, identify missing features, identify competing products and identify opportunities for differentiation.

Key constraints to incorporate:
- English-speaking families only (Phase 1). No regional language support.
- Pets are family members tagged with type:pet. Not a separate entity. No separate pet tier counting.
- Freemium model must be evaluated: tier limits, conversion triggers, cost-per-free-user, feature gates.
- Validate the API and integration inventory in CLAUDE.md. Identify any missing APIs, SDKs, or third-party services.
- Validate all orchestrator designs. Identify missing orchestrators or pipeline gaps.
- All AI capabilities must have eval dataset specifications (red-green TDD for AI).

Produce the following:

1. Product critique — What's wrong, weak, or missing in the current spec?
2. Missing requirements — Features, flows, or edge cases not yet addressed
3. Risks and failure modes — Technical, product, market, regulatory (especially DPDPA, App Store review)
4. Competitive landscape — Direct competitors (FamCal, Cozi, Notion, Google Keep, Apple Files) and indirect (WhatsApp groups, Google Photos, DigiLocker)
5. Product moat analysis — What makes Cubby defensible long-term?
6. ICP analysis — Detailed persona work for English-speaking families in India/MEA Tier 1-2 cities
7. Jobs To Be Done analysis — What are families actually hiring this product for?
8. Freemium model evaluation — Are the tier limits right? What drives upgrades? Is cost sustainable?
9. API and integration audit — Validate every API in CLAUDE.md, flag risks, identify missing ones
10. Orchestrator audit — Validate pipeline designs, identify gaps, suggest improvements
11. Recommendations for improving Cubby — Prioritized, actionable

Create all output under /docs/research and /docs/product.

Do not write code.
Do not create implementation plans yet.
Focus entirely on product strategy.
```
