# Altar / ChurchOS

A premium church operating system built with **Flutter** (iOS · Android · Web ·
macOS) and, in a later phase, **Supabase**.

> **Status: Phase 1A — Frontend Foundation & Design Approval.**
> The app runs entirely on **mock data**. No backend is connected. The goal of
> this phase is to approve the design language, branding, navigation,
> responsiveness, dashboards and overall UX before any backend work begins.

## Run it

```bash
flutter pub get

# Web (Chrome)
flutter run -d chrome

# macOS desktop
flutter run -d macos

# iOS / Android (with a simulator/device running)
flutter run
```

There are **no credentials or environment variables** required in Phase 1A.

On the **login screen**, tap **Sign in**, **Continue with Google**, or
**Continue with Apple** — all are mock placeholders that drop you into the demo
as a signed-in user.

## Exploring the demo

Use the **Demo controls** menu (the tune/slider icon in the top bar on mobile,
or the side-rail footer on desktop) to:

- **Preview a role-tailored dashboard** — Member, Volunteer, Ministry Leader,
  Lead Pastor, Financial Leader.
- **Switch language** — English / Português (live).
- **Toggle light / dark theme.**

Resize the window (web/desktop) to see the responsive switch between the mobile
bottom-nav layout and the desktop side-rail layout.

## Project layout & architecture

See [`SYSTEM_ARCHITECTURE.md`](SYSTEM_ARCHITECTURE.md). Progress is tracked in
[`PROJECT_CHECKLIST.md`](PROJECT_CHECKLIST.md) and decisions in
[`DEVELOPMENT_LOG.md`](DEVELOPMENT_LOG.md).

## Localization

Strings live in `lib/l10n/app_en.arb` and `lib/l10n/app_pt.arb`. After editing,
regenerate with:

```bash
flutter gen-l10n
```
