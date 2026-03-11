import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disease_surveillance_app/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DiseaseApp()),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(DiseaseApp), findsOneWidget);
  });
}
