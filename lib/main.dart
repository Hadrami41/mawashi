import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import 'services/services.dart';

// Providers
import 'providers/providers.dart';

// Screens
import 'screens/registration_page.dart';
import 'screens/home_page.dart';
import 'screens/groupage_page.dart';
import 'screens/trip_tracking_page.dart';
import 'screens/find_transport_page.dart';
import 'screens/transporters_list_page.dart';
import 'screens/transport_request_page.dart';
import 'screens/my_truck_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MawashiApp(prefs: prefs));
}

class MawashiApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MawashiApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<StorageService>(create: (_) => StorageService(prefs)),
        Provider<AuthService>(create: (_) => MockAuthService()),
        Provider<TransportService>(create: (_) => MockTransportService()),

        // Auth Provider
        ChangeNotifierProxyProvider2<AuthService, StorageService, AuthProvider>(
          create: (context) => AuthProvider(
            authService: context.read<AuthService>(),
            storageService: context.read<StorageService>(),
          ),
          update: (context, authService, storageService, previous) =>
              previous ??
              AuthProvider(
                authService: authService,
                storageService: storageService,
              ),
        ),

        // Transport Provider
        ChangeNotifierProxyProvider<TransportService, TransportProvider>(
          create: (context) => TransportProvider(
            transportService: context.read<TransportService>(),
          ),
          update: (context, transportService, previous) =>
              previous ?? TransportProvider(transportService: transportService),
        ),
      ],
      child: MaterialApp(
        title: 'Mawashi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4ADE80),
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomePage(),
          '/registration': (context) => const RegistrationPage(),
          '/groupage': (context) => const GroupagePage(),
          '/tracking': (context) => const TripTrackingPage(),
          '/find-transport': (context) => const FindTransportPage(),
          '/transporters': (context) => const TransportersListPage(),
          '/transport-request': (context) => const TransportRequestPage(),
          '/my-truck': (context) => const MyTruckPage(),
        },
      ),
    );
  }
}
