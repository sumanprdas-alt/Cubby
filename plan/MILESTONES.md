# Cubby — Milestone Plan

> Last updated: 2026-06-06
> Status: Phase 0 ✅, Phase 1 ✅, Phase 2 ✅, Phase 3 ✅. Phase 4 next.

---

## Phase 0: Repository Setup ✅

| Task | Status | Owner | Notes |
|------|--------|-------|-------|
| Create GitHub repo | ✅ | Founder | https://github.com/sumanprdas-alt/Cubby |
| Create directory structure | ✅ | Claude | /docs, /apps, /packages, /tests, /plan |
| Write CLAUDE.md | ✅ | Claude | Project constitution (updated for Dubai beta) |
| Write README.md | ✅ | Claude | Public repo readme |
| Initial commit | ⬜ | Founder | Push scaffold to GitHub |

---

## Phase 1: Product Discovery ✅

**Output:** /docs/research/*, /docs/product/*

| Task | Status | Output file |
|------|--------|------------|
| Product critique | ✅ | /docs/product/product-critique.md |
| Missing requirements | ✅ | /docs/product/missing-requirements.md |
| Risks and failure modes | ✅ | /docs/research/risks-and-failure-modes.md |
| Competitive landscape | ✅ | /docs/research/competitive-landscape.md |
| Product moat analysis | ✅ | /docs/research/product-moat-analysis.md |
| ICP analysis | ✅ | /docs/research/icp-analysis.md |
| Jobs To Be Done analysis | ✅ | /docs/research/jtbd-analysis.md |
| Freemium model evaluation | ✅ | /docs/product/freemium-evaluation.md |
| API inventory validation | ✅ | /docs/product/api-integration-audit.md |
| Orchestrator design validation | ✅ | /docs/product/orchestrator-audit.md |
| Onboarding specification | ✅ | /docs/product/onboarding-specification.md |
| Recommendations | ✅ | /docs/product/recommendations.md |
| **Phase 1 review** | ✅ | Approved with updates to CLAUDE.md |

---

## Phase 2: Architecture Design ✅

**Output:** /docs/architecture/*

| Task | Status | Output file |
|------|--------|------------|
| System architecture | ✅ | /docs/architecture/system-architecture.md |
| Database architecture + ERM | ✅ | /docs/architecture/database-architecture.md |
| API architecture | ✅ | /docs/architecture/api-architecture.md |
| Search architecture | ✅ | /docs/architecture/search-architecture.md |
| AI architecture | ✅ | /docs/architecture/ai-architecture.md |
| Auth + permissions | ✅ | /docs/architecture/authentication-permissions.md |
| Security architecture | ✅ | /docs/architecture/security-architecture.md |
| Mobile architecture | ✅ | /docs/architecture/mobile-architecture.md |
| Notification architecture | ✅ | /docs/architecture/notification-architecture.md |
| Analytics + observability | ✅ | /docs/architecture/analytics-observability.md |
| **Phase 2 review** | ✅ | Complete |

---

## Phase 3: Product Specification ✅

**Output:** /docs/features/*

| Module | Status | Output file |
|--------|--------|------------|
| Onboarding | ✅ | /docs/features/00-onboarding.md |
| Family Profiles | ✅ | /docs/features/01-family-profiles.md |
| Smart Vault | ✅ | /docs/features/02-smart-vault.md |
| Family Inbox | ✅ | /docs/features/03-family-inbox.md |
| Family Timeline | ✅ | /docs/features/04-family-timeline.md |
| Family Assistant | ✅ | /docs/features/05-family-assistant.md |
| Reminders | ✅ | /docs/features/06-reminders.md |
| Health Hub | ✅ | /docs/features/07-health-hub.md |
| Education Hub | ✅ | /docs/features/08-education-hub.md |
| Travel Hub | ✅ | /docs/features/09-travel-hub.md |
| **Phase 3 review** | ✅ | Complete |

---

## Phase 4: Engineering Standards ⬜ NEXT

**Output:** /docs/testing/*, /docs/architecture/*

| Task | Status | Notes |
|------|--------|-------|
| TDD strategy | ⬜ | Red-Green-Refactor workflow, coverage targets |
| Test architecture | ⬜ | Unit, integration, widget, e2e, AI eval layers |
| CI/CD strategy | ⬜ | GitHub Actions pipeline |
| Branching strategy | ⬜ | Feature branches, PR flow |
| Release strategy | ⬜ | Versioning, TestFlight/Play Console |
| AI evaluation strategy | ⬜ | Per-capability eval with red-green gates |
| Regression testing strategy | ⬜ | What runs on every PR |
| Coding standards | ⬜ | Dart/Flutter conventions |
| Documentation standards | ⬜ | What gets documented, where, format |
| Security review process | ⬜ | Pre-release security checklist |

---

## Phase 5: MVP Definition ⬜

**Output:** /docs/product/*

| Task | Status | Notes |
|------|--------|-------|
| MVP scope definition | ⬜ | Profiles + Vault + AI Ingestion + Search + Assistant + Reminders |
| Out-of-scope items | ⬜ | Explicitly listed |
| Sprint breakdown | ⬜ | Vertical slices with TDD milestones |
| Milestones | ⬜ | Clear done criteria |
| Dependencies map | ⬜ | What blocks what |
| Complexity estimates | ⬜ | T-shirt sizing |
| Technical + product risks | ⬜ | Mitigations |
| Freemium evaluation checkpoint | ⬜ | Validate tiers against MVP |
| API readiness checklist | ⬜ | Accounts/keys needed before sprint 1 |

---

## Phase 6: Build Plan ⬜

**Output:** /docs/architecture/*, /docs/product/*

| Task | Status | Notes |
|------|--------|-------|
| Repository structure (implementation) | ⬜ | Final code folder layout |
| Backend + mobile + database structure | ⬜ | Service layers, modules, migrations |
| Implementation order (API, UI, AI, tests) | ⬜ | Sequential vertical slices |

---

## Phase 7: Architecture Freeze ⬜

**Output:** /docs/decisions/*

| ADR | Status |
|-----|--------|
| 001-product-principles | ⬜ |
| 002-mobile-architecture | ⬜ |
| 003-backend-architecture | ⬜ |
| 004-search-strategy | ⬜ |
| 005-ai-strategy | ⬜ |
| 006-security-strategy | ⬜ |
| 007-testing-strategy | ⬜ |
| 008-design-system | ⬜ |
| 009-permissions-model | ⬜ |
| 010-monetization-strategy | ⬜ |

---

## Phase 8: Implementation ⬜

| Sprint | Scope | Status |
|--------|-------|--------|
| Sprint 1 | Scaffold + entity models + nav shell + auth | ⬜ |
| Sprint 2 | Camera capture + InboxOrchestrator + Inbox UI | ⬜ |
| Sprint 3 | Search + Assistant + Assistant UI | ⬜ |
| Sprint 4 | People profiles + timeline + health hub + reminders | ⬜ |
| Sprint 5 | Share sheet + gallery import + email forwarding | ⬜ |
| Sprint 6 | DigiLocker + WhatsApp bot + calendar sync | ⬜ |
| Sprint 7 | Freemium gates + payments + onboarding polish | ⬜ |
| Sprint 8 | Performance + security audit + App Store prep | ⬜ |

---

## AI Eval Tracking

| Capability | Target | Status |
|-----------|--------|--------|
| Document classification | > 85% F1 | ⬜ |
| Field extraction | > 80% accuracy | ⬜ |
| Person matching | > 85% accuracy | ⬜ |
| Reminder precision | > 95% | ⬜ |
| Assistant accuracy | > 90% | ⬜ |
| Hallucination rate | < 5% | ⬜ |
| Duplicate detection | > 80% precision | ⬜ |

---

*Next action: Phase 4 — Engineering Standards*
