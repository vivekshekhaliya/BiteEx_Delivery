import 'package:bite_ex_delivery/res/routes/screen_export.dart';
import 'package:bite_ex_delivery/view/sign_in_view/sign_in_screen.dart';

import '../../view/bottom_navigation_bar_view/bottom_navigation_bar_screen.dart';
import '../../view/error_view/route_error_screen.dart';
import '../../view/splash_view/splash_screen.dart';

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
