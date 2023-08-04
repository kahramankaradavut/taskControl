import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:on_duty/services/notification_service.dart';
import 'package:on_duty/states/states.dart';
import 'package:provider/provider.dart';

import 'design/app_theme_data.dart';
import 'firebase_options.dart';
import 'routes/routes.dart';

bool? hasInternet;

Future<void> main() async {
  void checkInternet() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
  }
  checkInternet();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundNotification);
  initializeDateFormatting('tr_TR', null).then((_) => runApp(
    ChangeNotifierProvider<States>(
      create: (BuildContext context) => States(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState()  {
    super.initState();
    _notificationService.connect(context);
    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(isAdmin) Navigator.pushNamed(context, "notifications_screen");
    });*/
  }

  @override
  Widget build(BuildContext context) {
    hasInternet ??= false;
    return MaterialApp(
      title: "On Duty",
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme(context),
      themeMode: ThemeMode.light,
      darkTheme: AppThemeData.darkTheme(context),
      initialRoute: hasInternet! ? (_auth.currentUser != null ? "home_screen" : "login_screen"):"network_error_screen",
      onGenerateRoute: (settings) => routeTo(settings.name!),
    );
  }
}
