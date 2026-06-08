# Cubby — Mobile Architecture

> Step 2 deliverable.

---

## Stack

| Concern | Technology |
|---------|-----------|
| Framework | Flutter 3.x |
| State management | Riverpod 3.x (code generation) |
| Local database | Drift (SQLite) with FTS5 |
| Routing | go_router |
| Models | freezed + json_serializable |
| Secure storage | flutter_secure_storage |
| Camera | camera package + custom document edge detection |
| Image processing | image package (resize, compress before upload) |
| Networking | dio (HTTP) + supabase_flutter |
| Push notifications | firebase_messaging |
| Local notifications | flutter_local_notifications |
| Biometric | local_auth |
| Deep links | app_links / uni_links |
| Analytics | PostHog Flutter SDK |
| Error tracking | sentry_flutter |

---

## App architecture

```
main.dart
  → ProviderScope (Riverpod)
    → App (MaterialApp.router)
      → BiometricGate (if locked)
        → ShellScreen (bottom nav)
          ├── HomeScreen
          ├── InboxScreen
          ├── CaptureScreen (FAB / tab)
          ├── PeopleScreen
          └── AssistantScreen
```

### Provider tree

```
// Core providers (app-wide)
authProvider          → AuthState (user, session, family)
familyProvider        → Family + List<FamilyMember>
syncProvider          → SyncOrchestrator state (syncing, error, idle)

// Feature providers
inboxProvider         → List<FamilyItem> where status = pending
vaultProvider         → List<FamilyItem> where status = confirmed
reminderProvider      → List<Reminder> sorted by due_date
searchProvider        → SearchState (query, results, loading)
assistantProvider     → AssistantState (messages, loading)

// Service providers (singletons)
driftDatabaseProvider → AppDatabase instance
claudeApiProvider     → ClaudeApiClient instance
supabaseProvider      → SupabaseClient instance
```

---

## Offline-resilient sync

### Local-first writes
Every create/update/delete writes to Drift first, then queues in SyncQueue.

```dart
// Pseudocode
Future<void> confirmItem(FamilyItem item) async {
  // 1. Update local
  await drift.familyItems.update(item.copyWith(status: confirmed));
  
  // 2. Queue sync
  await drift.syncQueue.insert(SyncEntry(
    table: 'family_items',
    recordId: item.id,
    operation: SyncOp.update,
    payload: item.toJson(),
  ));
  
  // 3. Attempt immediate sync (non-blocking)
  syncOrchestrator.syncNow();
}
```

### Sync strategy
- **On connectivity change:** when device goes online, process entire SyncQueue
- **On app foreground:** pull latest from Supabase, merge with local
- **Realtime:** Supabase Realtime subscription for instant multi-device updates when online
- **Conflict resolution:** timestamp-based. If remote `updated_at` > local `updated_at`, remote wins. If both modified offline, create both versions and flag for user resolution.

### File sync
- Document images stored locally in app documents directory
- Uploaded to Cloudflare R2 via Supabase Storage when online
- Thumbnail generated locally (300px wide) for fast list rendering
- Full-resolution image downloaded on-demand when viewing detail

---

## Navigation (go_router)

```
/                         → HomeScreen
/onboarding               → OnboardingFlow
/onboarding/family        → CreateFamilyScreen
/onboarding/capture       → FirstCaptureScreen
/inbox                    → InboxScreen
/inbox/:itemId            → ItemDetailScreen (pending)
/vault                    → VaultScreen
/vault/:itemId            → ItemDetailScreen (confirmed)
/people                   → PeopleListScreen
/people/:memberId         → MemberDetailScreen
/people/:memberId/items   → MemberItemsScreen
/assistant                → AssistantScreen
/reminders                → RemindersScreen
/capture                  → CaptureScreen (camera/gallery picker)
/search                   → SearchScreen
/settings                 → SettingsScreen
/settings/family          → FamilyManagementScreen
/settings/storage         → StorageUsageScreen
/settings/notifications   → NotificationPreferencesScreen
```

---

## Performance targets

| Metric | Target |
|--------|--------|
| App cold start | < 2 seconds |
| Screen transition | < 300ms |
| Search results | < 200ms (local FTS5) |
| Image capture to inbox card | < 5 seconds (including AI call) |
| List scroll | 60 FPS |
| Memory usage | < 150MB |
| App binary size | < 50MB |

---

## Design system tokens (core)

```dart
class AppColors {
  static const bg = Color(0xFFF8F7F4);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1C1C1E);
  static const ink2 = Color(0xFF636366);
  static const ink3 = Color(0xFFAEAEB2);
  static const border = Color(0xFFE5E5EA);
  static const primary = Color(0xFF1B6B5A);     // Warm green
  static const primarySoft = Color(0xFFE8F5F0);
  static const amber = Color(0xFFC67A1A);        // Warnings
  static const red = Color(0xFFC62828);           // Errors, urgent
  static const blue = Color(0xFF1565C0);          // Info
}
```

Typography: system fonts (SF Pro on iOS, Roboto on Android). No custom fonts for MVP — reduces binary size and load time.

---

*See also: system-architecture.md, database-architecture.md*
