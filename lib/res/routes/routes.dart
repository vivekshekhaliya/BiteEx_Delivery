import 'package:bite_ex_delivery/res/routes/screen_export.dart';

/// This class manages app-wide route generation for navigation.
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesName.signInScreen:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case RoutesName.bottomNavigationBarScreen:
        return MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen(),
        );
      case RoutesName.faqScreen:
        return MaterialPageRoute(builder: (context) => const FaqScreen());
      case RoutesName.aboutScreen:
        return MaterialPageRoute(builder: (context) => const AboutScreen());
      case RoutesName.helpSupportScreen:
        return MaterialPageRoute(
          builder: (context) => const HelpSupportScreen(),
        );
      case RoutesName.routeError:
        return MaterialPageRoute(
          builder: (context) => RouteErrorScreen(routeName: settings.name),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => RouteErrorScreen(routeName: settings.name),
        );
    }
  }
}
