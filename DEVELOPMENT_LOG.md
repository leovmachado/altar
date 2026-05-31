# Altar / ChurchOS — Development Log

## 2026-05-30 — Phase 1A: Frontend Foundation & Design Approval

**Goal:** production-ready frontend foundation on **mock data only**, to approve
design language, branding, navigation, responsiveness, dashboards, hierarchy
and UX before any backend work.

### Done
- **Project init:** `flutter create` for web/iOS/Android/macOS. Added
  `flutter_riverpod`, `go_router`, `google_fonts`, `intl`, `flutter_localizations`.
- **Localization:** `l10n.yaml` + `app_en.arb` / `app_pt.arb` with the full key
  set defined up front (so no screen hardcodes strings). Generated
  `AppLocalizations`; added `context.l10n` extension.
- **Design system:** color palette + `AltarColors` ThemeExtension, spacing/radii/
  shadow/motion tokens, Plus Jakarta Sans + Inter typography, light + dark
  `ThemeData`. Components: `GlassCard`, `AltarButton`, `StatCard`,
  `SectionHeader`, `StatusBadge`, `AltarAvatar`, `GlowBackground`, `BrandLogo`,
  `EmptyState`, `ComingSoonView`. Barrel: `core/design_system.dart`.
- **Responsive:** breakpoints (mobile <1024, desktop ≥1024), `ResponsiveBuilder`,
  `ContentBounds`, `context.isMobile/isDesktop`.
- **RBAC:** `AppRole` (10 roles, multi-role), `AppPermission`, permission matrix,
  `RbacService` (union of role permissions; `dashboardType`/`primaryRole`).
- **Data layer:** immutable models + `fromJson`; `MockData` (users per dashboard,
  events, announcements, assignments, roster draft, giving, org metrics);
  repository interfaces + `Mock*` impls behind Riverpod providers.
- **Supabase seam:** `SupabaseConfig` reads env vars — intentionally NOT
  connected; documented future wiring in `SYSTEM_ARCHITECTURE.md`.
- **Mock auth:** `AuthController` (email/Google/Apple placeholders → mock user),
  sign-out, demo `previewDashboard()` persona switcher.
- **Navigation shell:** responsive `AppShell` — mobile glass bottom bar (5 tabs),
  desktop glass side rail (9 RBAC-filtered destinations), demo controls menu.
- **Router:** `go_router` with signed-out → `/login` redirect and `ShellRoute`.
- **Screens:** login (full), Settings (live language/theme), 5 placeholder
  modules. Built the seven rich screens (Home, Dashboard with 5 role personas,
  Events, Event Detail, Schedule/Escala, Giving, Profile) via a parallel
  multi-agent **workflow** against a fixed design-system contract, then
  integrated and analyzer-checked.

### Engineering notes / decisions
- Screens render **body only**; the shell owns chrome (background, app bar,
  nav) for visual consistency. Event detail owns its Scaffold (pushed route).
- All ARB keys were authored before screen generation to keep parallel agents
  consistent and avoid localization races.
- Light mode is the primary target; dark mode is a complete foundation toggled
  live from the demo menu / settings.

### Verification & bugs fixed during review
- `flutter analyze` clean; widget smoke test passes; built for Web (release) and
  captured screenshots of every screen at desktop (1440×900) and mobile widths.
- **Bug 1 — `ContentBounds` starved siblings of height.** It used `Center`,
  which expands to fill bounded vertical constraints; inside a
  `Scaffold.bottomNavigationBar` (Event Detail) it grew to full height and left
  the scroll body with 0 height (poster + content never laid out). Fixed by
  switching to `Align(heightFactor: 1.0)` so it sizes to its content. Verified
  via a render-size probe (body went from `Size(800, 0)` → `Size(800, 481)`).
- **Bug 2 — `GlowBackground` could collapse.** Its `Stack` had only positioned
  children, which can collapse to zero under loose constraints. Hardened with a
  non-positioned content child + `StackFit.expand`.

