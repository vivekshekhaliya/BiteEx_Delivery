import 'dart:async';
import 'dart:io';

import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/res/constants/app_colors.dart';
import 'package:bite_ex_delivery/res/constants/app_url.dart';
import 'package:bite_ex_delivery/res/routes/routes.dart';
import 'package:bite_ex_delivery/res/routes/routes_name.dart';
import 'package:bite_ex_delivery/services/web_socket_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'view_model/auth_view_model.dart';
import 'view_model/user_view_model.dart';
import 'view_model/rider_view_model.dart';
import 'data/network/api_client.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // This will handle background messages
  debugPrint('Background message received: ${message.toMap()}');
  debugPrint('Background message received: ${message.notification?.title}');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ApiClient.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
      debugPrint('Notification tapped: ${response.payload}');
    },
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => RiderViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isDialogVisible = false;

  final socket = WebSocketManager();

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );

    socket.connect(AppUrl.socketUrl);

    socket.subscribe("price-channel");
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> result,
  ) async {
    final hasInternet = await _hasInternetConnection();
    if (result.first == ConnectivityResult.none && !hasInternet) {
      if (!_isDialogVisible) {
        _showInternetDialog(navigatorKey.currentContext);
        _isDialogVisible = true;
      }
    } else {
      if (_isDialogVisible) {
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
        _isDialogVisible = false;
      }
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Android: light icons (white)
        statusBarBrightness:
            Brightness.dark, // iOS: dark background = light (white) text
        systemNavigationBarColor: AppColors.secondaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(AppColors.secondaryColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {TargetPlatform.android: CustomPageTransition()},
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }

  void _showInternetDialog(BuildContext? context) {
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            left: 40,
            right: 40,
            bottom: 40,
          ),
          backgroundColor: AppColors.jetGrayColor,
          actionsPadding: const EdgeInsets.all(20),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: Lottie.asset(
            'assets/lotties/no_internet.json',
            height: 100,
            width: 100,
          ),
          iconPadding: const EdgeInsets.only(top: 30, bottom: 20),
          titlePadding: const EdgeInsets.only(bottom: 20),
          title: const CustomText(
            data: 'Oops!',
            color: AppColors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          content: const CustomText(
            data: 'No Internet connection found.\nCheck your connection.',
            color: AppColors.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-0.3, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }
}
