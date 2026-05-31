import 'package:flutter/material.dart';
import '../../core/rbac/app_role.dart';
import '../models/models.dart';

/// All Phase 1A demo content lives here. Dates are computed relative to a
/// fixed anchor so the demo always shows a sensible "upcoming" timeline.
class MockData {
  MockData._();

  // Anchored to keep the demo deterministic; "now" for the mock world.
  static final DateTime now = DateTime(2026, 5, 30, 9, 0);
  static DateTime _inDays(int d, {int hour = 19, int minute = 0}) =>
      DateTime(now.year, now.month, now.day + d, hour, minute);

  // ---- Users (one per role-tailored dashboard) -----------------------------
  static const _ministries = [
    Ministry(id: 'm1', name: 'Worship', icon: Icons.music_note_rounded, role: 'Vocalist'),
    Ministry(id: 'm2', name: 'Welcome Team', icon: Icons.volunteer_activism_rounded, role: 'Greeter'),
    Ministry(id: 'm3', name: 'Kids', icon: Icons.child_care_rounded, role: 'Helper'),
  ];

  static const _family = [
    FamilyMember(id: 'f1', name: 'Ana Souza', relationship: 'Spouse'),
    FamilyMember(id: 'f2', name: 'Lucas Souza', relationship: 'Child'),
    FamilyMember(id: 'f3', name: 'Sofia Souza', relationship: 'Child'),
  ];

  static UserProfile userForDashboard(DashboardType type) {
    switch (type) {
      case DashboardType.member:
        return const UserProfile(
          id: 'u-member',
          fullName: 'Marcus Reed',
          email: 'marcus@altar.demo',
          roles: [AppRole.member],
          memberSince: '2021',
          ministries: [],
          family: _family,
          givenThisMonthCents: 12000,
          recurringGiftCents: 12000,
        );
      case DashboardType.volunteer:
        return const UserProfile(
          id: 'u-volunteer',
          fullName: 'Marcus Reed',
          email: 'marcus@altar.demo',
          roles: [AppRole.member, AppRole.volunteer],
          memberSince: '2021',
          ministries: _ministries,
          family: _family,
          givenThisMonthCents: 15000,
          recurringGiftCents: 15000,
        );
      case DashboardType.ministryLeader:
        return const UserProfile(
          id: 'u-leader',
          fullName: 'Priya Nair',
          email: 'priya@altar.demo',
          roles: [AppRole.member, AppRole.volunteer, AppRole.ministryLeader],
          memberSince: '2018',
          ministries: _ministries,
          family: [],
          givenThisMonthCents: 25000,
        );
      case DashboardType.leadPastor:
        return const UserProfile(
          id: 'u-pastor',
          fullName: 'David Okoye',
          email: 'pastor@altar.demo',
          roles: [AppRole.leadPastor],
          memberSince: '2009',
          ministries: [],
          family: [],
          givenThisMonthCents: 50000,
        );
      case DashboardType.financialLeader:
        return const UserProfile(
          id: 'u-finance',
          fullName: 'Helena Costa',
          email: 'finance@altar.demo',
          roles: [AppRole.member, AppRole.financialLeader],
          memberSince: '2015',
          ministries: [],
          family: [],
          givenThisMonthCents: 30000,
        );
    }
  }

  /// Default demo user on first launch.
  static UserProfile get defaultUser => userForDashboard(DashboardType.volunteer);

