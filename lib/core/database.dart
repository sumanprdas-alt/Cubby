import 'package:drift/drift.dart';
part 'database.g.dart';
// ─── TABLE DEFINITIONS ────────────────────────────

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get firebaseUid => text().unique()();
  TextColumn get familyId => text().nullable()();
  TextColumn get familyMemberId => text().nullable()(); // which FamilyMember this user is
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('parent'))(); // parent | child | grandparent | caregiver
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSignedInAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyInvites extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get invitedBy => text()(); // user id of inviter
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get token => text().unique()();
  TextColumn get role => text().withDefault(const Constant('parent'))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending | accepted | expired | revoked
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get acceptedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Families extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyMembers extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // person | pet
  TextColumn get role => text().nullable()(); // parent | child | grandparent | caregiver
  TextColumn get species => text().nullable()(); // dog | cat | bird | fish | other
  TextColumn get breed => text().nullable()();
  TextColumn get avatarColor => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get bloodGroup => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get medicalConditions => text().nullable()();
  TextColumn get emergencyContact => text().nullable()();
  TextColumn get customFields => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get make => text().nullable()();
  TextColumn get model => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get plateNumber => text().nullable()();
  DateTimeColumn get registrationExpiry => dateTime().nullable()();
  DateTimeColumn get insuranceExpiry => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Properties extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get address => text().nullable()();
  TextColumn get propertyType => text().nullable()(); // rent | own
  DateTimeColumn get tenancyStart => dateTime().nullable()();
  DateTimeColumn get tenancyEnd => dateTime().nullable()();
  TextColumn get landlordName => text().nullable()();
  TextColumn get landlordContact => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyItems extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get title => text()();
  TextColumn get documentType => text()(); // visa, passport, prescription, etc.
  TextColumn get status => text().withDefault(const Constant('pending'))(); // queued | pending | confirmed | archived
  TextColumn get confidence => text().nullable()(); // high | medium | low
  TextColumn get inputType => text().nullable()(); // document | event | both
  TextColumn get source => text().nullable()(); // camera | gallery | share_sheet | manual
  TextColumn get filePath => text().nullable()();
  TextColumn get cubbyFilename => text().nullable()();
  TextColumn get originalFilename => text().nullable()();
  TextColumn get remoteUrl => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get extractedFields => text().nullable()(); // JSON string
  TextColumn get rawAiResponse => text().nullable()(); // JSON string
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array string
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get eventDate => dateTime().nullable()();
  TextColumn get eventTime => text().nullable()(); // HH:MM
  TextColumn get summary => text().nullable()();
  TextColumn get imageHash => text().nullable()(); // perceptual hash for duplicate detection
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyItemLinks extends Table {
  TextColumn get id => text()();
  TextColumn get familyItemId => text().references(FamilyItems, #id)();
  TextColumn get familyMemberId => text().nullable().references(FamilyMembers, #id)();
  TextColumn get vehicleId => text().nullable().references(Vehicles, #id)();
  TextColumn get propertyId => text().nullable().references(Properties, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get familyItemId => text().nullable().references(FamilyItems, #id)();
  TextColumn get familyMemberId => text().nullable().references(FamilyMembers, #id)();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get ruleType => text().nullable()(); // passport | visa | insurance | vaccination | medication | tenancy | custom
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending | notified | dismissed | completed
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class UserCorrections extends Table {
  TextColumn get id => text()();
  TextColumn get familyItemId => text().references(FamilyItems, #id)();
  TextColumn get originalType => text().nullable()();
  TextColumn get correctedType => text().nullable()();
  TextColumn get originalPerson => text().nullable()();
  TextColumn get correctedPerson => text().nullable()();
  TextColumn get correctedFields => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get tableName => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // insert | update | delete
  TextColumn get payload => text()(); // JSON string
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending | synced | failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── DATABASE ─────────────────────────────────────

@DriftDatabase(tables: [
  Users,
  FamilyInvites,
  Families,
  FamilyMembers,
  Vehicles,
  Properties,
  FamilyItems,
  FamilyItemLinks,
  Reminders,
  UserCorrections,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
