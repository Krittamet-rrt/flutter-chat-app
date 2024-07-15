import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/auth/landing_page.dart';
import 'package:flutter_chat_app/auth/login_page.dart';
import 'package:flutter_chat_app/auth/otp_page.dart';
import 'package:flutter_chat_app/auth/user_information_page.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/settings_page.dart';
import 'package:flutter_chat_app/providers/authentication_provider.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: Constants.landingPage,
        routes: {
          Constants.landingPage: (context) => const LandingPage(),
          Constants.loginPage: (context) => const LoginPage(),
          Constants.otpPage: (context) => const OtpPage(),
          Constants.userInformationPage: (context) =>
              const UserInformationPage(),
          Constants.homePage: (context) => const HomePage(),
          Constants.profilePage: (context) => const ProfilePage(),
          Constants.settingsPage: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
