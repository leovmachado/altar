import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  // Phase 1A runs entirely on mock data — no Supabase / backend initialization.
  runApp(const ProviderScope(child: AltarApp()));
}
