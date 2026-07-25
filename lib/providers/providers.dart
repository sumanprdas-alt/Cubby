import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:cubby/core/database.dart';
import 'package:cubby/core/database_connection.dart';

const _uuid = Uuid();

// ─── DATABASE PROVIDER ────────────────────────────

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = constructDb();
  ref.onDispose(() => db.close());
  return db;
});

// ─── AUTH PROVIDER ────────────────────────────────

final authStateProvider = StreamProvider<fb.User?>((ref) {
  return fb.FirebaseAuth.instance.authStateChanges();
});

// ─── CURRENT USER PROVIDER ────────────────────────

final currentUserProvider = FutureProvider<CubbyUser?>((ref) async {
  final auth = ref.watch(authStateProvider).valueOrNull;
  if (auth == null) return null;

  final db = ref.read(databaseProvider);
  final user = await (db.select(db.users)
    ..where((u) => u.firebaseUid.equals(auth.uid)))
    .getSingleOrNull();

  return user;
});

// ─── CURRENT FAMILY PROVIDER ──────────────────────

final currentFamilyProvider = FutureProvider<CubbyFamily?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null || user.familyId == null) return null;

  final db = ref.read(databaseProvider);
  final family = await (db.select(db.families)
    ..where((f) => f.id.equals(user.familyId!)))
    .getSingleOrNull();

  return family;
});

// ─── FAMILY MEMBERS PROVIDER ──────────────────────

final familyMembersProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final family = await ref.watch(currentFamilyProvider.future);
  if (family == null) return [];

  final db = ref.read(databaseProvider);
  return (db.select(db.familyMembers)
    ..where((m) => m.familyId.equals(family.id))
    ..where((m) => m.isActive.equals(true)))
    .get();
});

// ─── VEHICLES PROVIDER ────────────────────────────

final vehiclesProvider = FutureProvider<List<Vehicle>>((ref) async {
  final family = await ref.watch(currentFamilyProvider.future);
  if (family == null) return [];

  final db = ref.read(databaseProvider);
  return (db.select(db.vehicles)
    ..where((v) => v.familyId.equals(family.id))
    ..where((v) => v.isActive.equals(true)))
    .get();
});

// ─── PROPERTIES PROVIDER ──────────────────────────

final propertiesProvider = FutureProvider<List<Property>>((ref) async {
  final family = await ref.watch(currentFamilyProvider.future);
  if (family == null) return [];

  final db = ref.read(databaseProvider);
  return (db.select(db.properties)
    ..where((p) => p.familyId.equals(family.id))
    ..where((p) => p.isActive.equals(true)))
    .get();
});

// ─── FAMILY SERVICE ───────────────────────────────

final familyServiceProvider = Provider<FamilyService>((ref) {
  return FamilyService(ref.read(databaseProvider));
});

class FamilyService {
  final AppDatabase _db;
  FamilyService(this._db);

  Future<String> createFamily({
    required String name,
    required String firebaseUid,
    String? phoneNumber,
    String? displayName,
  }) async {
    final familyId = _uuid.v4();
    final userId = _uuid.v4();

    await _db.batch((batch) {
      batch.insert(_db.families, FamiliesCompanion.insert(
        id: familyId,
        name: name,
        createdBy: userId,
      ));

      batch.insert(_db.users, UsersCompanion.insert(
        id: userId,
        firebaseUid: firebaseUid,
        familyId: Value(familyId),
        phoneNumber: Value(phoneNumber),
        displayName: Value(displayName),
        lastSignedInAt: Value(DateTime.now()),
      ));
    });

    return familyId;
  }

  Future<String> addMember({
    required String familyId,
    required String name,
    required String type,
    String? role,
    String? species,
    String? breed,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? allergies,
    int colorIndex = 0,
  }) async {
    final id = _uuid.v4();
    final colors = [
      '#1B6B5A', '#6B4C1B', '#5A1B6B', '#C67A1A',
      '#1565C0', '#C62828', '#2E7D32', '#4E342E',
    ];

    await _db.into(_db.familyMembers).insert(
      FamilyMembersCompanion.insert(
        id: id,
        familyId: familyId,
        name: name,
        type: type,
        role: Value(role),
        species: Value(species),
        breed: Value(breed),
        avatarColor: Value(colors[colorIndex % colors.length]),
        dateOfBirth: Value(dateOfBirth),
        bloodGroup: Value(bloodGroup),
        allergies: Value(allergies),
      ),
    );

    return id;
  }

  Future<String> addVehicle({
    required String familyId,
    String? make,
    String? model,
    int? year,
    String? plateNumber,
    DateTime? registrationExpiry,
    DateTime? insuranceExpiry,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.vehicles).insert(
      VehiclesCompanion.insert(
        id: id,
        familyId: familyId,
        make: Value(make),
        model: Value(model),
        year: Value(year),
        plateNumber: Value(plateNumber),
        registrationExpiry: Value(registrationExpiry),
        insuranceExpiry: Value(insuranceExpiry),
      ),
    );
    return id;
  }

  Future<String> addProperty({
    required String familyId,
    required String name,
    String? address,
    String? propertyType,
    DateTime? tenancyStart,
    DateTime? tenancyEnd,
    String? landlordName,
    String? landlordContact,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.properties).insert(
      PropertiesCompanion.insert(
        id: id,
        familyId: familyId,
        name: name,
        address: Value(address),
        propertyType: Value(propertyType),
        tenancyStart: Value(tenancyStart),
        tenancyEnd: Value(tenancyEnd),
        landlordName: Value(landlordName),
        landlordContact: Value(landlordContact),
      ),
    );
    return id;
  }
}
