import 'package:flutter/material.dart';
import '../../core/rbac/app_role.dart';

/// Domain models for Altar. Plain immutable value types with `fromJson`
/// factories so they can be wired to Supabase rows later without changing the
/// UI. For Phase 1A they are populated from mock data only.

enum ScheduleStatus { confirmed, pending, declined }

enum EventCategory { worship, youth, community, prayer, kids, special }

enum GivingFundType { general, missions, building }

enum GivingFrequency { oneTime, monthly }

@immutable
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String relationship; // e.g. "Spouse", "Child" — display label key handled in UI
  final String? avatarUrl;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String,
        name: json['name'] as String,
        relationship: json['relationship'] as String,
        avatarUrl: json['avatar_url'] as String?,
      );
}

@immutable
class Ministry {
  const Ministry({
    required this.id,
    required this.name,
    required this.icon,
    this.role,
    this.leaderName = '',
    this.memberCount = 0,
    this.description = '',
  });

  final String id;
  final String name;
  final IconData icon;
  final String? role; // the user's role within this ministry
  final String leaderName;
  final int memberCount;
  final String description;

  factory Ministry.fromJson(Map<String, dynamic> json) => Ministry(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: Icons.groups_rounded,
        role: json['role'] as String?,
        leaderName: json['leader_name'] as String? ?? '',
        memberCount: json['member_count'] as int? ?? 0,
        description: json['description'] as String? ?? '',
      );
}

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
    required this.memberSince,
    this.avatarUrl,
    this.ministries = const [],
    this.family = const [],
    this.givenThisMonthCents = 0,
    this.recurringGiftCents,
  });

  final String id;
  final String fullName;
  final String email;
  final List<AppRole> roles;
  final String memberSince;
  final String? avatarUrl;
  final List<Ministry> ministries;
  final List<FamilyMember> family;
  final int givenThisMonthCents;
  final int? recurringGiftCents;

  String get firstName => fullName.split(' ').first;

  UserProfile copyWith({List<AppRole>? roles}) => UserProfile(
        id: id,
        fullName: fullName,
        email: email,
        roles: roles ?? this.roles,
        memberSince: memberSince,
        avatarUrl: avatarUrl,
        ministries: ministries,
        family: family,
        givenThisMonthCents: givenThisMonthCents,
        recurringGiftCents: recurringGiftCents,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        roles: (json['roles'] as List)
            .map((r) => AppRole.fromId(r as String))
            .toList(),
        memberSince: json['member_since'] as String,
        avatarUrl: json['avatar_url'] as String?,
      );
}

@immutable
class ChurchEvent {
  const ChurchEvent({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.startsAt,
    required this.location,
    required this.category,
    required this.hostMinistry,
    required this.attendeeCount,
    required this.posterColors,
    this.isRegistered = false,
    this.isSpecial = false,
  });

  final String id;
  final String title;
  final String summary;
  final String description;
  final DateTime startsAt;
  final String location;
  final EventCategory category;
  final String hostMinistry;
  final int attendeeCount;

  /// Gradient seed colors for the generated event poster.
  final List<Color> posterColors;
  final bool isRegistered;
  final bool isSpecial;

  factory ChurchEvent.fromJson(Map<String, dynamic> json) => ChurchEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        summary: json['summary'] as String,
        description: json['description'] as String,
        startsAt: DateTime.parse(json['starts_at'] as String),
        location: json['location'] as String,
        category: EventCategory.values.byName(json['category'] as String),
        hostMinistry: json['host_ministry'] as String,
        attendeeCount: json['attendee_count'] as int,
        posterColors: const [],
        isRegistered: json['is_registered'] as bool? ?? false,
        isSpecial: json['is_special'] as bool? ?? false,
      );
}

@immutable
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.postedAt,
    this.pinned = false,
    this.author = 'Altar Church',
  });

  final String id;
  final String title;
  final String body;
  final DateTime postedAt;
  final bool pinned;
  final String author;
}

@immutable
class ScheduleAssignment {
  const ScheduleAssignment({
    required this.id,
    required this.eventTitle,
    required this.role,
    required this.startsAt,
    required this.location,
    required this.status,
    this.team = const [],
    this.ministryId,
    this.ministryName,
  });

  final String id;
  final String eventTitle;
  final String role;
  final DateTime startsAt;
  final String location;
  final ScheduleStatus status;
  final List<String> team;

  /// The ministry/team this assignment belongs to (e.g. "Media Team").
  final String? ministryId;
  final String? ministryName;
}

@immutable
class GivingRecord {
  const GivingRecord({
    required this.id,
    required this.amountCents,
    required this.fund,
    required this.date,
    required this.method,
    this.frequency = GivingFrequency.oneTime,
  });

  final String id;
  final int amountCents;
  final GivingFundType fund;
  final DateTime date;
  final String method;
  final GivingFrequency frequency;
}
