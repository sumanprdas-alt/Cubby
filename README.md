# Cubby

> The operating system for families.

Cubby is a single-source-of-truth app for family administration. It replaces the scattered mess of WhatsApp forwards, photo galleries of documents, paper files, sticky notes, and mental load that families carry every day.

## What it does

- **Family Inbox** — Toss in any document via camera, screenshot, email, or WhatsApp. AI reads, classifies, and files it automatically.
- **Family Assistant** — Ask questions in natural language. "When was Buddy's last vaccination?" "Which passports expire this year?"
- **Family Timeline** — Every family member has a chronological life timeline that becomes more valuable over time.
- **Smart Vault** — Documents organized around people, not folders. Everything is entity-linked and searchable.
- **Health Hub** — Prescriptions, lab reports, vaccinations, medication reminders per family member.
- **Auto-Reminders** — Passport expiry, insurance renewal, vaccination schedules — generated automatically from your documents.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.x (iOS + Android) |
| State | Riverpod 3.x |
| Local DB | Drift (SQLite) |
| Backend | Supabase (PostgreSQL + Auth + Storage) |
| Search | Meilisearch + pgvector (hybrid) |
| OCR | Google Cloud Vision API |
| AI | Claude API (Anthropic) |
| Auth | Firebase Phone OTP |
| Notifications | Firebase Cloud Messaging |

## Getting Started

### Prerequisites

- Flutter SDK 3.22+
- Dart SDK 3.4+
- Xcode 15+ (for iOS)
- Android Studio / Android SDK
- Firebase CLI
- Supabase CLI (optional, for local dev)

### Setup

```bash
# Clone the repo
git clone https://github.com/sumanprdas-alt/Cubby.git
cd Cubby

# Install dependencies
flutter pub get

# Generate code (freezed, drift, riverpod)
dart run build_runner build --delete-conflicting-outputs

# Run on device/simulator
flutter run
```

### Environment Setup

Copy `.env.example` to `.env` and fill in:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
CLAUDE_API_KEY=your_claude_api_key
GOOGLE_CLOUD_VISION_KEY=your_gcv_key
```

## Documentation

All product and technical documentation lives in `/docs`:

- `/docs/vision` — Product vision, mission, principles
- `/docs/product` — PRD, MVP scope, sprint plans
- `/docs/architecture` — System, database, API, AI architecture
- `/docs/features` — Per-module specifications
- `/docs/decisions` — Architecture Decision Records
- `/docs/testing` — TDD strategy, CI/CD, AI evals
- `/docs/research` — Competitive analysis, ICP, JTBD
- `/docs/growth` — Growth strategy, monetization

## Contributing

See [CLAUDE.md](CLAUDE.md) for coding conventions, architecture decisions, and engineering workflow.

## License

Proprietary. All rights reserved.
