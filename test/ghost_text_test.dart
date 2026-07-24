import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_text/ghost_text.dart';

void main() {
  testWidgets('GhostFont widget builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GhostFont(text: 'Test'),
    );
    expect(find.byType(GhostFont), findsOneWidget);
  });
}
