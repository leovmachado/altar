import '../mock/mock_data.dart';
import '../models/models.dart';

/// Repository contracts. The UI depends ONLY on these interfaces — never on a
/// concrete data source. In Phase 1A every contract is fulfilled by an in-memory
/// `Mock*` implementation. In a later phase a `Supabase*` implementation will be
/// dropped in behind the same interface with zero UI changes.
///
/// See [docs] in SYSTEM_ARCHITECTURE.md for the planned Supabase wiring.

abstract interface class EventsRepository {
  Future<List<ChurchEvent>> upcoming();
  Future<List<ChurchEvent>> special();
  Future<ChurchEvent> byId(String id);
}

abstract interface class ScheduleRepository {
  Future<List<ScheduleAssignment>> myAssignments();
  Future<ScheduleAssignment> next();
  Future<Map<String, String?>> rosterDraft();
}

abstract interface class GivingRepository {
  Future<List<GivingRecord>> history();
  Future<int> yearToDateCents();
}

abstract interface class ProfileRepository {
  Future<UserProfile> current();
}

// ---- Mock implementations (Phase 1A) ---------------------------------------

class MockEventsRepository implements EventsRepository {
  const MockEventsRepository();
  @override
  Future<List<ChurchEvent>> upcoming() async => MockData.events;
  @override
  Future<List<ChurchEvent>> special() async => MockData.specialEvents;
  @override
  Future<ChurchEvent> byId(String id) async => MockData.eventById(id);
}

class MockScheduleRepository implements ScheduleRepository {
  const MockScheduleRepository();
  @override
  Future<List<ScheduleAssignment>> myAssignments() async => MockData.assignments;
  @override
  Future<ScheduleAssignment> next() async => MockData.nextAssignment;
  @override
  Future<Map<String, String?>> rosterDraft() async => MockData.rosterDraft;
}

class MockGivingRepository implements GivingRepository {
  const MockGivingRepository();
  @override
  Future<List<GivingRecord>> history() async => MockData.givingHistory;
  @override
  Future<int> yearToDateCents() async => MockData.givingYearToDateCents;
}

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();
  @override
  Future<UserProfile> current() async => MockData.defaultUser;
}
