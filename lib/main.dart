import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:wx3_interface/app/themes/theme_provider.dart';
import 'package:wx3_interface/app/themes/light_theme.dart';
import 'package:wx3_interface/app/themes/dark_theme.dart';
import 'package:wx3_interface/features/auth/login_screen.dart';
import 'package:wx3_interface/features/sensors/sensor_screen.dart';
import 'package:wx3_interface/features/profile/profile_screen.dart';
import 'package:wx3_interface/features/settings/settings_screen.dart';
import 'package:wx3_interface/features/compass/compass_screen.dart';
import 'package:wx3_interface/core/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'WX3 Interface',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/sensors':
            final user = settings.arguments as UserModel;
            return MaterialPageRoute(builder: (_) => SensorScreen(user: user));
          case '/profile':
            final user = settings.arguments as UserModel;
            return MaterialPageRoute(builder: (_) => ProfileScreen(user: user));
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/compass':
            return MaterialPageRoute(builder: (_) => const CompassScreen());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Route not found')),
              ),
            );
        }
      },
    );

  }
}
