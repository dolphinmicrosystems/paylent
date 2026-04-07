import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/constants.dart';
import 'package:paylent/screens/auth/auth_entry_screen.dart';
import 'package:paylent/screens/auth/email_login_screen.dart';
import 'package:paylent/screens/auth/fingerprint_login_screen.dart';
import 'package:paylent/screens/auth/forgot_password_screen.dart';
//import 'package:paylent/screens/auth/google_login_screen.dart';
import 'package:paylent/screens/main/home_screen.dart';
import 'package:paylent/screens/splash/splash_screen.dart';
import 'package:paylent/theme/app_theme.dart';

/// A global `ValueNotifier` for managing the application's theme mode.
///
/// Using a `ValueNotifier` allows for efficient theme switching without needing
/// a full state management library. Widgets that need to react to theme changes
/// can listen to this notifier and rebuild automatically.
ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

/// The main entry point of the application.
Future<void> main() async {
  await dotenv.load();
  await Firebase.initializeApp();
  runApp(
     const ProviderScope(
      child: PaylentApp(),
    ),
 );
}

/// The root widget of the Paylent application.
class PaylentApp extends StatelessWidget {
  /// Creates a new instance of the PaylentApp.
  const PaylentApp({super.key});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (final BuildContext context, final ThemeMode mode,
            final Widget? _) =>
            MaterialApp(
          title: 'Paylent',

          // Defines the light theme for the application.
          theme: AppTheme.light,

          // Defines the dark theme for the application.
          darkTheme: AppTheme.dark,

          // Sets the current theme mode based on the `themeMode` notifier.
          themeMode: mode,

          // Sets the initial route of the application.
          initialRoute: AppRoutes.splash,

          // Defines the named routes for navigation.
          routes: {
            AppRoutes.splash: (final BuildContext context) => const SplashScreen(),
            AppRoutes.authEntry: (final BuildContext context) =>
                const AuthEntryScreen(),
            AppRoutes.emailLogin: (final BuildContext context) =>
                const EmailLoginScreen(),
            AppRoutes.fingerprintLogin: (final BuildContext context) =>
                const FingerprintLoginScreen(),
            // AppRoutes.googleLogin: (final BuildContext context) =>
            //     const GoogleLoginScreen(),
            AppRoutes.home: (final BuildContext context) => const HomeScreen(),
            AppRoutes.forgotPassword: (final context) => const ForgotPasswordScreen(),
          },
        ),
      );
}
