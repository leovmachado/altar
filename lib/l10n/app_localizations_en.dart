// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Altar';

  @override
  String get appTagline => 'Your church, beautifully organized.';

  @override
  String get navHome => 'Home';

  @override
  String get navEvents => 'Events';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navGiving => 'Giving';

  @override
  String get navProfile => 'Profile';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navPeople => 'People';

  @override
  String get navVisitorLeads => 'Visitor Leads';

  @override
  String get navEscala => 'Escala';

  @override
  String get navFinance => 'Finance';

  @override
  String get navMedia => 'Media';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionViewAll => 'View all';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionShare => 'Share';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get labelToday => 'Today';

  @override
  String get labelThisWeek => 'This week';

  @override
  String get labelThisMonth => 'This month';

  @override
  String get labelUpcoming => 'Upcoming';

  @override
  String get labelPast => 'Past';

  @override
  String get authWelcome => 'Welcome to Altar';

  @override
  String get authSubtitle => 'Sign in to continue to your church.';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'you@church.org';

  @override
  String get authPassword => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authGoogle => 'Continue with Google';

  @override
  String get authApple => 'Continue with Apple';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authMockNotice =>
      'Demo mode — authentication is mocked. Tap any option to enter.';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeGoodMorning => 'Good morning';

  @override
  String get homeGoodAfternoon => 'Good afternoon';

  @override
  String get homeGoodEvening => 'Good evening';

  @override
  String get homeSpecialEvents => 'Special events';

  @override
  String get homeAnnouncements => 'Announcements';

  @override
  String get homeServingTitle => 'You\'re scheduled to serve';

  @override
  String homeServingBody(String role, String eventName, String date) {
    return '$role at $eventName · $date';
  }

  @override
  String get homeServingCta => 'View assignment';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get homeQuickGive => 'Give';

  @override
  String get homeQuickCheckIn => 'Check in';

  @override
  String get homeQuickEvents => 'Events';

  @override
  String get homeQuickSchedule => 'My schedule';

  @override
  String get homeGivingCardTitle => 'Your generosity';

  @override
  String get homeGivingCardSubtitle => 'Thank you for giving this month';

  @override
  String get homeGivingCardCta => 'Give now';

  @override
  String get homeForYou => 'For you';

  @override
  String get eventsTitle => 'Events';

  @override
  String get eventsUpcoming => 'Upcoming';

  @override
  String get eventsPast => 'Past';

  @override
  String get eventsRegister => 'Register';

  @override
  String get eventsRegistered => 'You\'re registered';

  @override
  String get eventsDetails => 'Details';

  @override
  String get eventsAbout => 'About this event';

  @override
  String get eventsLocation => 'Location';

  @override
  String get eventsWhen => 'When';

  @override
  String eventsAttendees(int count) {
    return '$count going';
  }

  @override
  String get eventsRegistrationCta => 'Save my spot';

  @override
  String get eventsAddToCalendar => 'Add to calendar';

  @override
  String eventsHosted(String ministry) {
    return 'Hosted by $ministry';
  }

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get scheduleMyAssignments => 'My assignments';

  @override
  String get scheduleAvailability => 'Availability';

  @override
  String get scheduleTeam => 'Team';

  @override
  String get scheduleConfirm => 'Confirm';

  @override
  String get scheduleDecline => 'Decline';

  @override
  String get scheduleConfirmed => 'Confirmed';

  @override
  String get schedulePending => 'Pending';

  @override
  String get scheduleDeclined => 'Declined';

  @override
  String get scheduleRoleLabel => 'Role';

  @override
  String get scheduleAvailablePrompt => 'Set your availability';

  @override
  String get scheduleAvailable => 'Available';

  @override
  String get scheduleUnavailable => 'Unavailable';

  @override
  String get scheduleLeaderEditor => 'Schedule editor';

  @override
  String get scheduleLeaderEditorSubtitle =>
      'Drag volunteers into roles, then preview before publishing.';

  @override
  String get schedulePreviewChanges => 'Preview changes';

  @override
  String get schedulePublish => 'Publish schedule';

  @override
  String get scheduleUnassigned => 'Unassigned roles';

  @override
  String get scheduleDraft => 'Draft';

  @override
  String get scheduleNextServe => 'Next time you serve';

  @override
  String get givingTitle => 'Giving';

  @override
  String get givingGiveNow => 'Give now';

  @override
  String get givingAmount => 'Amount';

  @override
  String get givingFund => 'Fund';

  @override
  String get givingFrequency => 'Frequency';

  @override
  String get givingOneTime => 'One time';

  @override
  String get givingMonthly => 'Monthly';

  @override
  String get givingFundGeneral => 'General fund';

  @override
  String get givingFundMissions => 'Missions';

  @override
  String get givingFundBuilding => 'Building fund';

  @override
  String get givingHistory => 'Giving history';

  @override
  String get givingYearToDate => 'Year to date';

  @override
  String get givingTaxStatement => 'Download tax statement';

  @override
  String get givingMethod => 'Payment method';

  @override
  String get givingSecure => 'Secured by Altar · demo only';

  @override
  String get givingThisMonth => 'Given this month';

  @override
  String get givingRecurring => 'Recurring gift';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileFamily => 'Family';

  @override
  String get profileMinistries => 'My ministries';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profileHelp => 'Help & support';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileRoles => 'Roles';

  @override
  String profileMemberSince(String year) {
    return 'Member since $year';
  }

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSystem => 'System default';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String dashWelcome(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get dashMembers => 'Members';

  @override
  String get dashNewVisitors => 'New visitors';

  @override
  String get dashGivingMonth => 'Giving this month';

  @override
  String get dashUpcomingEvents => 'Upcoming events';

  @override
  String get dashVolunteersScheduled => 'Volunteers scheduled';

  @override
  String get dashAttendance => 'Avg. attendance';

  @override
  String get dashGrowth => 'Growth';

  @override
  String get dashTeamHealth => 'Team health';

  @override
  String get dashRecentActivity => 'Recent activity';

  @override
  String get dashGivingTrend => 'Giving trend';

  @override
  String get dashServingThisWeek => 'Serving this week';

  @override
  String get dashMyTeam => 'My team';

  @override
  String get dashOpenRoles => 'Open roles';

  @override
  String get dashBudgetUsed => 'Budget used';

  @override
  String get dashPledges => 'Pledges';

  @override
  String get dashVsLastMonth => 'vs last month';

  @override
  String get roleSuperAdmin => 'Super Admin';

  @override
  String get roleLeadPastor => 'Lead Pastor';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMinistryLeader => 'Ministry Leader';

  @override
  String get roleVolunteer => 'Volunteer';

  @override
  String get roleMember => 'Member';

  @override
  String get roleVisitor => 'Visitor';

  @override
  String get roleTreasurer => 'Treasurer';

  @override
  String get roleFinancialLeader => 'Financial Leader';

  @override
  String get roleMediaLeader => 'Media Leader';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String comingSoonBody(String module) {
    return '$module is part of the Altar platform and will be available in a later phase.';
  }

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody =>
      'When there\'s something to show, it\'ll appear here.';
}
