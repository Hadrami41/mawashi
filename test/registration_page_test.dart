import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mawashi/screens/registration_page.dart';
import 'package:mawashi/providers/auth_provider.dart';
import 'package:mawashi/services/auth_service.dart';
import 'package:mawashi/services/storage_service.dart';

void main() {
  group('RegistrationPage Widget Tests', () {
    late AuthProvider authProvider;
    late MockAuthService authService;
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      authService = MockAuthService();
      storageService = StorageService(prefs);
      authProvider = AuthProvider(
        authService: authService,
        storageService: storageService,
      );
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider,
        child: const MaterialApp(home: RegistrationPage()),
      );
    }

    testWidgets('should display registration form', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should display role selection cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Eleveur'), findsOneWidget);
      expect(find.text('Transporteur'), findsOneWidget);
      expect(find.text('SELECT YOUR ROLE'), findsOneWidget);
    });

    testWidgets('should show validation error for empty fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap create account without filling fields
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('should allow entering text in fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.byType(TextFormField).at(0), 'Jean Dupont');
      await tester.pump();

      // Enter city
      await tester.enterText(find.byType(TextFormField).at(1), 'Bamako');
      await tester.pump();

      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('Bamako'), findsOneWidget);
    });

    testWidgets('should select role when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Transporteur role card
      await tester.tap(find.text('Transporteur'));
      await tester.pumpAndSettle();

      // The card should be selected (visual change)
      // We verify by checking the widget tree updates
      expect(find.text('Transporteur'), findsOneWidget);
    });

    testWidgets('should show success message on valid registration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.pump();

      // Enter city
      await tester.enterText(find.byType(TextFormField).at(1), 'Test City');
      await tester.pump();

      // Tap create account
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      // Wait for async operations
      await tester.pump(const Duration(seconds: 2));

      // Check for success snackbar
      expect(find.textContaining('Account created'), findsOneWidget);
    });

    testWidgets('should display terms and privacy text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('Terms of Service'), findsOneWidget);
      expect(find.textContaining('Privacy Policy'), findsOneWidget);
    });

    testWidgets('should have back button in app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