### Still mock / local only
- Authentication, all data (events, schedule, giving, people, metrics).
- Buttons like "Register", "Give now", "Confirm/Decline", "Publish schedule"
  are visual/placeholder — no persistence or network.

## 2026-05-30 — Phase 1A quick UI/navigation fixes

- **Mobile login no longer scrolls.** Compact spacing on phones + an adaptive
  layout (`LayoutBuilder` + `ConstrainedBox(minHeight)` + `ClampingScrollPhysics`)
  so the card centers and fits a normal iPhone viewport (verified
  `maxScrollExtent == 0` on iPhone 14/15/16/Pro Max) while still scrolling as an
  overflow safety net on tiny devices / when the keyboard is open (0 overflow
  errors everywhere). Desktop login unchanged. File: `features/auth/login_screen.dart`.
- **Removed Quick Actions from Home.** Deleted the `_QuickActions`/`_QuickAction`
  widgets and their use; all other Home sections kept (serving banner, special
  events, giving/generosity card, announcements). File: `features/home/home_screen.dart`.
- **Removed Giving from primary navigation.** Dropped the Giving destination from
  the mobile bottom bar (now Home · Events · Serving · Profile). Desktop rail never
  contained Giving. The `/giving` route + screen remain as a hidden placeholder
  reachable from in-app cards. File: `core/navigation/routes.dart`.
- **Renamed the "Schedule" / "Escala" nav label to "Serving"** (EN `Serving`,
  PT `Servir`) across the mobile bar, desktop rail, page titles, and the
  dashboard's schedule button. Routes, folders, and internal `schedule`
  terminology intentionally unchanged. Files: `l10n/app_en.arb`, `l10n/app_pt.arb`
  (regenerated `AppLocalizations`).
- Verified: `flutter analyze` clean, widget tests pass, dedicated probe tests
  (since removed) confirmed nav composition + no-scroll, and screenshots re-captured.

## 2026-05-31 — Ministry hub restructure

- **Renamed the primary tab "Serving" → "Ministry"** (EN `Ministry`, PT `Ministério`)
  across the mobile bar, desktop rail, page title and the dashboard button;
  swapped the tab icon to `diversity_3`. Routes/folders/internal `schedule`
  terminology unchanged. Files: `l10n/app_en.arb`, `l10n/app_pt.arb`,
  `core/navigation/routes.dart`.
- **Ministry tab is now a hub** (`features/ministry/ministry_hub_screen.dart`):
  a slim "you're serving next" strip, a clickable list of the user's ministries,
  and a prominent **My Full Schedule** button.
- **New Ministry detail page** (`features/ministry/ministry_detail_screen.dart`,
  pushed `/ministry/:id`): name, leader, member count, your role, upcoming
  assignments, About, and placeholder Resources.
- **Full Schedule page** (`features/schedule/full_schedule_screen.dart`, pushed
  `/full-schedule`, replaces the old `schedule_screen.dart`): **List** tab
  (assignment cards + availability + leader editor — reused from the old screen)
  and a **Calendar** tab with a hand-built month grid that **highlights
  scheduled days in the Altar teal/green** + a legend. Tab is deep-linkable via
  `?tab=calendar`.
- **Data:** `Ministry` gained `leaderName` / `memberCount` / `description`;
  `ScheduleAssignment` gained `ministryId` / `ministryName`; mock ministries are
  now Media Team / Worship Team / Kids Ministry with `MockData.ministries`,
  `ministryById`, `assignmentsForMinistry` helpers.
- Verified: `flutter analyze` clean, widget tests pass, probe tests confirmed the
  nav label, hub/detail content, and calendar highlighting (caught + fixed a
  32px `StatusBadge` overflow in the detail header), screenshots captured.

### Next phase (not started)
- Connect Supabase (auth + Postgres + storage), migrations, then build People,
  Visitor Leads, scheduling logic, finance, and integrations.
