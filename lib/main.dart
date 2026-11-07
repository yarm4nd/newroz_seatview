import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth_gate.dart';
import 'services/database_init.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(DatabaseService.instance)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(DatabaseService.instance)..init(),
        ),
      ],
      child: const NewrozApp(),
    ),
  );
}

class NewrozApp extends StatelessWidget {
  const NewrozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
