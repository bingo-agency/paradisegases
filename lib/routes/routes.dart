import 'package:flutter/material.dart';
import '../pages/splash/splash.dart';
import '../pages/home/home.dart';
import '../pages/auth/login.dart';

class RouteManager {
  static const String splashPage = '/';
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPage:
        return MaterialPageRoute(
          builder: (context) => const Splash(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => Home(),
        );
      default:
        throw const FormatException('Route not found, Check routes again');
    }
  }
}
