import 'package:flutter/material.dart';
import 'package:truthscan_app/services/auth_services.dart';
import 'package:truthscan_app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    bool isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('lib/assets/images/detectai.png', height: 80),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
