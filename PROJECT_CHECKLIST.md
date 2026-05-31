# Altar / ChurchOS — Project Checklist

Legend: ✅ done · 🟡 partial / mock · ⬜ not started (future phase)

---

## Phase 1A — Frontend Foundation & Design Approval

### Project & architecture
- ✅ Flutter project created (web, iOS, Android, macOS)
- ✅ Clean **feature-based** architecture (`app/ core/ data/ features/`)
- ✅ Riverpod state management wired (`ProviderScope`)
- ✅ go_router navigation with auth redirect + shell route
- ✅ `PROJECT_CHECKLIST.md`, `DEVELOPMENT_LOG.md`, `SYSTEM_ARCHITECTURE.md`

### Supabase-ready (NOT connected)
- ✅ Repository interfaces + `Mock*` implementations behind providers
- ✅ `data/supabase/supabase_config.dart` seam (env-based, no credentials)
- ⬜ Supabase connection / initialization *(future phase — intentionally absent)*
- ⬜ Database migrations *(future phase)*

### Mock authentication scaffolding
- ✅ Email / password placeholder
- ✅ Google placeholder
- ✅ Apple placeholder
- ✅ Mock logged-in user + sign-out + auth redirect

### Navigation shell
- ✅ Mobile bottom nav: Home · Events · Schedule · Giving · Profile
- ✅ Desktop side rail: Dashboard · People · Visitor Leads · Events · Escala · Finance · Media · Reports · Settings
- ✅ Responsive switch by breakpoint
- ✅ RBAC-filtered desktop rail items

### Altar design system
- ✅ Centralized theme (light primary + dark foundation)
- ✅ Teal / aqua / green palette + brand gradient
- ✅ Glass cards + soft blur + rounded corners
- ✅ Subtle glow / shadow accents + ambient glow background
- ✅ Clean typography (Plus Jakarta Sans + Inter), spacious layouts
- ✅ Reusable components (GlassCard, AltarButton, StatCard, badges, avatar…)

### Localization
- ✅ English + Portuguese ARB files (generated `AppLocalizations`)
- ✅ No hardcoded user-facing strings
- ✅ Live in-app language switcher (Profile + Settings + Demo menu)

### RBAC foundation
- ✅ 10 roles; users can hold multiple roles
- ✅ Permission matrix (union across roles)
- ✅ `RbacService` (no inline role checks in widgets)
- ✅ Role-based dashboard placeholders

### Mock dashboards
- ✅ Member
- ✅ Volunteer
- ✅ Ministry Leader
- ✅ Lead Pastor
- ✅ Financial Leader

### Screens (mock data)
- ✅ **Home** — special events, announcements, "scheduled to serve" banner, quick actions, giving card, role-based sections
- ✅ **Events** — list, details, poster, registration CTA
- ✅ **Schedule (Escala)** — volunteer schedule, assignment cards, availability placeholder, leader editor mockup, preview changes mockup
- ✅ **Giving** — mock giving screen
- ✅ **Profile** — family, ministries, language selector, settings
- 🟡 **Settings** — live language + theme (other settings deferred)
- 🟡 **People / Visitor Leads / Finance / Media / Reports** — branded "coming soon" placeholders

### Quality gates
- ✅ `flutter analyze` clean
- ✅ App runs on Web (Chrome) and macOS desktop
- ✅ Mobile + desktop layouts verified responsive

---

## Deferred to later phases (out of scope for 1A)
⬜ Supabase connection & migrations · ⬜ People/CRM · ⬜ Visitor Leads ·
⬜ Scheduling logic · ⬜ Finance workflows · ⬜ Stripe · ⬜ QuickBooks ·
⬜ AI features · ⬜ Push notifications · ⬜ Calendar sync
