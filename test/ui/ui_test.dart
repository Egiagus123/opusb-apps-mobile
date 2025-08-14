import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:apps_mobile/ui/screens/login/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app/ui/your_widget.dart'; // Ganti dengan path yang sesuai

void main() {
  testWidgets('UI should display correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: LoginBody())); // Ganti dengan widget yang ingin diuji
    await tester.pumpAndSettle();
    expect(find.text('LOGIN'),
        findsOneWidget); // Ganti dengan teks yang diharapkan
  });
}
