# Altar / ChurchOS — System Architecture

> **Phase 1A — Frontend Foundation (Mock Data Only).**
> This document describes the architecture established in Phase 1A. No backend,
> Supabase connection, or feature business logic exists yet — every data source
> is an in-memory mock behind a repository interface.

---

## 1. Tech stack

| Concern            | Choice                          | Why |
|--------------------|---------------------------------|-----|
| Framework          | Flutter 3.41 (Dart 3.11)        | One codebase → iOS, Android, Web, macOS |
| State management   | `flutter_riverpod` 2.x          | Compile-safe DI, testable, no `BuildContext` coupling |
| Routing            | `go_router` 14.x                | Declarative, deep-link ready, shell routes for the nav frame |
| Localization       | `flutter_localizations` + ARB   | Generated, type-safe `AppLocalizations`; EN + PT |
| Typography         | `google_fonts`                  | Plus Jakarta Sans (display) + Inter (body) |
| Backend (future)   | Supabase (NOT connected)        | Seam defined in `data/supabase/` |

---

## 2. Architectural principles

1. **Feature-based structure.** Code is grouped by feature (`features/home`,
   `features/events`, …) over a shared `core/` (design system, navigation,
   RBAC, responsive) and `data/` (models, mock, repositories).
2. **UI depends on interfaces, never on data sources.** Screens read
   repositories through Riverpod providers. Swapping `Mock*Repository` for
   `Supabase*Repository` later requires zero screen changes.
3. **No business logic in widgets.** Authorization lives in `RbacService`;
   data shaping lives in repositories/models. Widgets render and dispatch.
4. **No hardcoded permissions in widgets.** UI gates call
   `rbac.can(AppPermission.x)` — roles are never checked inline.
5. **No hardcoded user-facing strings.** All copy flows through
   `context.l10n.<key>` (EN/PT ARB files).
6. **Centralized design system.** One source of truth for color, type,
   spacing, radius, shadow and reusable glass components.

---

## 3. Folder structure

```
lib/
├── main.dart                       # Entry — wraps app in ProviderScope (mock only)
├── l10n/                           # ARB sources + generated AppLocalizations
│   ├── app_en.arb  app_pt.arb
│   └── app_localizations*.dart     # generated
├── app/                            # App wiring
│   ├── app.dart                    # MaterialApp.router (theme + locale + router)
│   ├── router.dart                 # GoRouter: auth redirect + ShellRoute
│   ├── auth_controller.dart        # MOCK auth (StateNotifier)
│   └── providers.dart              # Riverpod providers (repos, rbac, locale, theme)
├── core/
│   ├── design/                     # Design tokens + theme
│   │   ├── app_colors.dart         # palette + AltarColors ThemeExtension
│   │   ├── app_tokens.dart         # spacing / radii / shadows / motion
│   │   ├── app_typography.dart     # text theme
│   │   └── app_theme.dart          # light + dark ThemeData
│   ├── design_system.dart          # barrel export for screens
│   ├── widgets/                    # GlassCard, AltarButton, StatCard, badges…
│   ├── responsive/                 # breakpoints + ResponsiveBuilder + ContentBounds
│   ├── navigation/                 # routes.dart + app_shell.dart (responsive frame)
│   ├── localization/               # context.l10n extension
│   └── rbac/                       # app_role.dart, permissions.dart, rbac_service.dart
├── data/
│   ├── models/models.dart          # immutable domain models + fromJson
│   ├── mock/mock_data.dart         # ALL Phase 1A demo content
│   ├── repositories/repositories.dart # interfaces + Mock* implementations
│   └── supabase/supabase_config.dart  # future seam (NOT connected)
└── features/                       # one folder per feature screen
    ├── auth/ home/ dashboard/ events/ schedule/ giving/ profile/
    ├── settings/                   # live language + theme controls
    └── placeholders/               # People / Visitor Leads / Finance / Media / Reports
```

---

## 4. Design system

- **Palette:** teal `#0FB5A6`, aqua `#2DD4BF`, green `#10B981` brand gradient
  over a cool-slate neutral ramp. Light mode is primary; a complete dark theme
  is provided. Brand-aware tokens (glass fill, glass border, glow, borders,
  ink levels) live in the `AltarColors` `ThemeExtension`, read via
  `context.altar`.
- **Type:** Plus Jakarta Sans for display/headings, Inter for body/UI, with
  tightened tracking on large sizes for a modern SaaS feel.
- **Tokens:** `AppSpacing` (4-pt grid), `AppRadii` (generous rounding),
  `AppShadows` (soft + brand glow), `AppMotion`.
- **Signature components:** `GlassCard` (frosted blur + hairline border +
  soft shadow), `AltarButton` (gradient primary / secondary / ghost),
  `StatCard`, `SectionHeader`, `StatusBadge`, `AltarAvatar`, `GlowBackground`
  (ambient aurora), `BrandLogo`, `EmptyState`, `ComingSoonView`.

---

## 5. Navigation

A single responsive `AppShell` (wrapped by a `go_router` `ShellRoute`) renders:

- **Mobile (< 1024px):** glass bottom `NavigationBar` —
  Home · Events · Schedule · Giving · Profile.
- **Desktop (≥ 1024px):** glass side rail —
  Dashboard · People · Visitor Leads · Events · Escala · Finance · Media ·
  Reports · Settings. Rail items are filtered by RBAC permission.

`EventDetailScreen` is pushed full-screen outside the shell. A **Demo
controls** menu (in the app bar / rail footer) lets reviewers switch the
role-tailored dashboard persona, language, and theme without leaving the app.

---

## 6. RBAC

- `AppRole` — the 10 roles (super_admin, lead_pastor, admin, ministry_leader,
  volunteer, member, visitor, treasurer, financial_leader, media_leader), each
  with a stable `id` (Supabase-ready) and a `rank`.
- A user holds **multiple roles**; effective permissions are the **union** of
  each role's permission set (`kRolePermissions`).
- `RbacService(roles)` answers `can(permission)`, `hasRole`, `primaryRole`, and
  `dashboardType` — consumed by navigation and screens, never inlined.
- `DashboardType` selects which role-tailored dashboard renders
  (member / volunteer / ministry leader / lead pastor / financial leader).

---

## 7. Data flow (Phase 1A and beyond)

```
Widget ──watch──▶ Provider ──▶ Repository (interface)
                                   │
                Phase 1A:          ├─▶ Mock*Repository ──▶ MockData (in-memory)
                Later:             └─▶ Supabase*Repository ──▶ Supabase (Postgres/Auth/Storage)
```

The provider overrides in `app/providers.dart` are the **only** place that
changes when the backend lands.

### Planned Supabase wiring (future phase, documented only)
1. Add `supabase_flutter` to `pubspec.yaml`.
2. Inject `SUPABASE_URL` / `SUPABASE_ANON_KEY` via `--dart-define`
   (`SupabaseConfig` already reads these; never hardcode credentials).
3. `Supabase.initialize(...)` in `main()` guarded by `SupabaseConfig.isConfigured`.
4. Implement `Supabase*Repository` against the existing interfaces.
5. Replace the mock provider overrides. No screen edits required.

---

## 8. Explicitly NOT in Phase 1A

Supabase connection · DB migrations · People/CRM · Visitor Leads · scheduling
logic · finance workflows · Stripe · QuickBooks · AI features · push
notifications · calendar sync. The navigation surfaces for these exist as
branded "coming soon" placeholders only.
