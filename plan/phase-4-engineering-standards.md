# Phase 4: Engineering Standards — Claude Code Session Prompt

Paste this into Claude Code in a new session:

---

```
Read all existing documentation:
- CLAUDE.md
- /docs/product/*
- /docs/research/*
- /docs/architecture/*

Design the engineering operating system for Cubby.

Key requirements:
- Red-Green TDD is mandatory. Every feature starts with a failing test.
- AI capabilities use eval datasets as their "tests" — red-green workflow applies.
- CI must enforce all gates before merge.
- Freemium tier logic must have dedicated test coverage.
- Orchestrator pipelines must have integration test strategies with mock APIs.

Create:

1. TDD strategy — Red-Green-Refactor workflow, when to write tests, test-first discipline
2. Test architecture — Unit, integration, widget, e2e, AI eval layers. What tools (flutter_test, mockito, integration_test). Directory structure under /tests.
3. CI/CD strategy — GitHub Actions pipeline. Lint → unit tests → integration tests → AI evals → build. Branch protection rules.
4. Branching strategy — Feature branches, PR flow, review requirements
5. Release strategy — Versioning (semver), TestFlight/Play Console beta, staged rollouts
6. AI evaluation strategy — How eval datasets are created, stored, run, tracked. Red-green gates for AI. Regression detection. Model update protocol.
7. Regression testing strategy — What runs on every PR, what runs nightly, what runs on release
8. Coding standards — Dart/Flutter conventions, file length limits, naming, imports, state management rules
9. Documentation standards — What gets documented, where, format, review process
10. Security review process — Pre-release checklist, dependency audit, encryption verification

Store outputs under:
/docs/testing
and
/docs/architecture

No code generation.
```