  // ---- Events ---------------------------------------------------------------
  static final List<ChurchEvent> events = [
    ChurchEvent(
      id: 'e1',
      title: 'Easter Celebration',
      summary: 'A morning of worship, baptisms & community.',
      description:
          'Join us for our flagship Easter Celebration — three services of '
          'worship, a special message of hope, baptisms, and a community lunch '
          'on the lawn afterward. Bring a friend; everyone is welcome.',
      startsAt: _inDays(3, hour: 10),
      location: 'Main Auditorium',
      category: EventCategory.special,
      hostMinistry: 'Worship',
      attendeeCount: 642,
      posterColors: const [Color(0xFF0FB5A6), Color(0xFF2DD4BF), Color(0xFF10B981)],
      isSpecial: true,
      isRegistered: true,
    ),
    ChurchEvent(
      id: 'e2',
      title: 'Night of Worship',
      summary: 'An evening dedicated to presence and prayer.',
      description:
          'An immersive evening of extended worship and guided prayer. Doors '
          'open at 6:30pm; childcare provided for ages 0–5.',
      startsAt: _inDays(6, hour: 19, minute: 30),
      location: 'Main Auditorium',
      category: EventCategory.worship,
      hostMinistry: 'Worship',
      attendeeCount: 218,
      posterColors: const [Color(0xFF7C3AED), Color(0xFF2DD4BF)],
    ),
    ChurchEvent(
      id: 'e3',
      title: 'Youth Summer Kickoff',
      summary: 'Games, food trucks & a bonfire for grades 6–12.',
      description:
          'Kick off the summer with our youth ministry — outdoor games, food '
          'trucks, worship and a bonfire to close the night.',
      startsAt: _inDays(9, hour: 18),
      location: 'East Lawn',
      category: EventCategory.youth,
      hostMinistry: 'Youth',
      attendeeCount: 96,
      posterColors: const [Color(0xFFF5A524), Color(0xFFF4496D)],
    ),
    ChurchEvent(
      id: 'e4',
      title: 'Community Serve Day',
      summary: 'Serve our city — projects for all ages.',
      description:
          'Partner with local organizations for a day of hands-on service. '
          'Projects range from park clean-ups to meal packing. Lunch included.',
      startsAt: _inDays(14, hour: 9),
      location: 'City Outreach',
      category: EventCategory.community,
      hostMinistry: 'Outreach',
      attendeeCount: 154,
      posterColors: const [Color(0xFF10B981), Color(0xFF38BDF8)],
    ),
    ChurchEvent(
      id: 'e5',
      title: 'Kids Worship Workshop',
      summary: 'A creative morning for our youngest worshippers.',
      description:
          'A hands-on workshop where kids learn instruments, movement and '
          'songwriting in a fun, safe environment.',
      startsAt: _inDays(20, hour: 10),
      location: 'Kids Wing',
      category: EventCategory.kids,
      hostMinistry: 'Kids',
      attendeeCount: 48,
      posterColors: const [Color(0xFF2DD4BF), Color(0xFFF5A524)],
    ),
  ];

  static ChurchEvent eventById(String id) =>
      events.firstWhere((e) => e.id == id, orElse: () => events.first);

  static List<ChurchEvent> get specialEvents =>
      events.where((e) => e.isSpecial).toList();

  // ---- Announcements --------------------------------------------------------
  static final List<Announcement> announcements = [
    Announcement(
      id: 'a1',
      title: 'New parking entrance open',
      body:
          'The north lot is now open for Sunday services. Volunteers will guide '
          'you in — arrive 10 minutes early to get settled.',
      postedAt: _inDays(-1),
      pinned: true,
    ),
    Announcement(
      id: 'a2',
      title: 'Baptism sign-ups for Easter',
      body:
          'Ready to take your next step? Sign up to be baptized during our '
          'Easter Celebration. Talk to any team member.',
      postedAt: _inDays(-2),
    ),
    Announcement(
      id: 'a3',
      title: 'Small groups: summer term',
      body:
          'New small groups launch next month across the city. Find a group '
          'near you and connect more deeply this season.',
      postedAt: _inDays(-4),
    ),
  ];

