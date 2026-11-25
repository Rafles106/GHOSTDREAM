import 'package:flutter_test/flutter_test.dart';
import 'package:poliride_penumpang/main.dart';

void main() {
  testWidgets('PoliRide Penumpang app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PoliridePenumpangApp());
    expect(find.byType(PoliridePenumpangApp), findsOneWidget);
  });
}
