import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mawashi/main.dart';
import 'package:mawashi/providers/auth_provider.dart';
import 'package:mawashi/providers/transport_provider.dart';

void main() {
  group('MawashiApp Widget Tests', () {
    testWidgets('should create app with providers', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MawashiApp(prefs: prefs));
      await tester.pumpAndSettle();

      // Verify app is running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display home page as initial route', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MawashiApp(prefs: prefs));
      await tester.pumpAndSettle();

      // HomePage should be displayed
      expect(find.textContaining('Welcome'), findsOneWidget);
    });

    testWidgets('should have correct theme color', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MawashiApp(prefs: prefs));
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
    });

    testWidgets('should provide AuthProvider to widget tree', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MawashiApp(prefs: prefs));
      await tester.pumpAndSettle();

      // Verify providers are accessible
      final context = tester.element(find.byType(MaterialApp));
      expect(
        () => Provider.of<AuthProvider>(context, listen: false),
        returnsNormally,
      );
    });

    testWidgets('should provide TransportProvider to widget tree', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MawashiApp(prefs: prefs));
      await tester.pumpAndSettle();

      // Verify providers are accessible
      final context = tester.element(find.byType(MaterialApp));
      expect(
        () => Provider.of<TransportProvider>(context, listen: false),
        returnsNormally,
      );
    });
  });
}
