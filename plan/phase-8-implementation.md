# Phase 8: Implementation — Cursor Session Prompt

Paste this into Cursor when ready to begin implementation:

---

```
Read:
- CLAUDE.md
- /docs/architecture/*
- /docs/product/*
- /docs/features/*
- /docs/decisions/*
- /docs/testing/*

Understand the project completely.

Rules:
- Do not make architectural changes. Follow the documented decisions in /docs/decisions.
- Begin implementing the repository scaffold defined in the implementation plan.
- Use Red-Green TDD. Write failing tests FIRST, then implement to make them pass.
- Create tests before implementation. Always.
- Pause whenever documentation is ambiguous — do not guess.
- Every AI capability needs its eval dataset created before implementation.
- Freemium tier enforcement follows the architecture in the ADRs — no ad-hoc if-checks.
- Pets are FamilyMembers with type:pet. Follow the unified entity model.
- All state management through Riverpod. No setState except trivial local widget state.
- All navigation through go_router. No Navigator.push.
- All models through freezed + json_serializable.
- All database access through Drift DAOs. No raw SQL in features.
- No print() — use logger.
- No hardcoded strings — use constants.
- Max 300 lines per file. Split into widgets/mixins.

Start with Sprint 1:
1. Project scaffold with full architecture
2. Entity models (FamilyMember with person+pet types, FamilyItem, Reminder)
3. Navigation shell with tabs
4. Firebase phone OTP auth
5. Write all tests FIRST, then implement
```
