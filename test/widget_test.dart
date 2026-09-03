import 'package:flutter_test/flutter_test.dart';
import 'package:maa_tara/main.dart';

void main() {
  testWidgets('App smoke test mounts MyApp properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
