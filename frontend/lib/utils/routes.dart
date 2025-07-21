import 'package:flutter/material.dart';
import 'package:springr/pages/auth/login/login_page.dart';
import 'package:springr/pages/auth/register/register_page.dart';
import 'package:springr/pages/splash/splash_page.dart';
import 'package:springr/utils/constants.dart';
import 'package:springr/pages/dashboard/dashboard_page.dart';
import 'package:springr/pages/card/card_page.dart';
import '../pages/main/green_society.dart';
import '../pages/navigation/navigation_page.dart';
import '../pages/main/eco_point_page.dart';
import '../pages/main/green_activity_page.dart';
import 'package:springr/pages/auth/profile/profile_page.dart';


class RouteGenerator {

  // AppRoutes
  static const String loginPage = 'loginPage';
  static const String registerPage = 'registerPage';
  static const String splashPage = 'splashPage';
  static const String dashboardPage = 'dashboardPage';
  static const String cardPage = 'cardPage';
  static const String navigationPage = 'navigationPage';
  static const String ecopointPage = 'ecopointPage';
  static const String greenActivityPage = 'greenActivityPage';
  static const String greenSocietyPage = 'greenSocietyPage';
  static const String profilePage = 'profilePage';

  // Routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case splashPage:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case dashboardPage:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case cardPage:
        return MaterialPageRoute(builder: (_) => const CardPage());
      case navigationPage:
        return MaterialPageRoute(builder: (_) => const NavigationPage());
      case ecopointPage:
        return MaterialPageRoute(builder: (_) => const EcoPointPage());
      case greenActivityPage:
        return MaterialPageRoute(builder: (_) => const GreenActivityPage());
      case greenSocietyPage:
        return MaterialPageRoute(builder: (_) => const GreenSocietyPage());
      case registerPage:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return _errorRoute();
    }
  }



  // Error Route
static Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Page not Found',
          style: TextStyle(
              color: secondaryColor,
              fontSize: 20),
        ),
      ),
    );
   });
  }
}