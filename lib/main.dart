import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/membership_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_gate.dart';
import 'services/database_init.dart';
import 'services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();
  runApp(const NewrozApp());
}

class NewrozApp extends StatelessWidget {
  const NewrozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(DatabaseService.instance)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(DatabaseService.instance)..init(),
        ),
        ChangeNotifierProvider(create: (_) => MembershipProvider()..init()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.mode,
          home: const AuthGate(),
        ),
      ),
    );
  }
}
