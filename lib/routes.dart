import 'package:flutter/material.dart';
import 'package:truthscan_app/views/splash_screen.dart';
import 'package:truthscan_app/views/login_screen.dart';
import 'package:truthscan_app/views/register_screen.dart';
import 'package:truthscan_app/views/home_screen.dart';
import 'package:truthscan_app/views/analyze_screen.dart';
import 'package:truthscan_app/views/history_screen.dart';
import 'package:truthscan_app/views/profile_screen.dart';
import 'package:truthscan_app/views/onboarding_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String analyze = '/analyze';
  static const String history = '/history';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case analyze:
        return MaterialPageRoute(builder: (_) => AnalyzeScreen());
      case history:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (_) => SplashScreen(),
      login: (_) => LoginScreen(),
      register: (_) => RegisterScreen(),
      home: (_) => HomeScreen(),
      analyze: (_) => AnalyzeScreen(),
      history: (_) => HistoryScreen(),
      profile: (_) => ProfileScreen(),
    };
  }

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
