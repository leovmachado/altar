import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:altar/app/app.dart';

void main() {
  testWidgets('Altar app boots', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AltarApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
