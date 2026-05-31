/// Supabase wiring placeholder — INTENTIONALLY NOT CONNECTED in Phase 1A.
///
/// This file documents the seam where Supabase will plug in later. No package
/// dependency, no credentials, and no network calls exist yet. When the backend
/// phase begins:
///   1. add `supabase_flutter` to pubspec.yaml,
///   2. populate [url] / [anonKey] from `--dart-define` (never hardcode),
///   3. call `Supabase.initialize(...)` in `main()` behind [isConfigured],
///   4. provide `Supabase*Repository` implementations of the interfaces in
///      `repositories.dart` and swap the provider overrides in `app.dart`.
class SupabaseConfig {
  SupabaseConfig._();

  /// Read from the environment at build time — empty in Phase 1A.
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Phase 1A always returns false → the app runs fully on mock data.
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
