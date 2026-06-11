import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_document_picker_example/main.dart';

void main() {
  testWidgets('App renders example screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Plugin example app'), findsOneWidget);
    expect(find.text('Picked file path:'), findsOneWidget);
  });
}