  // ---- Schedule assignments -------------------------------------------------
  static final List<ScheduleAssignment> assignments = [
    ScheduleAssignment(
      id: 's1',
      eventTitle: 'Sunday Service · 9AM',
      role: 'Vocalist',
      startsAt: _inDays(2, hour: 9),
      location: 'Main Auditorium',
      status: ScheduleStatus.confirmed,
      team: ['Priya Nair', 'Marcus Reed', 'Joy Adeyemi', 'Caleb Stone'],
    ),
    ScheduleAssignment(
      id: 's2',
      eventTitle: 'Night of Worship',
      role: 'Backing Vocals',
      startsAt: _inDays(6, hour: 18, minute: 30),
      location: 'Main Auditorium',
      status: ScheduleStatus.pending,
      team: ['Priya Nair', 'Marcus Reed', 'Lia Fernandes'],
    ),
    ScheduleAssignment(
      id: 's3',
      eventTitle: 'Sunday Service · 11AM',
      role: 'Greeter',
      startsAt: _inDays(9, hour: 11),
      location: 'Main Lobby',
      status: ScheduleStatus.confirmed,
      team: ['Marcus Reed', 'Tom Becker'],
    ),
    ScheduleAssignment(
      id: 's4',
      eventTitle: 'Kids Worship Workshop',
      role: 'Helper',
      startsAt: _inDays(20, hour: 10),
      location: 'Kids Wing',
      status: ScheduleStatus.declined,
      team: ['Marcus Reed', 'Sara Lin'],
    ),
  ];

  static ScheduleAssignment get nextAssignment => assignments
      .where((a) => a.status != ScheduleStatus.declined)
      .reduce((a, b) => a.startsAt.isBefore(b.startsAt) ? a : b);

  /// Leader editor mock: roles for an upcoming service and who fills them.
  static final Map<String, String?> rosterDraft = {
    'Worship Leader': 'Priya Nair',
    'Vocalist': 'Marcus Reed',
    'Vocalist (2)': 'Joy Adeyemi',
    'Acoustic Guitar': 'Caleb Stone',
    'Drums': null,
    'Keys': 'Lia Fernandes',
    'Sound': null,
  };

  // ---- Giving ---------------------------------------------------------------
  static final List<GivingRecord> givingHistory = [
    GivingRecord(id: 'g1', amountCents: 15000, fund: GivingFundType.general, date: _inDays(-2), method: 'Visa •• 4242', frequency: GivingFrequency.monthly),
    GivingRecord(id: 'g2', amountCents: 5000, fund: GivingFundType.missions, date: _inDays(-12), method: 'Visa •• 4242'),
    GivingRecord(id: 'g3', amountCents: 15000, fund: GivingFundType.general, date: _inDays(-33), method: 'Visa •• 4242', frequency: GivingFrequency.monthly),
    GivingRecord(id: 'g4', amountCents: 25000, fund: GivingFundType.building, date: _inDays(-44), method: 'Bank transfer'),
    GivingRecord(id: 'g5', amountCents: 15000, fund: GivingFundType.general, date: _inDays(-63), method: 'Visa •• 4242', frequency: GivingFrequency.monthly),
  ];

  static int get givingYearToDateCents => 187500;

  // ---- Dashboard metrics (org-level, for leaders) ---------------------------
  static const orgMembers = 1284;
  static const orgNewVisitors = 37;
  static const orgGivingMonth = r'$48,920';
  static const orgGivingDelta = '+12%';
  static const orgUpcomingEvents = 5;
  static const orgVolunteersScheduled = 86;
  static const orgAttendance = 742;
  static const orgAttendanceDelta = '+4%';
  static const orgBudgetUsed = '68%';
  static const orgPledges = r'$312,400';

  static const List<({String text, String time})> recentActivity = [
    (text: '37 new visitors checked in last Sunday', time: '2d ago'),
    (text: 'Easter Celebration reached 642 registrations', time: '3d ago'),
    (text: 'Worship team schedule published for June', time: '4d ago'),
    (text: 'Monthly giving up 12% vs April', time: '5d ago'),
  ];

  static const List<({String month, double value})> givingTrend = [
    (month: 'Jan', value: 0.62),
    (month: 'Feb', value: 0.70),
    (month: 'Mar', value: 0.66),
    (month: 'Apr', value: 0.80),
    (month: 'May', value: 0.92),
  ];
}
