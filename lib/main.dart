import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'providers/admin_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/membership_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_gate.dart';
import 'screens/language_screen.dart';
import 'services/database_init.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();

  final db = DatabaseService.instance;
  final auth = AuthProvider(db);
  final booking = BookingProvider(db);
  final membership = MembershipProvider();
  final theme = ThemeProvider();
  final locale = LocaleProvider();
  final admin = AdminProvider();

  await Future.wait([auth.init(), booking.init(), membership.init(), theme.init(), locale.init()]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: booking),
        ChangeNotifierProvider.value(value: membership),
        ChangeNotifierProvider.value(value: theme),
        ChangeNotifierProvider.value(value: locale),
        ChangeNotifierProvider.value(value: admin),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const NewrozApp(),
    ),
  );
}

class NewrozApp extends StatelessWidget {
  const NewrozApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightFor(isRtl: localeProvider.isRtl),
      darkTheme: AppTheme.darkFor(isRtl: localeProvider.isRtl),
      themeMode: themeProvider.mode,
      builder: (context, child) {
        return Directionality(
          textDirection: localeProvider.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: localeProvider.hasChosenLanguage
          ? const AuthGate()
          : const LanguageScreen(),
    );
  }
}
