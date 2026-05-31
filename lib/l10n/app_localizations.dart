import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Altar'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your church, beautifully organized.'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navGiving.
  ///
  /// In en, this message translates to:
  /// **'Giving'**
  String get navGiving;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navVisitorLeads.
  ///
  /// In en, this message translates to:
  /// **'Visitor Leads'**
  String get navVisitorLeads;

  /// No description provided for @navEscala.
  ///
  /// In en, this message translates to:
  /// **'Escala'**
  String get navEscala;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @navMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get navMedia;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @labelToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get labelToday;

  /// No description provided for @labelThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get labelThisWeek;

  /// No description provided for @labelThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get labelThisMonth;

  /// No description provided for @labelUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get labelUpcoming;

  /// No description provided for @labelPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get labelPast;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Altar'**
  String get authWelcome;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your church.'**
  String get authSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@church.org'**
  String get authEmailHint;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogle;

  /// No description provided for @authApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authApple;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authMockNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — authentication is mocked. Tap any option to enter.'**
  String get authMockNotice;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGoodMorning;

  /// No description provided for @homeGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGoodAfternoon;

  /// No description provided for @homeGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGoodEvening;

  /// No description provided for @homeSpecialEvents.
  ///
  /// In en, this message translates to:
  /// **'Special events'**
  String get homeSpecialEvents;

  /// No description provided for @homeAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get homeAnnouncements;

  /// No description provided for @homeServingTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re scheduled to serve'**
  String get homeServingTitle;

  /// No description provided for @homeServingBody.
  ///
  /// In en, this message translates to:
  /// **'{role} at {eventName} · {date}'**
  String homeServingBody(String role, String eventName, String date);

  /// No description provided for @homeServingCta.
  ///
  /// In en, this message translates to:
  /// **'View assignment'**
  String get homeServingCta;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// No description provided for @homeQuickGive.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get homeQuickGive;

  /// No description provided for @homeQuickCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get homeQuickCheckIn;

  /// No description provided for @homeQuickEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get homeQuickEvents;

  /// No description provided for @homeQuickSchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get homeQuickSchedule;

  /// No description provided for @homeGivingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your generosity'**
  String get homeGivingCardTitle;

  /// No description provided for @homeGivingCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for giving this month'**
  String get homeGivingCardSubtitle;

  /// No description provided for @homeGivingCardCta.
  ///
  /// In en, this message translates to:
  /// **'Give now'**
  String get homeGivingCardCta;

  /// No description provided for @homeForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get homeForYou;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @eventsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventsUpcoming;

  /// No description provided for @eventsPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get eventsPast;

  /// No description provided for @eventsRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get eventsRegister;

  /// No description provided for @eventsRegistered.
  ///
  /// In en, this message translates to:
  /// **'You\'re registered'**
  String get eventsRegistered;

  /// No description provided for @eventsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get eventsDetails;

  /// No description provided for @eventsAbout.
  ///
  /// In en, this message translates to:
  /// **'About this event'**
  String get eventsAbout;

  /// No description provided for @eventsLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventsLocation;

  /// No description provided for @eventsWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get eventsWhen;

  /// No description provided for @eventsAttendees.
  ///
  /// In en, this message translates to:
  /// **'{count} going'**
  String eventsAttendees(int count);

  /// No description provided for @eventsRegistrationCta.
  ///
  /// In en, this message translates to:
  /// **'Save my spot'**
  String get eventsRegistrationCta;

  /// No description provided for @eventsAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get eventsAddToCalendar;

  /// No description provided for @eventsHosted.
  ///
  /// In en, this message translates to:
  /// **'Hosted by {ministry}'**
  String eventsHosted(String ministry);

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleMyAssignments.
  ///
  /// In en, this message translates to:
  /// **'My assignments'**
  String get scheduleMyAssignments;

  /// No description provided for @scheduleAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get scheduleAvailability;

  /// No description provided for @scheduleTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get scheduleTeam;

  /// No description provided for @scheduleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get scheduleConfirm;

  /// No description provided for @scheduleDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get scheduleDecline;

  /// No description provided for @scheduleConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get scheduleConfirmed;

  /// No description provided for @schedulePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get schedulePending;

  /// No description provided for @scheduleDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get scheduleDeclined;

  /// No description provided for @scheduleRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get scheduleRoleLabel;

  /// No description provided for @scheduleAvailablePrompt.
  ///
  /// In en, this message translates to:
  /// **'Set your availability'**
  String get scheduleAvailablePrompt;

  /// No description provided for @scheduleAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get scheduleAvailable;

  /// No description provided for @scheduleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get scheduleUnavailable;

  /// No description provided for @scheduleLeaderEditor.
  ///
  /// In en, this message translates to:
  /// **'Schedule editor'**
  String get scheduleLeaderEditor;

  /// No description provided for @scheduleLeaderEditorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag volunteers into roles, then preview before publishing.'**
  String get scheduleLeaderEditorSubtitle;

  /// No description provided for @schedulePreviewChanges.
  ///
  /// In en, this message translates to:
  /// **'Preview changes'**
  String get schedulePreviewChanges;

  /// No description provided for @schedulePublish.
  ///
  /// In en, this message translates to:
  /// **'Publish schedule'**
  String get schedulePublish;

  /// No description provided for @scheduleUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned roles'**
  String get scheduleUnassigned;

  /// No description provided for @scheduleDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get scheduleDraft;

  /// No description provided for @scheduleNextServe.
  ///
  /// In en, this message translates to:
  /// **'Next time you serve'**
  String get scheduleNextServe;

  /// No description provided for @givingTitle.
  ///
  /// In en, this message translates to:
  /// **'Giving'**
  String get givingTitle;

  /// No description provided for @givingGiveNow.
  ///
  /// In en, this message translates to:
  /// **'Give now'**
  String get givingGiveNow;

  /// No description provided for @givingAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get givingAmount;

  /// No description provided for @givingFund.
  ///
  /// In en, this message translates to:
  /// **'Fund'**
  String get givingFund;

  /// No description provided for @givingFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get givingFrequency;

  /// No description provided for @givingOneTime.
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get givingOneTime;

  /// No description provided for @givingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get givingMonthly;

  /// No description provided for @givingFundGeneral.
  ///
  /// In en, this message translates to:
  /// **'General fund'**
  String get givingFundGeneral;

  /// No description provided for @givingFundMissions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get givingFundMissions;

  /// No description provided for @givingFundBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building fund'**
  String get givingFundBuilding;

  /// No description provided for @givingHistory.
  ///
  /// In en, this message translates to:
  /// **'Giving history'**
  String get givingHistory;

  /// No description provided for @givingYearToDate.
  ///
  /// In en, this message translates to:
  /// **'Year to date'**
  String get givingYearToDate;

  /// No description provided for @givingTaxStatement.
  ///
  /// In en, this message translates to:
  /// **'Download tax statement'**
  String get givingTaxStatement;

  /// No description provided for @givingMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get givingMethod;

  /// No description provided for @givingSecure.
  ///
  /// In en, this message translates to:
  /// **'Secured by Altar · demo only'**
  String get givingSecure;

  /// No description provided for @givingThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Given this month'**
  String get givingThisMonth;

  /// No description provided for @givingRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring gift'**
  String get givingRecurring;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get profileFamily;

  /// No description provided for @profileMinistries.
  ///
  /// In en, this message translates to:
  /// **'My ministries'**
  String get profileMinistries;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get profileHelp;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get profileRoles;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String profileMemberSince(String year);

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String dashWelcome(String name);

  /// No description provided for @dashMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get dashMembers;

  /// No description provided for @dashNewVisitors.
  ///
  /// In en, this message translates to:
  /// **'New visitors'**
  String get dashNewVisitors;

  /// No description provided for @dashGivingMonth.
  ///
  /// In en, this message translates to:
  /// **'Giving this month'**
  String get dashGivingMonth;

  /// No description provided for @dashUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get dashUpcomingEvents;

  /// No description provided for @dashVolunteersScheduled.
  ///
  /// In en, this message translates to:
  /// **'Volunteers scheduled'**
  String get dashVolunteersScheduled;

  /// No description provided for @dashAttendance.
  ///
  /// In en, this message translates to:
  /// **'Avg. attendance'**
  String get dashAttendance;

  /// No description provided for @dashGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get dashGrowth;

  /// No description provided for @dashTeamHealth.
  ///
  /// In en, this message translates to:
  /// **'Team health'**
  String get dashTeamHealth;

  /// No description provided for @dashRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashRecentActivity;

  /// No description provided for @dashGivingTrend.
  ///
  /// In en, this message translates to:
  /// **'Giving trend'**
  String get dashGivingTrend;

  /// No description provided for @dashServingThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Serving this week'**
  String get dashServingThisWeek;

  /// No description provided for @dashMyTeam.
  ///
  /// In en, this message translates to:
  /// **'My team'**
  String get dashMyTeam;

  /// No description provided for @dashOpenRoles.
  ///
  /// In en, this message translates to:
  /// **'Open roles'**
  String get dashOpenRoles;

  /// No description provided for @dashBudgetUsed.
  ///
  /// In en, this message translates to:
  /// **'Budget used'**
  String get dashBudgetUsed;

  /// No description provided for @dashPledges.
  ///
  /// In en, this message translates to:
  /// **'Pledges'**
  String get dashPledges;

  /// No description provided for @dashVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get dashVsLastMonth;

  /// No description provided for @roleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get roleSuperAdmin;

  /// No description provided for @roleLeadPastor.
  ///
  /// In en, this message translates to:
  /// **'Lead Pastor'**
  String get roleLeadPastor;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleMinistryLeader.
  ///
  /// In en, this message translates to:
  /// **'Ministry Leader'**
  String get roleMinistryLeader;

  /// No description provided for @roleVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get roleVolunteer;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleVisitor.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get roleVisitor;

  /// No description provided for @roleTreasurer.
  ///
  /// In en, this message translates to:
  /// **'Treasurer'**
  String get roleTreasurer;

  /// No description provided for @roleFinancialLeader.
  ///
  /// In en, this message translates to:
  /// **'Financial Leader'**
  String get roleFinancialLeader;

  /// No description provided for @roleMediaLeader.
  ///
  /// In en, this message translates to:
  /// **'Media Leader'**
  String get roleMediaLeader;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'{module} is part of the Altar platform and will be available in a later phase.'**
  String comingSoonBody(String module);

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'When there\'s something to show, it\'ll appear here.'**
  String get emptyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
